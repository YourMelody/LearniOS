//
//  DrawViewController.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/14.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "DrawViewController.h"
#import "ClockView.h"

@interface DrawViewController ()

@property (weak, nonatomic) IBOutlet DrawView *drawV;
@property (weak, nonatomic) IBOutlet UILabel *progressLab;
@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (nonatomic, strong)UIView *coverView;
@property (nonatomic, assign)CGPoint startPoint;


@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.drawV.drawType = self.drawType;
    self.progressLab.hidden = self.drawType != DrawType_Progress;
    self.mySlider.hidden = self.drawType != DrawType_Progress;
    
    if (self.drawType == DrawType_ImageWithText) {
        // 12、图片添加水印效果
        [self imageWithTextFunction];
    } else if (self.drawType == DrawType_ImageClip) {
        // 13、图片的简单裁剪
        [self imageClipFunction];
    } else if (self.drawType == DrawType_CutScreen) {
        // 14、截屏(点击屏幕显示效果)
        [self imageClipFunction];
    } else if (self.drawType == DrawType_CutImage) {
        // 15、截图
        self.imageWidth.constant = self.view.frame.size.width;
        self.imageHeight.constant = self.view.frame.size.height;
        [self cutImageFunction];
    } else if (self.drawType == DrawType_ClearImage) {
        // 16、擦除图片
        self.imageWidth.constant = self.view.frame.size.width;
        self.imageHeight.constant = self.view.frame.size.height;
        [self clearImageFunction];
    } else if (self.drawType == DrawType_Clock) {
        UIColor *bgColor = [UIColor colorWithRed:48 / 255.f green:19 / 255.f blue:92 / 255.f alpha:1];
        self.view.backgroundColor = bgColor;
        self.drawV.backgroundColor = bgColor;
        ClockView *view = [[ClockView alloc] initWithFrame:CGRectMake(30, 80, [UIScreen mainScreen].bounds.size.width - 60, [UIScreen mainScreen].bounds.size.width - 60)];
        view.backgroundColor = bgColor;
        [self.drawV addSubview:view];
    }
}

#pragma mark - 12、图片添加水印效果
- (void)imageWithTextFunction {
    self.imageV.hidden = NO;
    // 注意：这里字体和[str drawAtPoint:]特别大的原因，图片本身特别大，这里是imageV尺寸的5倍，所以设置的字体和起始位置，展示到imageV上后会缩小5倍。
    // 1、获取图片
    UIImage *image = [UIImage imageNamed:@"bleach"];
    // 2、开启图片上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    // 3、设置椭圆裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height) cornerRadius:50];
    [path addClip];
    // 4、将图片/文字添加到上下文
    [image drawAtPoint:CGPointZero];
    
    NSString *str = @"死神  BLEACH";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[UIFont systemFontOfSize:85] forKey:NSFontAttributeName];
    [dic setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(2, 2);
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowBlurRadius = 2;
    [dic setValue:shadow forKey:NSShadowAttributeName];
    [str drawAtPoint:CGPointMake(1300, 1000) withAttributes:dic];
    // 5、从上下文中获取图片
    UIImage *showImage = UIGraphicsGetImageFromCurrentImageContext();
    // 6、关闭上下文
    UIGraphicsEndImageContext();
    // 7、显示图片
    self.imageV.image = showImage;
}

#pragma mark - 13、图片的简单裁剪
- (void)imageClipFunction {
    self.imageV.hidden = NO;
    UIImage *sourceImage = [UIImage imageNamed:@"bleach"];
    CGFloat scale = sourceImage.size.width / self.imageV.frame.size.width;
    CGFloat borderW = 10 * scale;
    CGSize size = CGSizeMake(sourceImage.size.width + 2 * borderW, sourceImage.size.height + 2 * borderW);
    // 1、开启图片上下文
    UIGraphicsBeginImageContext(size);
    // 2、绘制大圆，显示为边框
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    [[UIColor blueColor] set];
    [path fill];
    // 3、绘制小圆，显示图片
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW, borderW, sourceImage.size.width, sourceImage.size.height)];
    [clipPath addClip];
    [sourceImage drawAtPoint:CGPointMake(borderW, borderW)];
    // 4、获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5、关闭上下文
    UIGraphicsEndImageContext();
    self.imageV.image = newImage;
}

#pragma mark - 14、截屏
- (void)cutScreenFunction {
    self.imageV.hidden = NO;
    // 1、开启图片上下文
    UIGraphicsBeginImageContext(self.view.frame.size);
    // 2、获取当前上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // 3、绘制
    [self.view.layer renderInContext:contextRef];
    // 4、从上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5、关闭上下文
    UIGraphicsEndImageContext();
    // 6、展示截图
    self.imageV.image = newImage;
    // 7、也可以把图片转NSData，写到指定位置
    NSData *imageData = UIImagePNGRepresentation(newImage);
    [imageData writeToFile:@"/Users/jkfunny/Desktop/newImage.png" atomically:YES];
}

#pragma mark - 15、截图
- (void)cutImageFunction {
    self.imageV.hidden = NO;
    self.imageV.image = [UIImage imageNamed:@"test"];
    // 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.imageV addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint curPoint = [pan locationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startPoint = curPoint;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat x = self.startPoint.x;
        CGFloat y = self.startPoint.y;
        CGFloat width = curPoint.x - x;
        CGFloat height = curPoint.y - y;
        self.coverView.frame = CGRectMake(x, y, width, height);
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        UIGraphicsBeginImageContextWithOptions(self.imageV.frame.size, NO, 0);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.coverView.frame];
        [path addClip];
        [self.imageV.layer renderInContext:contextRef];
        self.imageV.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }
}

#pragma mark - 16、图片擦除
- (void)clearImageFunction {
    self.imageV.hidden = NO;
    self.imageV.image = [UIImage imageNamed:@"test"];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clearAction:)];
    [self.imageV addGestureRecognizer:pan];
}

- (void)clearAction:(UIPanGestureRecognizer *)pan {
    CGPoint curPoint = [pan locationInView:self.imageV];
    CGRect rect = CGRectMake(curPoint.x - 10, curPoint.y - 10, 20, 20);
    UIGraphicsBeginImageContextWithOptions(self.imageV.frame.size, NO, 0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self.imageV.layer renderInContext:contextRef];
    // 擦除指定区域
    CGContextClearRect(contextRef, rect);
    self.imageV.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


#pragma mark - other
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.drawType == DrawType_CutScreen) {
        [self cutScreenFunction];
    }
}

- (IBAction)changeProgress:(UISlider *)sender {
    self.progressLab.text = [NSString stringWithFormat:@"%.2f%%", sender.value * 100];
    self.drawV.myProgress = sender.value;
}

#pragma mark - lazy
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.6;
        [self.view addSubview:_coverView];
    }
    return _coverView;
}

@end
