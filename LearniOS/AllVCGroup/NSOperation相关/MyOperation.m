//
//  MyOperation.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/11.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "MyOperation.h"

@implementation MyOperation

- (void)start {
    NSLog(@"start---begin---%@", [NSThread currentThread]);
    [super start];
    NSLog(@"start---end---%@", [NSThread currentThread]);
}

// 一般只重写main方法，不需要管理操作的状态 isExecuting/isFinished
- (void)main {
    NSLog(@"main---begin---%@", [NSThread currentThread]);
    [super main];
    NSLog(@"main---end---%@", [NSThread currentThread]);
}

@end
