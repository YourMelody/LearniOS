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
    NSLog(@"%s", __func__);
    // 判断点击的点是否在按钮上。是，返回backBtn
    CGPoint btnPoint = [self convertPoint:point toView:self.backBtn];
    
//    // 处理方式一：
//    if ([self.backBtn pointInside:btnPoint withEvent:event]) {
//        return self.backBtn;
//    }
    
    // 处理方式二：系统hitTest:内部会调用pointInside:判断point是否在当前视图上
    if ([self.backBtn hitTest:btnPoint withEvent:event]) {
        return [self.backBtn hitTest:btnPoint withEvent:event];
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
}

@end
