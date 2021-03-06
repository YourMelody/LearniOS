//
//  ViewController.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/9.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "ViewController.h"
#import "GCDViewController.h"
#import "NSOperationTableVC.h"
#import "TransAndGestTableVC.h"
#import "QuartzTableVC.h"
#import "IndexTableVC.h"
#import "CategoryVC.h"
#import "RuntimeVC.h"
#import "RAMManagerVC.h"
#import "BlockVC.h"
#import "RunLoopVC.h"
#import "LeetCodeTableVC.h"

// 底层视频相关
#import "ObjectiveViewController.h"
#import "KVCAndKVOVC.h"
#import "CategoryViewController.h"
#import "BlockViewController.h"
#import "RuntimeViewController.h"
#import "RunloopViewController.h"
#import "GCDVC.h"
#import "ARCAndMRCViewController.h"
#import "XNYouHuaVC.h"

@interface ViewController ()

@property (nonatomic, copy)NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[
        @"1、GCD相关",
        @"2、NSOperation相关",
        @"3、transform、touch和手势相关",
        @"4、Quartz2D相关",
        @"5、UI视图相关",
        @"6、OC语言相关",
        @"7、Runtime相关",
        @"8、内存管理相关",
        @"9、Block相关",
        @"10、Runloop相关 ",
        @"11、算法题",
        @"12、底层之OC对象",
        @"13、底层之KVC、KVO",
        @"14、底层之Category",
        @"15、底层之block",
        @"16、底层之Runtime",
        @"17、底层之Runloop",
        @"18、底层之GCD",
        @"19、底层之内存管理",
        @"20、底层之性能优化"
    ];
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 1、GCD相关
        GCDViewController *vc = [[GCDViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        // 2、NSOperation相关
        NSOperationTableVC *vc = [[NSOperationTableVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        // 3、transform、touch和手势相关
        TransAndGestTableVC *vc = [[TransAndGestTableVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        // 4、Quartz2D相关
        QuartzTableVC *vc = [[QuartzTableVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4) {
        // 5、UI视图相关
        IndexTableVC *vc = [[IndexTableVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 5) {
        // 6、OC语言相关
        CategoryVC *vc = [[CategoryVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 6) {
        // 7、Runtime相关
        RuntimeVC *vc = [[RuntimeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 7) {
        // 8、内存管理相关
        RAMManagerVC *vc = [[RAMManagerVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 8) {
        // 9、Block相关
        BlockVC *vc = [[BlockVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 9) {
        // 10、Runloop相关
        RunLoopVC *vc = [[RunLoopVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 10) {
        // 11、算法题
        LeetCodeTableVC *vc = [[LeetCodeTableVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 11) {
        // 12、底层之OC对象
        ObjectiveViewController *vc = [[ObjectiveViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 12) {
        // 13、底层之KVC、KVO
        KVCAndKVOVC *vc = [[KVCAndKVOVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 13) {
        // 14、底层之Category
        CategoryViewController *vc = [[CategoryViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 14) {
        // 15、底层之block
        BlockViewController *vc = [[BlockViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 15) {
        // 16、底层之Runtime
        RuntimeViewController *vc = [[RuntimeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 16) {
        // 17、底层之Runloop
        RunloopViewController *vc = [[RunloopViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 17) {
        // 18、底层之GCD
        GCDVC *vc = [[GCDVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 18) {
        // 19、底层之内存管理
        ARCAndMRCViewController *vc = [[ARCAndMRCViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 19) {
        // 19、底层之性能优化
        XNYouHuaVC *vc = [[XNYouHuaVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
