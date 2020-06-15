//
//  CustomButton.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/19.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    
    if ([self pointInside:point withEvent:event]) {
        // 遍历当前对象的子视图
        __block UIView *hit = nil;
        // 倒序遍历
        [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 坐标转换
            CGPoint convertPoint = [self convertPoint:point toView:obj];
            // 调用子视图的hitTest:withEvent:
            hit = [obj hitTest:convertPoint withEvent:event];
            if (hit) {
                *stop = YES;
            }
        }];
        
        if (hit) {
            return hit;
        } else {
            return self;
        }
    } else {
        return nil;
    }
}

// 修改button的响应区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (point.x < 30 || point.x > [UIScreen mainScreen].bounds.size.width - 30) {
        return NO;
    }
    return YES;
}

@end
