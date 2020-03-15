//
//  SystemProxy.m
//  LearniOS
//
//  Created by JKFunny on 2020/3/15.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "SystemProxy.h"

@interface SystemProxy ()

@property (nonatomic, weak)id target;

@end

@implementation SystemProxy

+ (instancetype)proxyWithTarget:(id)target {
    SystemProxy *proxy = [SystemProxy alloc];
    proxy.target = target;
    return proxy;
}

// 像NSProxy发送消息，不会走objc_msgSend流程，直接到methodSignatureForSelector
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
