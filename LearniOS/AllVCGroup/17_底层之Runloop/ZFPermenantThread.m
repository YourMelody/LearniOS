//
//  ZFPermenantThread.m
//  LearniOS
//
//  Created by JKFunny on 2020/3/14.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "ZFPermenantThread.h"

@interface ZFPermenantThread ()

@property (nonatomic, strong)NSThread *innerThread;
@property (nonatomic, assign)BOOL canStop;

@end

@implementation ZFPermenantThread

- (instancetype)init {
    if (self = [super init]) {
        __weak typeof(self) weakSelf = self;
        self.innerThread = [[NSThread alloc] initWithBlock:^{
            NSLog(@"-----begin----- %@", [NSThread currentThread]);
                
            // 往RunLoop里边添加Source/Timer/Obserber，让线程保活
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            // 注意：NSRunLoop的run方法是无法停止的，它专门用于开启一个用不销毁的线程。
            // [[NSRunLoop currentRunLoop] run];
            while (weakSelf && !weakSelf.canStop) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
                
            NSLog(@"%s -----end-----", __func__);
        }];
        [self.innerThread start];
    }
    return self;
}

// 执行任务
- (void)executeTask:(void(^)(void))taskBlock {
    if (!self.innerThread || !taskBlock) return;
    [self performSelector:@selector(taskAction:) onThread:self.innerThread withObject:taskBlock waitUntilDone:NO];
}

- (void)taskAction:(void(^)(void))task {
    task();
}

// 关闭线程
- (void)stop {
    if (!self.innerThread) return;
    [self performSelector:@selector(stopAction) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)stopAction {
    self.canStop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

@end
