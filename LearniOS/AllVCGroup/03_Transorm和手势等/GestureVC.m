//
//  GestureVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/13.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "GestureVC.h"

@interface GestureVC () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (nonatomic, strong)UITapGestureRecognizer *tap;
@property (nonatomic, strong)UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong)UISwipeGestureRecognizer *swipe;
@property (nonatomic, strong)UIPanGestureRecognizer *pan;
@property (nonatomic, strong)UIPinchGestureRecognizer *pinch;
@property (nonatomic, strong)UIRotationGestureRecognizer *rotation;

@end

@implementation GestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageV.userInteractionEnabled = YES;
}

#pragma mark - 添加点击手势
- (IBAction)addTapGesture:(UIButton *)sender {
    if (!self.tap) {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        self.tap.delegate = self;
        [self.imageV addGestureRecognizer:self.tap];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    NSLog(@"111---tap");
}

#pragma mark - 添加长按手势
- (IBAction)addLongPressGesture:(UIButton *)sender {
    if (!self.longPress) {
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        self.longPress.delegate = self;
        [self.imageV addGestureRecognizer:self.longPress];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"222---longPress-----began");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"222---longPress-----changed");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"222---longPress-----failed");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"222---longPress-----ended");
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"222---longPress-----cancelled");
            break;
        default:
            break;
    }
}

#pragma mark - 添加轻扫手势
- (IBAction)addSwipeGesture:(UIButton *)sender {
    if (!self.swipe) {
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        leftSwipe.delegate = self;
        // 设置方向。只能设置一个方向。如果一个View想要设置不同方向的swipe，需要创建多个swipe添加到View上。
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.imageV addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        rightSwipe.delegate = self;
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self.imageV addGestureRecognizer:rightSwipe];
        
        self.swipe = leftSwipe;
    }
}

- (void)swipeAction:(UISwipeGestureRecognizer *)gesture {
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"333---swipe-----left");
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"333---swipe-----right");
            break;
        default:
            break;
    }
}

#pragma mark - 添加拖拽手势
- (IBAction)addPanGesture:(UIButton *)sender {
    if (!self.pan) {
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        self.pan.delegate = self;
        [self.imageV addGestureRecognizer:self.pan];
    }
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    // 获取移动的偏移量。注意：是相对于原始位置的偏移量
    CGPoint point = [gesture translationInView:self.view];
    NSLog(@"444---pan---x:%f---y:%f", point.x, point.y);
    self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, point.x, point.y);
    // 复原
    [gesture setTranslation:CGPointZero inView:self.imageV];
}

#pragma mark - 添加捏合手势
- (IBAction)addPinchGesture:(UIButton *)sender {
    if (!self.pinch) {
        self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        self.pinch.delegate = self;
        [self.imageV addGestureRecognizer:self.pinch];
    }
}

- (void)pinchAction:(UIPinchGestureRecognizer *)gesture {
    NSLog(@"555---pinch---%f", gesture.scale);
    self.imageV.transform = CGAffineTransformScale(self.imageV.transform, gesture.scale, gesture.scale);
    [gesture setScale:1];
}

#pragma mark - 添加旋转手势
- (IBAction)addRotationGesture:(UIButton *)sender {
    if (!self.rotation) {
        self.rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
        self.rotation.delegate = self;
        [self.imageV addGestureRecognizer:self.rotation];
    }
}

- (void)rotationAction:(UIRotationGestureRecognizer *)gesture {
    NSLog(@"666---rotation---%f", gesture.rotation);
    self.imageV.transform = CGAffineTransformRotate(self.imageV.transform, gesture.rotation);
    [gesture setRotation:0];
}

#pragma mark - UIGestureRecognizerDelegate
// 是否允许触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

// 是否允许同时支持多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// 手指触摸屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

// 手指按压屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
    return YES;
}



@end
