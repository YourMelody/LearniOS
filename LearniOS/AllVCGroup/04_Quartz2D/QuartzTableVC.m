//
//  QuartzTableVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/14.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "QuartzTableVC.h"
#import "DrawViewController.h"

@interface QuartzTableVC ()
@property(nonatomic, copy)NSArray * dataSource;
@end

@implementation QuartzTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[
        @"1、直线、曲线",
        @"2、矩形、圆角矩形",
        @"3、圆形、椭圆形",
        @"4、弧形、扇形",
        @"5、自定义进度条",
        @"6、画饼状图",
        @"7、画文字",
        @"8、画图片",
        @"9、下雪(CADisplayLink简单实用)",
        @"10、上下文栈相关",
        @"11、上下文的矩阵操作",
        @"12、图片添加水印",
        @"13、图片简单裁剪",
        @"14、截屏",
        @"15、截图",
        @"16、擦除图片",
        @"17、手势解锁"
    ];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawViewController *vc = [[DrawViewController alloc] init];
    if (indexPath.row == 0) {
        vc.drawType = DrawType_Line;
    } else if (indexPath.row == 1) {
        vc.drawType = DrawType_Rect;
    } else if (indexPath.row == 2) {
        vc.drawType = DrawType_Round;
    } else if (indexPath.row == 3) {
        vc.drawType = DrawType_Arc;
    } else if (indexPath.row == 4) {
        vc.drawType = DrawType_Progress;
    } else if (indexPath.row == 5) {
        vc.drawType = DrawType_Pie;
    } else if (indexPath.row == 6) {
        vc.drawType = DrawType_Text;
    } else if (indexPath.row == 7) {
        vc.drawType = DrawType_Image;
    } else if (indexPath.row == 8) {
        vc.drawType = DrawType_Snow;
    } else if (indexPath.row == 9) {
        vc.drawType = DrawType_Table;
    } else if (indexPath.row == 10) {
        vc.drawType = DrawType_Translate;
    } else if (indexPath.row == 11) {
        vc.drawType = DrawType_ImageWithText;
    } else if (indexPath.row == 12) {
        vc.drawType = DrawType_ImageClip;
    } else if (indexPath.row == 13) {
        vc.drawType = DrawType_CutScreen;
    } else if (indexPath.row == 14) {
        vc.drawType = DrawType_CutImage;
    } else if (indexPath.row == 15) {
        vc.drawType = DrawType_ClearImage;
    } else if (indexPath.row == 16) {
        vc.drawType = DrawType_Clock;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
