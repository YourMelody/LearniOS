//
//  BlockViewController.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/9.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "BlockViewController.h"

@interface BlockViewController ()

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"底层之block";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self blockBase];
    
    [self blockTypes];
    
    [self blockxiushifu];
}

int c = 10;
static int d = 10;
- (void)blockBase {
    /*
     1、block本质上是一个OC对象，它内部也有一个isa指针。
     	block是封装了函数调用以及函数调用环境的OC对象。
      	block底层实现数据结构如下：
     struct __main_block_desc_0 {
     	size_t reserved;	// 保留字段，暂时没有用到
     	size_t Block_size;	// block需要多少内存
     }
     
     struct __block_impl {
     	void *isa;
     	int Flags;
     	int Reserved;
     	void *FuncPtr;	// 指向了block最终要执行的代码地址
     }
     
     // block
     struct __main_block_impl_0 {
     	struct __block_impl impl;
     	struct __main_block_desc_0 *Desc;	// block的描述信息
     	// 这里还可能有其他捕获的变量，如int age;
     }
     2、局部变量：
     	auto变量：自动变量，离开作用域自动销毁
     		会被捕获到block内部，值传递。block内部会生成一个同样的变量，保存捕获到的auto变量的值。
     		如block外部有int age;捕获到block内部同样为int age;并且会保存捕获时候的外部age的值。
     	static变量：静态变量
     		会被捕获到block内部，指针传递。如block外部有静态变量 static int height;
     		捕获到block内部为int *height;
     	全局变量：不捕获，直接访问
     */
    // 等价于 auto int a = 10; 默认auto可以不写
    int a = 10;
    static int b = 10;
    void(^block)(void) = ^{
        NSLog(@"a = %d, b = %d, c = %d, d = %d", a, b, c, d);
    };
    
    // a = 10, b = 10, c = 10, d = 10
    block();
    
    a = 20;
    b = 20;
    c = 20;
    d = 20;
    
    // a = 10, b = 20, c = 20, d = 20
    block();
}

// block的几种类中
- (void)blockTypes {
    /*
     1、block有3种类型，可以通过调用class方法或者isa指针查看具体类型，最终都继承自NSBlock类型。
     	而NSBlock又继承自NSObject。
     	__NSGlobalBlock__ （_NSConcreteGlobalBlock_）
     			----> 数据区
     	__NSMallocBlock__ (_NSConcreteMallocBlock_)
     			----> 堆 动态分配内存，需要开发者申请空间/释放
     	__NSStackBlock__ (_NSConcreteStackBlock_)
     			----> 栈 系统自动分配内存/自动销毁
     
     2、__NSGlobalBlock__ 没有访问auto变量（只访问全局变量/static变量仍然是__NSGlobalBlock__）
     	__NSStackBlock__ 访问了auto变量（但是在ARC系统自动做了一些处理，所以在ARC环境下，
     		某些情况下访问了auto变量最终会变为__NSMallocBlock__）
     	__NSMallocBlock__ StackBlock进行一次copy操作就升级为__NSMallocBlock__
     	[GlobalBlock copy] --> 什么也不做
     	[StackBlock copy]  --> 升级为MallocBlock，从栈复制到堆
     	[MallockBlock copy]--> 引用计数+1
     
     3、在ARC环境下，编译器会根据情况自动将栈上的block复制到堆上，比如一下情况：
     	. block作为返回值
     	. 有强指针指向block
     	. block作为Cocoa API中方法名含有UsingBlock的方法参数时
     	. GCD的block
     
     4、当block内部访问了对象类型的auto变量时，block的Desc内部会多两个函数：copy和dispose
     	. 如果block在栈上，block内部永远不会对auto变量产生强饮用（不论MRC/ARC）
     	. 如果block拷贝到堆上， 会调用copy函数，copy内部又会调用_Block_object_assign函数，
     	  该函数会根据auto变量的修饰符（__strong __weak __unsafe_unretained）做出
     	  相应的操作（即产生强引用/弱引用）
          如果block从堆上移除，会调用block内部的dispose函数，dispose内部又会调用
     	  _Block_object_dispose函数。该函数会自动释放引用的auto变量，类似于release
     	即 copy函数    ---  栈上的block复制到堆上时
           dispose函数 ---  堆上的block被废弃时
     */
    
    void(^block)(void) = ^{
        NSLog(@"Hello, world!");
    };
    // __NSGlobalBlock__ -> __NSGlobalBlock -> NSBlock -> NSObject
    NSLog(@"%@ -> %@ -> %@ -> %@",
          [block class],
          [[block class] superclass],
          [[[block class] superclass] superclass],
          [[[[block class] superclass] superclass] superclass]);
    
    int age = 10;
    void(^block2)(void) = ^{
        NSLog(@"age = %d", age);
    };
    
    // __NSGlobalBlock__  __NSMallocBlock__  __NSStackBlock__
    NSLog(@"%@  %@  %@", [block class], [block2 class], [^{
        NSLog(@"age = %d", age);
    } class])
}


// __block修饰符
- (void)blockxiushifu {
    /*
     1、__block可以用于解决block内部无法修改auto变量值的问题，__block不能修饰
     	全局变量和static变量。__block修饰的变量，编译器会将其封装为一个对象，例如
     	__block int age = 10; 经编译器编译之后，在block内部会转换为如下类型：
     	struct __Block_byref_age_0 {
     		void *isa;
     		__Block_byref_age_0 *__forwarding; // 指向自己
     		int __flags;
     		int __size;
     		int age;  // 值为10
     	}
     	并且，block内部会产生一个 __Block_byref_age_0 *age 变量。
     	block内部访问该age过程：age(__Block_byref_age_0类型的指针) -> __forwarding -> age(int类型的值)
     */
    
    __block int age = 10;
    void(^block)(void) = ^{
        age = 20;
        NSLog(@"1---age = %d", age);
    };
    block();
    NSLog(@"2---age = %d", age);
}

@end
