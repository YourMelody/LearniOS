//
//  DrawView.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/14.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "DrawView.h"

@interface DrawView ()

@property (nonatomic, strong)CADisplayLink *link;
@property (nonatomic, assign)CGFloat snowY0;
@property (nonatomic, assign)CGFloat snowY1;
@property (nonatomic, assign)CGFloat snowY2;

@end

@implementation DrawView

/// 系统自动调用，在viewWillAppear之后，viewDidAppear之前
/// @param rect 当前视图的bounds
- (void)drawRect:(CGRect)rect {
    // 在drawRect:中，系统会默认创建一个跟view相关联的上下文(layer上下文)，所以不用自己创建，直接获取。
    switch (self.drawType) {
        case DrawType_Line:     // 1、画各种直线、折线、曲线
            [self drawLineFunction];
            break;
        case DrawType_Rect:     // 2、画矩形、圆角矩形
            [self drawRectFunction];
            break;
        case DrawType_Round:    // 3、画圆、椭圆
            [self drawRoundFunction];
            break;
        case DrawType_Arc:      // 4、画弧形、扇形
            [self drawArcFunction];
            break;
        case DrawType_Progress: // 5、自定义进度条
            [self drawProgressFunction];
            break;
        case DrawType_Pie:      // 6、画饼状图
            [self drawPieFunction];
            break;
        case DrawType_Text:     // 7、画文字
            [self drawTextFunction];
            break;
        case DrawType_Image:    // 8、画图片
            [self drawImageFuncttion];
            break;
        case DrawType_Snow:     // 9、下雪
            [self snowFunction];
            break;
        case DrawType_Table:    // 10、上下文栈相关
            [self contextRefTableFunction];
            break;
        case DrawType_Translate:// 11、上下文的矩阵操作
            [self contextRefTranslateFunction];
            break;
        default:
            break;
    }
}

#pragma mark - 1、画各种直线、折线、曲线
- (void)drawLineFunction {
    // 1、获取上下文（获取/创建上下文，都以UIGraphics开头）
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // 2、绘制路径
    UIBezierPath *path = [UIBezierPath bezierPath]; // 相当于画笔
    [path moveToPoint:CGPointMake(100, 100)];   // 起点
    [path addLineToPoint:CGPointMake(300, 300)];// 设置终点并连线
    
    // 另一条线。同一个path可以重复画多条线
    [path moveToPoint:CGPointMake(300, 100)];
    [path addLineToPoint:CGPointMake(100, 300)];
    [path addLineToPoint:CGPointMake(100, 100)];
    [path addLineToPoint:CGPointMake(300, 100)];
    [path addLineToPoint:CGPointMake(300, 300)];
    
    // 画曲线
    [path addQuadCurveToPoint:CGPointMake(100, 300) controlPoint:CGPointMake(200, 420)];
    
    
    // 3、设置线宽、样式、颜色
    CGContextSetLineWidth(contextRef, 5);
    /* 连接方式
     kCGLineJoinMiter,
     kCGLineJoinRound,
     kCGLineJoinBevel
     */
    CGContextSetLineJoin(contextRef, kCGLineJoinRound);
    /* 线顶角的样式
     kCGLineCapButt,
     kCGLineCapRound,
     kCGLineCapSquare
     */
    CGContextSetLineCap(contextRef, kCGLineCapRound);
    // 设置颜色
    [[UIColor darkGrayColor] set];
    
    
    // 4、把绘制的内容添加到上下文
    CGContextAddPath(contextRef, path.CGPath);
    // 5、把上下文的内容显示到view上（渲染到layer上，有stroke和fill两种方式）
    CGContextStrokePath(contextRef);
}

#pragma mark - 2、画矩形、圆角矩形
- (void)drawRectFunction {
    [self strokeTypeRect:CGRectMake(100, 50, 150, 100)];
    
    [self fillTypeRoundRect:CGRectMake(100, 200, 150, 100)];
}

// 1、stroke方式的矩形
- (void)strokeTypeRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    CGContextSetLineWidth(contextRef, 5);
    [[UIColor darkGrayColor] set];
    
    CGContextAddPath(contextRef, path.CGPath);
    CGContextStrokePath(contextRef);
}

// 2、fill方式的圆角矩形
- (void)fillTypeRoundRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:20];
    
    CGContextSetLineWidth(contextRef, 5);
    [[UIColor darkGrayColor] set];
    
    CGContextAddPath(contextRef, path.CGPath);
    CGContextFillPath(contextRef);
}

#pragma mark - 3、画圆、椭圆
- (void)drawRoundFunction {
    [self strokeTypeOval:CGRectMake(100, 50, 150, 100)];
    
    [self fillTypeOval:CGRectMake(100, 200, 150, 100)];
}

// 1、stroke方式的圆形
- (void)strokeTypeOval:(CGRect)rect {
    // 在drawRect：方法中，可以直接拿到上下文，所以能有这种简单方式画图。在其他方法中不能这么用。
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    CGContextSetLineWidth(contextRef, 5);
    [[UIColor darkGrayColor] set];
    
    [path stroke];
}

// 2、fill方式的椭圆
- (void)fillTypeOval:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    CGContextSetLineWidth(contextRef, 5);
    [[UIColor darkGrayColor] set];
    
    [path fill];
}


