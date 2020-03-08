//
//  TransAndGestTableVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/13.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "TransAndGestTableVC.h"
#import "TransformView.h"
#import "GestureVC.h"
#import "HitTestVC.h"

@interface TransAndGestTableVC ()

@property (nonatomic, copy)NSArray *dataSource;

@end

@implementation TransAndGestTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.dataSource = @[
        @"1、transform和touch相关",
        @"2、各种手势相关",
        @"3、hitTest简单使用"
    ];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TransformView *vc = [[TransformView alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        GestureVC *vc = [[GestureVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        HitTestVC *vc = [[HitTestVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
