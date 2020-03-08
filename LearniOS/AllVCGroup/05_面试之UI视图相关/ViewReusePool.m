//
//  ViewReusePool.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/19.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "ViewReusePool.h"

@interface ViewReusePool ()

// 待使用的队列
@property (nonatomic, strong)NSMutableSet *waitUsedQueue;
// 使用中的队列
@property (nonatomic, strong)NSMutableSet *usingQueue;

@end

@implementation ViewReusePool

- (instancetype)init {
    if (self = [super init]) {
        _waitUsedQueue = [NSMutableSet set];
        _usingQueue = [NSMutableSet set];
    }
    return self;
}

// 从重用池中取一个可重用的view
- (UIView *)dequeueReusableView {
    UIView *view = [self.waitUsedQueue anyObject];
    if (view == nil) {
        return nil;
    } else {
        [self.waitUsedQueue removeObject:view];
        [self.usingQueue addObject:view];
        return view;
    }
}

// 向重用池中添加一个视图
- (void)addUsingView:(UIView *)view {
    if (view != nil) {
        [self.usingQueue addObject:view];
    }
}

// 重置方法，将当前使用中的视图移动到可重用队列中
- (void)reset {
    UIView *view = nil;
    while ((view = [self.usingQueue anyObject])) {
        // 从使用中队列移除
        [self.usingQueue removeObject:view];
        // 加入待使用的队列 
        [self.waitUsedQueue addObject:view];
    }
}

@end
