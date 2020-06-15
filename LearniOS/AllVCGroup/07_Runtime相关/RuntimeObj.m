//
//  RuntimeObj.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/20.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "RuntimeObj.h"
#import <objc/runtime.h>

@implementation RuntimeObj

#pragma mark - 方法交换相关
+ (void)load {
    // 获取test方法
    Method test = class_getInstanceMethod(self, @selector(test));
    // 获取otherTest方法
    Method otherTest = class_getInstanceMethod(self, @selector(otherTest));
    // 交换两个方法的实现
    method_exchangeImplementations(test, otherTest);
}

- (void)test {
    NSLog(@"test");
}

- (void)otherTest {
    // 方法已经交换，实际上会调用test方法的实现
    [self otherTest];
    NSLog(@"otherTest");
}


#pragma mark - 方法转发相关和动态添加方法
void testImp(void) {
    NSLog(@"-----testImp");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(abc)) {
        NSLog(@"111---resolveInstanceMethod:");
        return NO;
    } else if (sel == @selector(testImp)){
        // 动态添加abc方法的实现
        class_addMethod(self, sel, testImp, "v@:");
        return YES;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"222---forwardingTargetForSelector:");
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(abc)) {
        NSLog(@"333---methodSignatureForSelector:");
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"444---forwardInvocation:");
}

@end
