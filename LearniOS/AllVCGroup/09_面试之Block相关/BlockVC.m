//
//  BlockVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/21.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "BlockVC.h"

@interface BlockVC ()

@end

@implementation BlockVC

/*
 什么是Block
    Block是将函数及其执行上下文封装起来的对象
 
 截获变量
    局部变量
        基本数据类型：截获其值
        对象类型：连同所有权修饰符一起截获
    局部静态变量
        以指针形式截获
    不截获全局变量和静态全局变量
 
 __block修饰符
    一般情况下，对被截获变量进行赋值(并非使用)操作需要添加__block修饰符
    赋值时需要添加__block:
        局部变量（包括基本数据类型和对象类型）
    赋值时不需要添加__block:
        静态局部变量、全局变量、静态全局变量
        
 
 Block的内存管理
    block类型：
        _NSConcreteStackBlock 栈中的block      copy-> 堆
        _NSConcreteMallocBlock 堆中的block     copy-> 增加引用计数
        _NSConcreteGlobalBlock 全局block       copy-> 什么都不做
    block默认在栈上，当block变量所在作用域结束之后，__block变量和Block都会被销毁。之后再使用Block可能引发一些问题。因此，block的属性修饰符一般用copy
 
 Block的循环引用
 */

// 全局变量
int global_var = 4;
// 静态全局变量
static int static_global_var= 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 局部基本数据类型，值截获
    int multiplier1 = 6;
    // 静态局部变量，指针截获
    static int multiplier2 = 10;
    // __block修饰局部基本数据类型，变成了对象
    __block int multiplier3 = 7;
    NSDictionary *(^mulBlock)(int) = ^NSDictionary *(int num) {
        return @{
            @"局部基本数据类型": @(num * multiplier1),
            @"局部静态变量": @(num * multiplier2),
            @"__block修饰基本数据类型": @(num * multiplier3)
        };
    };
    multiplier1 = 4;
    multiplier2 = 5;
    multiplier3 = 1;
    NSLog(@"%@", mulBlock(2));
}

@end
