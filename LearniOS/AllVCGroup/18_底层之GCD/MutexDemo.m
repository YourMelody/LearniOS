//
//  MutexDemo.m
//  LearniOS
//
//  Created by JKFunny on 2020/3/15.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "MutexDemo.h"
#import <pthread.h>

@interface MutexDemo ()

@property (nonatomic, assign)pthread_mutex_t moneyLock;
@property (nonatomic, assign)pthread_mutex_t ticketLock;

@end

@implementation MutexDemo

- (void)__initMutex:(pthread_mutex_t *)mutexLock {
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    // 设置锁的属性，PTHREAD_MUTEX_DEFAULT 创建一把互斥锁，对同一把锁重复加锁会产生死锁。
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    // 递归锁：允许同一个线程对同一把锁进行重复加锁
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(mutexLock, &attr);
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init {
    if (self = [super init]) {
        [self __initMutex:&_moneyLock];
        [self __initMutex:&_ticketLock];
    }
    return self;
}

- (void)__drawMoney {
    pthread_mutex_lock(&_moneyLock);
    [super __drawMoney];
    pthread_mutex_unlock(&_moneyLock);
}

- (void)__saveMoney {
    pthread_mutex_lock(&_moneyLock);
    [super __saveMoney];
    pthread_mutex_unlock(&_moneyLock);
}

- (void)__saleTicket {
    pthread_mutex_lock(&_ticketLock);
    [super __saleTicket];
    pthread_mutex_unlock(&_ticketLock);
}

- (void)dealloc {
    pthread_mutex_destroy(&_moneyLock);
    pthread_mutex_destroy(&_ticketLock);
}

@end
