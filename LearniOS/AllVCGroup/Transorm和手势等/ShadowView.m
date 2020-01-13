//
//  ShadowView.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/13.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "ShadowView.h"

@interface ShadowView ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@end

@implementation ShadowView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 判断点击的点是否在按钮上。是，返回backBtn
    CGPoint btnPoint = [self convertPoint:point toView:self.backBtn];
    
    // 处理方式一：
    if ([self.backBtn hitTest:btnPoint withEvent:event]) {
        return [self.backBtn hitTest:btnPoint withEvent:event];
    } else {
        return [super hitTest:point withEvent:event];
    }
    
    // 处理方式二：
//    if ([self.backBtn pointInside:btnPoint withEvent:event]) {
//        return self.backBtn;
//    } else {
//        return [super hitTest:point withEvent:event];
//    }
}

@end
