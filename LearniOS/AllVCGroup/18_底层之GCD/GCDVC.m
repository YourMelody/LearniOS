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
#import "OSUnfairLockDemo.h"
#import "MutexDemo.h"
#import "NSLockDemo.h"

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
    
    [self aboutLock];
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
        已经废弃，不建议使用，会出现优先级反转问题。需要导入 <libkern/OSAtomic.h>
     
     2、os_unfair_lock：互斥锁，用于取代不安全的OSSpinLock，从iOS10开始支持。从底层调用看，
        等待os_unfair_lock锁的线程会处于休眠状态，并非忙等。需要导入 <os/lock.h>
     
     3、pthread_mutex: 互斥锁，等待锁的线程会处于休眠状态。需要导入<pthread.h>
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT); 为互斥锁
     4、递归锁：允许同一个线程对一把锁重复加锁
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); 为递归锁
     
     5、NSLock是对mutex普通锁（PTHREAD_MUTEX_DEFAULT）的封装
     
     6、NSRecursiveLock是对mutex递归锁（PTHREAD_MUTEX_RECURSIVE）的封装，API和NSLock基本一致
     
     7、NSCondition是对mutex和cond的封装。NSConditionLock是对NSCondition的进一步封装，可以设置具体的条件值
     
     8、利用GCD的串行队列，也可以实现线程同步
     
     9、利用dispatch_semaphore实现线程安全。其初始值用来控制线程访问并发的最大数量
     
     10、@synchronized是对mutex递归锁（PTHREAD_MUTEX_RECURSIVE）的封装
     
     锁的性能比较：
     os_unfair_lock >
     OSSpinLock >
     dispatch_semaphore >
     pthread_mutex(default 互斥锁) >
     dispatch_queue(serial) >
     NSLock >
     NSCondition >
     pthred_mutex(recursive递归锁) >
     NSRecursiveLock >
     NSConditionLock >
     @synchronized
     
     11、atomic用于保证属性setter、getter的原子性操作，相当于在getter/setter内部加了线程同步的锁（spinLock自旋锁）
     
     12、pthread_rwwlock 读写锁
        dispatch_barrier_async 栅栏函数
        可以解决读写操作问题：
        . 同一时间只允许一条线程执行写的操作
        . 允许多条线程执行读的操作
        . 不允许读/写操作同时进行
     */
    
    // 各种锁处理线程安全问题
    MutexDemo *lock = [[MutexDemo alloc] init];
    [lock ticketTest];
    [lock moneyTest];
}

@end
