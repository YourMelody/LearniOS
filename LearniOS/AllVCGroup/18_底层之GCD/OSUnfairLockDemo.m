//
//  OSUnfairLockDemo.m
//  LearniOS
//
//  Created by JKFunny on 2020/3/15.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "OSUnfairLockDemo.h"
#import <os/lock.h>

@interface OSUnfairLockDemo ()

@property (nonatomic, assign)os_unfair_lock moneyLock;
@property (nonatomic, assign)os_unfair_lock ticketLock;

@end

@implementation OSUnfairLockDemo

- (instancetype)init {
    if (self = [super init]) {
        // 初始化锁
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
        self.ticketLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)__drawMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __drawMoney];
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__saveMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __saveMoney];
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__saleTicket {
    os_unfair_lock_lock(&_ticketLock);
    [super __saleTicket];
    os_unfair_lock_unlock(&_ticketLock);
}

@end
