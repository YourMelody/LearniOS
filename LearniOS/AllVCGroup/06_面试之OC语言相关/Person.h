//
//  Person.h
//  LearniOS
//
//  Created by JKFunny on 2020/1/19.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)CGFloat weight;
- (void)increaseWeight;
- (void)kvoIncreaseWeight;

@end

NS_ASSUME_NONNULL_END
