//
//  ChildButton.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/14.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "ChildButton.h"

@implementation ChildButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    if (self.popBtn) {
        CGPoint btnPoint = [self convertPoint:point toView:self.popBtn];
//        // 处理方式一：
//        if ([self.popBtn pointInside:btnPoint withEvent:event]) {
//            return self.popBtn;
//        }
        
        // 处理方式二：
        if ([self.popBtn hitTest:btnPoint withEvent:event]) {
            return [self.popBtn hitTest:btnPoint withEvent:event];
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPoint prePointt = [touch previousLocationInView:self];
    CGFloat offsetX = point.x - prePointt.x;
    CGFloat offsetY = point.y - prePointt.y;
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    NSLog(@"offsetX = %f, offsetY = %f", offsetX, offsetY);
}

@end
