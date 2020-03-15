//
//  ZFProxy.m
//  LearniOS
//
//  Created by JKFunny on 2020/3/15.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "ZFProxy.h"

@interface ZFProxy ()

@property (nonatomic, weak)id target;

@end

@implementation ZFProxy

+ (instancetype)proxyWithTarget:(id)target {
    ZFProxy *proxy = [[ZFProxy alloc] init];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

@end
