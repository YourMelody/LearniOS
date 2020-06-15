//
//  RAMManagerVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/20.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "RAMManagerVC.h"
#import "NSTimer+WeakTimer.h"

@interface RAMManagerVC ()

@end

@implementation RAMManagerVC

/*
 自旋锁
    是“忙等”的锁（不断探测锁是否释放）
    适用于轻量访问
 引用计数表是通过hash查找实现的，为了提高查找效率
 
 MRC 手动引用计数
 ARC 自动引用计数，是LLVM和Runtime协作的结果，禁止手动调用retain/release/retainCount/dealloc
    alloc实现：
        经过一系列调用，最终调用了C函数的calloc
        此时并没有设置引用计数为1
    retain实现：
        经过两次hash查找，找到对应的引用计数值，然后进行+1操作
    dealloc实现：
        开始_objc_rootDealloc()
        -> rootDealloc()
        -> 判断是否可释放
            YES -> C函数free()
            NO -> object_dispose()
 
 弱引用管理
    id __weak obj1 = obj;
    -> 编译后 id obj1;
             objc_initWeak(&obj1, obj);
 
 在for循环中alloc图片数据等内存消耗较大的场景，手动插入autoreleasePool，降低内存使用的峰值
 
 三种循环引用：
    自循环引用  对象A，其成员变量obj（strong），obj赋值为A的元对象，造成自循环引用
    相互循环引用
    多循环引用
 __block 在MRC下，其修饰的对象不会增加其引用计数，可以避免循环引用。在ARC下，对象会被强引用，不能避免循环引用。
 
 NSTimer循环引用问题
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledWeakTimerWithTimeInterval:1 target:self selector:@selector(test) userInfo:@{} repeats:YES];
}

- (void)test {
    NSLog(@"test---");
}

@end
