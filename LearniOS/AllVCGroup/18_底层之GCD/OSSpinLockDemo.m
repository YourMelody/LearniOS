//
//  OSSpinLockDemo.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/14.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>

@interface OSSpinLockDemo()
@property(nonatomic, assign)OSSpinLock moneyLock;
@property(nonatomic, assign)OSSpinLock ticketLock;
@end

@implementation OSSpinLockDemo

- (instancetype)init {
    if (self = [super init]) {
        // 初始化锁
        self.moneyLock = OS_SPINLOCK_INIT;
        self.ticketLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__drawMoney {
    OSSpinLockLock(&_moneyLock);
    [super __drawMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saveMoney {
    OSSpinLockLock(&_moneyLock);
    [super __saveMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saleTicket {
    OSSpinLockLock(&_ticketLock);
    [super __saleTicket];
    OSSpinLockUnlock(&_ticketLock);
}

@end
