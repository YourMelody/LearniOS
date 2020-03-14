//
//  GCDBaseLock.h
//  LearniOS
//
//  Created by 张帆 on 2020/3/14.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDBaseLock : NSObject

- (void)moneyTest;
- (void)ticketTest;
- (void)otherTest;

#pragma mark - 暴露给子类去使用
// 存钱
- (void)__saveMoney;
// 取钱
- (void)__drawMoney;
// 卖票
- (void)__saleTicket;

@end
