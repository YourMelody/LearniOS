//
//  GCDVC.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/14.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "GCDVC.h"
#import "GCDBaseLock.h"
#import "OSSpinLockDemo.h"

@interface GCDVC ()

@end

@implementation GCDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"底层之GCD";
    
//    [self threadLock1];
//    [self threadLock2];
    
//    [self interview1];
    
//    [self interview2];
    
//    [self interview3];
    
    OSSpinLockDemo *spinLock = [[OSSpinLockDemo alloc] init];
    [spinLock ticketTest];
    [spinLock moneyTest];
}

// 死锁1
- (void)threadLock1 {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"1-----");
    dispatch_sync(mainQueue, ^{
        NSLog(@"2-----");
    });
    NSLog(@"3-----");
}

// 死锁2
- (void)threadLock2 {
    // 同步向同一个串行队列添加任务，会死锁
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1-----");
    dispatch_async(queue, ^{
        NSLog(@"2-----");
        dispatch_sync(queue, ^{
            NSLog(@"3-----");
        });
        NSLog(@"4-----");
    });
    NSLog(@"5-----");
}

- (void)interview1 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 不会执行test函数，只打印1 3
    dispatch_async(queue, ^{
        NSLog(@"1-----");
        // 向RunLoop中添加定时器，但是当前线程为子线程，RunLoop默认没有开启
        [self performSelector:@selector(test) withObject:nil afterDelay:0];
        NSLog(@"3-----");
    });
}

- (void)interview2 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 打印1 2 3
    dispatch_async(queue, ^{
        NSLog(@"1-----");
        // 实际就是方法调用
        [self performSelector:@selector(test) withObject:nil];
        NSLog(@"3-----");
    });
}

- (void)test {
    NSLog(@"2-----");
}


- (void)interview3 {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1----");
    }];
    [thread start];
    // 只会打印1，并且程序崩溃：target thread exited while waiting for the perform
    // 因为此时thread中的任务已经执行完毕（打印1），thread会退出销毁。
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
}

// 各种锁相关
- (void)aboutLock {
    /*
     1、OSSpinLock：自旋锁，等待锁的线程会处于忙等（busy-wait）状态，一直占用CPU资源
     
     */
}

@end
