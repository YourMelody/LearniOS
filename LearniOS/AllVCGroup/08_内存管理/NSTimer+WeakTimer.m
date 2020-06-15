//
//  NSTimer+WeakTimer.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/20.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "NSTimer+WeakTimer.h"

// 中间对象
@interface TimerWeakObject : NSObject

@property (nonatomic, weak)id target;
@property (nonatomic, assign)SEL selector;
@property (nonatomic, weak)NSTimer *timer;

- (void)fire:(NSTimer *)timer;

@end

@implementation TimerWeakObject

- (void)fire:(NSTimer *)timer {
    if (self.target) {
        if ([self.target respondsToSelector:self.selector]) {
            [self.target performSelector:self.selector withObject:timer.userInfo];
        }
    } else {
        [self.timer invalidate];
    }
}

@end

@implementation NSTimer (WeakTimer)

+ (NSTimer *)scheduledWeakTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    TimerWeakObject *weakObj = [[TimerWeakObject alloc] init];
    weakObj.target = aTarget;
    weakObj.selector = aSelector;
    weakObj.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:weakObj selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
    return weakObj.timer;
}

@end
