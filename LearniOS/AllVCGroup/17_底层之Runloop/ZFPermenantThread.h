//
//  ZFPermenantThread.h
//  LearniOS
//
//  Created by JKFunny on 2020/3/14.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFPermenantThread : NSObject

// 执行任务
- (void)executeTask:(void(^)(void))taskBlock;

// 关闭线程
- (void)stop;

@end

NS_ASSUME_NONNULL_END