#pragma mark - 4、画弧形、扇形
- (void)drawArcFunction {
    [self arcWithCenter:CGPointMake(200, 80) type:0];
    [self arcWithCenter:CGPointMake(200, 160) type:1];
    [self arcWithCenter:CGPointMake(200, 240) type:2];
    [self arcWithCenter:CGPointMake(200, 320) type:3];
    [self arcWithCenter:CGPointMake(200, 400) type:4];
    [self arcWithCenter:CGPointMake(200, 480) type:5];
}

- (void)arcWithCenter:(CGPoint)center type:(NSInteger)type {
    // 圆心   半径  开始角度  结束角度   是否顺时针
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:60 startAngle:0 endAngle:M_PI_4 clockwise:YES];
    if (type == 0) {
        [path stroke];
    } else if (type == 1) {
        [path fill];
    } else if (type == 2) {
        [path closePath];
        [path stroke];
    } else if (type == 3) {
        [path addLineToPoint:center];
        [path stroke];
    } else if (type == 4) {
        [path addLineToPoint:center];
        // 关闭路径：从路径终点链接一根线到路径的起点
        [path closePath];
        [path stroke];
    } else if (type == 5) {
        [path addLineToPoint:center];
        // fill会自动关闭路径
        [path fill];
    }
}

#pragma mark - 5、自定义进度条
- (void)drawProgressFunction {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5) radius:100 startAngle:-M_PI_2 endAngle:2 * M_PI * self.myProgress - M_PI_2 clockwise:YES];
    [path stroke];
}

- (void)setMyProgress:(CGFloat)myProgress {
    _myProgress = myProgress;
    
    // 手动调用drawRect:不会创建跟view关联的上下文，只有系统自动调用才会生成上下文
    // 因此这种方法不会生效
    // [self drawRect:self.bounds];
    
    // 重绘，系统会自动调用drawRect:
    [self setNeedsDisplay];
}

#pragma mark - 6、画饼状图
- (void)drawPieFunction {
    NSArray *dataArr = @[@10, @20, @30, @40];
    CGFloat start = 0;
    CGFloat end = 0;
    CGFloat change = 0;
    CGPoint centerP = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    for (NSNumber *num in dataArr) {
        start = end;
        change = 2 * M_PI * num.intValue / 100.0;
        end = start + change;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerP radius:150 startAngle:start endAngle:end clockwise:YES];
        [path addLineToPoint:centerP];
        [path fill];
        [[self randomColor] set];
    }
}

- (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(256) / 255.f green:arc4random_uniform(256) / 255.f blue:arc4random_uniform(256) / 255.f alpha:1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.drawType == DrawType_Pie) {
        [self setNeedsDisplay];
    } else if (self.drawType == DrawType_Snow) {
        [self.link invalidate];
        self.link = nil;
    }
}

#pragma mark - 7、画文字
- (void)drawTextFunction {
    NSString *str = @"测试一下测试一下测试一下测试一下测试一下测试一下测试一下测试一下";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [dic setValue:[UIColor darkTextColor] forKey:NSForegroundColorAttributeName];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor redColor];
    shadow.shadowOffset = CGSizeMake(3, 3);
    shadow.shadowBlurRadius = 3;
    [dic setValue:shadow forKey:NSShadowAttributeName];
    
    // 会自动换行
    [str drawInRect:CGRectMake(20, 30, 370, 100) withAttributes:dic];
    
    // 不会自动换行
    [str drawAtPoint:CGPointMake(20, 150) withAttributes:dic];
}

#pragma mark - 8、画图片
- (void)drawImageFuncttion {
    UIImage *image = [UIImage imageNamed:@"icon_logo.png"];
    
    // 以图片的原始大小绘制
    [image drawAtPoint:CGPointMake(20, 20)];
    
    // 图片在指定区域铺满，会改变宽高比
    [image drawInRect:CGRectMake(260, 20, 120, 80)];
    
    // 平铺，类似于repeat方式
    [image drawAsPatternInRect:CGRectMake(50, 240, 300, 300)];
}

#pragma mark - 9、下雪
- (void)snowFunction {
    UIImage *image = [UIImage imageNamed:@"snow"];
    [image drawAtPoint:CGPointMake(20, self.snowY0)];
    [image drawAtPoint:CGPointMake(170, self.snowY1)];
    [image drawAtPoint:CGPointMake(300, self.snowY2)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.drawType == DrawType_Snow) {
            // 屏幕刷新会调用snowDown。（屏幕每秒刷新60次）
            self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(snowDown)];
            // 将link添加到主运行循环中
            [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            self.backgroundColor = [UIColor colorWithRed:7 / 255 green:32 / 255 blue:60 / 255 alpha:1];
        }
    });
}

- (void)snowDown {
    self.snowY0 += 8;
    self.snowY1 += 5;
    self.snowY2 += 10;
    CGFloat deviceH = [UIScreen mainScreen].bounds.size.height;
    if (self.snowY0 > deviceH) {
        self.snowY0 = 0;
    }
    if (self.snowY1 > deviceH) {
        self.snowY1 = 0;
    }
    if (self.snowY2 > deviceH) {
        self.snowY2 = 0;
    }
    
    // 重绘
    [self setNeedsDisplay];
}

#pragma mark - 10、上下文栈相关
- (void)contextRefTableFunction {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // 1、保存当前上下文状态（默认状态：黑色，宽度为1）
    CGContextSaveGState(contextRef);
    
    // 第一条线：黑色，宽度为1
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(100, 100)];
    [path addLineToPoint:CGPointMake(300, 100)];
    [path stroke];
    
    CGContextSetLineWidth(contextRef, 5);
}

#pragma mark - 11、上下文的矩阵操作
- (void)contextRefTranslateFunction {
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
