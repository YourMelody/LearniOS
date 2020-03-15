//
//  SemaphoreDemo.m
//  LearniOS
//
//  Created by JKFunny on 2020/3/15.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "SemaphoreDemo.h"

@interface SemaphoreDemo ()

@property (nonatomic, strong)dispatch_semaphore_t moneySemaphore;
@property (nonatomic, strong)dispatch_semaphore_t ticketSemaphore;

@end

@implementation SemaphoreDemo

- (instancetype)init {
    if (self = [super init]) {
        self.moneySemaphore = dispatch_semaphore_create(1);
        self.ticketSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)__drawMoney {
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    [super __drawMoney];
    dispatch_semaphore_signal(self.moneySemaphore);
}

- (void)__saveMoney {
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    [super __saveMoney];
    dispatch_semaphore_signal(self.moneySemaphore);
}

- (void)__saleTicket {
    dispatch_semaphore_wait(self.ticketSemaphore, DISPATCH_TIME_FOREVER);
    [super __saleTicket];
    dispatch_semaphore_signal(self.ticketSemaphore);
}

@end
