//
//  ClockView.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/16.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "ClockView.h"

@interface ClockView ()

@property (nonatomic, strong)NSMutableArray *selectBtnArr;
@property (nonatomic, assign)CGPoint curPoint;

@end

@implementation ClockView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加btn
        CGFloat margin = (self.frame.size.width - 3 * 64) / 4;
        for (int i = 0; i < 9; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.userInteractionEnabled = NO;
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:@"round"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"selected_round"] forState:UIControlStateSelected];
            CGRect rect = CGRectMake(margin + i % 3 * (64 + margin), margin + i / 3 * (64 + margin), 64, 64);
            btn.frame = rect;
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.selectBtnArr.count) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (int i = 0; i < self.selectBtnArr.count; i++) {
            UIButton *btn = self.selectBtnArr[i];
            if (i == 0) {
                [path moveToPoint:btn.center];
            } else {
                [path addLineToPoint:btn.center];
            }
        }
        [path addLineToPoint:self.curPoint];
        [path setLineWidth:10];
        [path setLineJoinStyle:kCGLineJoinRound];
        [[UIColor redColor] set];
        [path stroke];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.curPoint = [self getCurrentPoint:touches];
    UIButton *btn = [self btnRectContainsPoint:self.curPoint];
    if (btn && !btn.selected) {
        btn.selected = YES;
        [self.selectBtnArr addObject:btn];
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.curPoint = [self getCurrentPoint:touches];
    UIButton *btn = [self btnRectContainsPoint:self.curPoint];
    if (btn && !btn.selected) {
        btn.selected = YES;
        [self.selectBtnArr addObject:btn];
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UIButton *btn in self.selectBtnArr) {
        btn.selected = NO;
    }
    [self.selectBtnArr removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark - 判断点是否在按钮上
- (UIButton *)btnRectContainsPoint:(CGPoint)point {
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

#pragma mark - 获取当前手指所在的点
- (CGPoint)getCurrentPoint:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

- (NSMutableArray *)selectBtnArr {
    if (!_selectBtnArr) {
        _selectBtnArr = [NSMutableArray array];
    }
    return _selectBtnArr;
}

@end
