//
//  RuntimeViewController.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/11.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "RuntimeViewController.h"
#import "RuntimePerson.h"
#import "RuntimeStudent.h"
#import "RuntimeMan.h"

@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"16、底层之Runtime";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self runtimeBase];
    
    [self runtimeObjcMsgSend];
}

- (void)runtimeBase {
    /*
     1、OC是一门动态性比较强的编程语言，与C、C++等语言有很大的不同。
     	Runtime，运行时，提供了一套C语言的API
     2、在arm64架构之前，isa就是一个普通的指针，存储着Class、Meta-Class对象的内存地址。
     	从arm64架构开始，对isa进行了优化，变成了一个共用体（union）结构，还使用位域来存储更多的信息。
     3、优化过的isa存储的信息：
     union isa_t {
     	Class cls;
     	uintptr_t bits;
     	struct {
     		// 0代表普通指针，存储Class、Meta-Class对象的内存地址
     		// 1代表优化过，使用位域存储更多信息。
     		uintptr_t nonpointer            : 1;
     
     		// 是否设置过关联对象，如果没有，释放更快
     		uintptr_t has_assoc                : 1;
     
     		// 是否有C++的析构函数，如果没有，释放更快
     		uintptr_t has_cxx_dtor            : 1;
     
     		// 存储Class、Meta-Class对象的内存地址
     		uintptr_t shiftcls                : 33;
     
     		// 用于调试时分辨对象是否未完成初始化
     		uintptr_t magic                    : 6;
     
     		// 是否有被弱引用指向过，如果没有，释放更快
     		uintptr_t weakly_referenced        : 1;
     
     		// 对象是否正在释放
     		uintptr_t deallocating            : 1;
     
     		// 引用计数是否过大无法存储在isa中。如果为1，引用计数存储在一个叫SideTable的类的属性中
     		uintptr_t has_sidetable_rc        : 1;
     
     		// 里边存储的值是引用计数-1
     		uintptr_t extra_rc                : 19;
        };
     };
     4、Class、Meta-Class对象的地址，最后三位一定是0。因为ISA_MASK最后三位的二进制都是0
     	（16进制最后一位为8/0），isa & ISA_MASK 位运算结果就是Class、Meta-Class对象的地址。
     
     5、class_rw_t中的methods、properties、protocols是二维数组，可读可写，
     	包含了类的初始内容、分类中合并过来的内容
     	class_ro_t中的methods、properties、protocols是一维数组，只读，只包含类中的初始内容。
     
     6、method_t是对方法/函数的封装
     	struct method_t {
     		SEL name;    // 函数名
     		const char *types; // 编码（返回值、参数类型）
     		IMP imp;    // 指向函数的指针（函数地址）
     	}
     	SEL代表方法名/函数名，一般叫做选择器，底层结构跟char *类似
     		. 可以通过@selector()和sel_registerName()获得
     		. 可以通过sel_getName()和NSStringFromSelector()转成字符串
     		. 不同类中相同名字的方法，所对应的方法选择器是相同的
     	iOS中提供了一个叫做@encode的指令，可以将具体的类型表示成字符串编码
     
     7、Class内部结构有一个方法缓存cache_t，用散列表（哈希表）缓存调用过的方法，提高方法查找速度
     	struct cache_t {
     		struct bucket_t *_buckets;    // 散列表
     		mask_t _mask;    // 散列表的长度 - 1
     		mask_t _ocupied;// 已经缓存的方法数量
     	}
     
     	struct bucket_t {
     		cache_key_t _key;    // SEL作为key
     		IMP _imp;    // 函数的内存地址
     	}
     */

    
    // 位运算+位域实现
    RuntimePerson *person = [[RuntimePerson alloc] init];
    person.tall = NO;
    person.rich = YES;
    person.handsome = YES;
    NSLog(@"%@", person);
    
    // 结构体+位域实现
    RuntimeStudent *student = [[RuntimeStudent alloc] init];
    student.tall = YES;
    student.rich = NO;
    student.handsome = YES;
    NSLog(@"%@", student);
    
    // union+位运算+位域实现
    RuntimeMan *man = [[RuntimeMan alloc] init];
    man.tall = YES;
    man.rich = YES;
    man.handsome = NO;
    NSLog(@"%@", man);
}

- (void)runtimeObjcMsgSend {
    /*
     1、objc_msgSend执行流程
     	. 消息发送
     	. 动态方法解析
     		+ (BOOL)resolveInstanceMethod:(SEL)sel;
     			. class_addMethod(self , sel, IMP, types);
     		+ (BOOL)resolveClassMethod:(SEL)sel;
                . class_addMethod(object_getClass(self), sel, IMP, types);
     		之后会再次重新走消息发送流程
     	. 消息转发
     		. forwardingTargetForSelector:(SEL)aSelector 返回能够处理aSelector的对象
     		. methodSignaturForSelector:(SEL)aSelector 返回NSMethodSignature方法签名
     			return [NSMethodSignature signatureWithObjcTypes:"v@:"];
     		. forwardInvocation:(NSInvocation *)anInvocation 在这里可以处理任何操作
     			anInvocation封装了一个方法调用：方法调用者、方法名、方法参数
     			anInvocation.target  anInvocation.selector  [anInvocation getArgument: atIndex]
     
     2、dynamic是告诉编译器不用自动生成getter/setter的实现，不自动生成成员变量，等到运行时再添加方法实现
     */
}

@end
