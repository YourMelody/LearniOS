//
//  TransformView.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/13.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "TransformView.h"

#define AnimationTimeInterval 0.5

@interface TransformView ()

@property (nonatomic, assign)int currentIndex;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation TransformView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 1;
}

/*
    CGAffineTransformMakeXXX：永远相对最原始位置处理
    CGAffineTransformXXX：相对上一次形变做处理
 */

#pragma mark - 1、translate右上移
- (IBAction)moveUpTranslate:(UIButton *)sender {
    if (self.currentIndex != 1) {
        // 复原
        self.imageV.transform = CGAffineTransformIdentity;
        self.currentIndex = 1;
    }
    [UIView animateWithDuration:AnimationTimeInterval animations:^{
        self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, 10, -10);
    }];
}

#pragma mark - 2、makeTranslation右上移
- (IBAction)moveUpMakeTranslation:(UIButton *)sender {
    if (self.currentIndex != 2) {
        self.imageV.transform = CGAffineTransformIdentity;
        self.currentIndex = 2;
    }
    [UIView animateWithDuration:AnimationTimeInterval animations:^{
        self.imageV.transform = CGAffineTransformMakeTranslation(10, -10);
    }];
}

#pragma mark - 3、translate左下移
- (IBAction)moveLeftTranslate:(UIButton *)sender {
    if (self.currentIndex != 3) {
        self.imageV.transform = CGAffineTransformIdentity;
        self.currentIndex = 3;
    }
    [UIView animateWithDuration:AnimationTimeInterval animations:^{
        self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, -10, 10);
    }];
}

#pragma mark - 4、makeTranslation左下移
- (IBAction)moveLeftMakeRranslation:(UIButton *)sender {
    if (self.currentIndex != 4) {
        self.imageV.transform = CGAffineTransformIdentity;
        self.currentIndex = 4;
    }
    [UIView animateWithDuration:AnimationTimeInterval animations:^{
        self.imageV.transform = CGAffineTransformMakeTranslation(-10, 10);
    }];
}

#pragma mark - 5、translate旋转
- (IBAction)moveDownTranslate:(UIButton *)sender {
    if (self.currentIndex != 5) {
        self.imageV.transform = CGAffineTransformIdentity;
        self.currentIndex = 5;
    }
    [UIView animateWithDuration:AnimationTimeInterval animations:^{
        self.imageV.transform = CGAffineTransformRotate(self.imageV.transform, M_PI_4);
    }];
}

#pragma mark - 6、makeTranslation旋转
- (IBAction)moveDownMakeTranslation:(UIButton *)sender {
    if (self.currentIndex != 6) {
        self.imageV.transform = CGAffineTransformIdentity;
        self.currentIndex = 6;
    }
    [UIView animateWithDuration:AnimationTimeInterval animations:^{
        self.imageV.transform = CGAffineTransformMakeRotation(M_PI_4);
    }];
}

#pragma mark - 7、translate缩放
- (IBAction)moveRightTranslate:(UIButton *)sender {
    if (self.currentIndex != 7) {
        self.imageV.transform = CGAffineTransformIdentity;
        self.currentIndex = 7;
    }
    [UIView animateWithDuration:AnimationTimeInterval animations:^{
        self.imageV.transform = CGAffineTransformScale(self.imageV.transform, 1.2, 1.2);
    }];
}

#pragma mark - 8、makeTranslation缩放
- (IBAction)moveRightMakeTranslation:(UIButton *)sender {
    if (self.currentIndex != 8) {
        self.imageV.transform = CGAffineTransformIdentity;
        self.currentIndex = 8;
    }
    [UIView animateWithDuration:AnimationTimeInterval animations:^{
        self.imageV.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

#pragma mark - 9、touch相关
// 开始触摸屏幕调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"111-----touchesBegan");
}

// 移动会持续调用
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self.view];
    curPoint = [self.imageV.layer convertPoint:curPoint fromLayer:self.view.layer];
    if ([self.imageV.layer containsPoint:curPoint]) {
        CGPoint prePoint = [touch previousLocationInView:self.imageV];
        // 求偏移量
        CGFloat offsetX = curPoint.x - prePoint.x;
        CGFloat offsetY = curPoint.y - prePoint.y;
        NSLog(@"222-----touchesMoved---x:%f---y:%f", offsetX, offsetY);
        // 移动
        self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, offsetX, offsetY);
    }
}

// 手指离开屏幕
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"333-----touchesEnded");
}

// 发生系统事件调用，如自动关机，电话打入等
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"444-----touchesCancelled");
}

@end
