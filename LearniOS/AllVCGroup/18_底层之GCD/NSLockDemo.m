//
//  NSLockDemo.m
//  LearniOS
//
//  Created by JKFunny on 2020/3/15.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "NSLockDemo.h"

@interface NSLockDemo ()

@property (nonatomic, strong)NSLock *moneyLock;
@property (nonatomic, strong)NSLock *ticketLock;

@end

@implementation NSLockDemo

- (instancetype)init {
    if (self = [super init]) {
        self.moneyLock = [[NSLock alloc] init];
        self.ticketLock = [[NSLock alloc] init];
    }
    return self;
}

- (void)__drawMoney {
    [self.moneyLock lock];
    [super __drawMoney];
    [self.moneyLock unlock];
}

- (void)__saveMoney {
    [self.moneyLock lock];
    [super __saveMoney];
    [self.moneyLock unlock];
}

- (void)__saleTicket {
    [self.ticketLock lock];
    [super __saleTicket];
    [self.ticketLock unlock];
}

@end
