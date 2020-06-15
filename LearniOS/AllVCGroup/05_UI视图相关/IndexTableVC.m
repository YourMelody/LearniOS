//
//  IndexTableVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/19.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "IndexTableVC.h"
#import "IndexedTableView.h"

@interface IndexTableVC () <UITableViewDelegate, UITableViewDataSource, IndexedTableViewDataSource>

@property (weak, nonatomic) IBOutlet IndexedTableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)BOOL change;

@end

@implementation IndexTableVC

/*
 1、UITableView复用机制
 2、数据源同步问题
    2.1 并发访问，数据拷贝：消耗内存
    2.2 串行访问：有一定延时
 3、UIView和CALayer
    3.1 UIView为其提供内容，以及负责处理触摸等事件，参与响应链
    3.2 CALayer负责显示内容contents
 4、事件传递和视图响应链
    4.1 hitTest:withEvent:寻找合适的响应视图
    4.2 pointInside:withEvent:判断触摸点是否在某个视图中（hitTest:内部会自动调用该方法）
 5、图像显示原理
    5.1 CPU工作：
        Layout（UI布局、文本计算等） -> Display（绘制，drawRect:方法执行） -> Prepare（图片编解码） -> Commit（将位图提交给GPU）
    5.2 GPU渲染管线：
        顶点着色 -> 图元装配 -> 光栅化 -> 片段着色 -> 片段处理
    5.3 将CPU和GPU处理的结果放到帧缓冲区中 FrameBuffer
 6、UI卡顿、掉帧的原因
    6.1 原因：
        屏幕刷新频率60Hz，即每16.7ms刷新一次。CPU+GPU等处理时间 > 16.7ms，将会产生卡顿掉帧。
        （在规定的16.7ms之内，在下一帧VSync信号到来之前，CPU、GPU并没有完成下一帧画面的合成，
        于是会导致卡顿和掉帧。）
    6.2 滑动优化方案：
        CPU：
            对象的创建、调整、销毁放入子线程完成
            预排版（布局计算、文本计算）也放入子线程
            预渲染（文本等异步绘制、图片编解码等）
        GPU：
            纹理渲染：如设置圆角+masksToBounds、设置阴影等，会触发离屏渲染，导致纹理渲染工作量大
            视图混合：视图层级多，计算量大
 7、UIView的绘制原理
    7.1 [view setNeedsDisplay]并没有立即执行视图的绘制工作，原因：
        [view setNeedsDisplay]
        -> 立即执行[view.layer setNeedsDisplay]
        -> 当前RunLoop即将结束的时候调用[CALayer display]
        -> [layer.delegate respondsTo:@selector(displayLayer:)]
        -> NO执行系统绘制流程；YES异步绘制入口displayLayer:
    7.2 系统绘制流程
        CALayer创建backing store（即CGContextRef）
        -> 判断layer是否有代理
            -> NO [layer drawInContext:]
            -> YES [layer.delegate drawLayer:inContext:] -> [view drawRect:]
        -> 上传backing store（即位图）到GPU
    7.3 异步绘制：
        [layer.delegate displayLayer:]
            代理负责生成对应的bitmap（位图）
            设置bitmap作为layer.contents属性的指
 
        mainQueue：[AsyncDrawingView setNeedsDisplay]
                    -> [CALayer display]
                    -> [layer.delegate displayLayer:]
        GlobalQueue： -> CGBitmapContetxtCreate()
                     -> CoreGraphicApi
                     -> CGBitmapContextCreateImage()
        mainQueue：[CALayer setContents:]
 
 8、在屏渲染 On-Screen Rendering：
        指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行
    离屏渲染 Off-Screen Rendering
        指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作
    离屏渲 染触发场景：
        设置圆角+masksToBounds设置为YES一起使用
        设置阴影
        图层蒙版
        光栅化
    为何要避免离屏渲染：
         离屏渲染会增加GPU的工作量，有可能导致CPU+GPU总耗时>16.7ms，可能导致UI卡顿和掉帧
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.indexedDataSource = self;
    
    // 模拟数据源
    self.dataSource = [NSMutableArray array];
    for (int i  = 0; i < 100; i++) {
        [self.dataSource addObject:@(i + 1)];
    }
}

// 重置
- (IBAction)resetAction:(UIButton *)sender {
    self.change = !self.change;
    [self.tableView reloadData];
    NSLog(@"click-----");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%d", [self.dataSource[indexPath.row] intValue]];
    return cell;
}

// 索引数据
- (NSArray<NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableView {
    // 奇数次调用返回6个字母，偶数次调用返回11个
    if (self.change) {
        return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
    } else {
        return @[@"A", @"B", @"C", @"D", @"E", @"F"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
