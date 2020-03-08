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

// 底层视频相关
#import "ObjectiveViewController.h"
#import "KVCAndKVOVC.h"

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
        @"4、底层之OC对象",
        @"5、底层之KVC、KVO"
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
        GCDViewController *vc = [[GCDViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        NSOperationTableVC *vc = [[NSOperationTableVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        TransAndGestTableVC *vc = [[TransAndGestTableVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        ObjectiveViewController *vc = [[ObjectiveViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4) {
        KVCAndKVOVC *vc = [[KVCAndKVOVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
