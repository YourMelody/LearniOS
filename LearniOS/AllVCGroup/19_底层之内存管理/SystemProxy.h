//
//  SystemProxy.h
//  LearniOS
//
//  Created by JKFunny on 2020/3/15.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemProxy : NSProxy

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
