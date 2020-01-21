//
//  ViewReusePool.h
//  LearniOS
//
//  Created by JKFunny on 2020/1/19.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 实现重用机制的类
@interface ViewReusePool : UIView

// 从重用池中取一个可重用的view
- (UIView *)dequeueReusableView;

// 向重用池中添加一个视图
- (void)addUsingView:(UIView *)view;

// 重置方法，将当前使用中的视图移动到可重用队列中
- (void)reset;

@end

NS_ASSUME_NONNULL_END
