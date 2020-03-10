//
//  LeetCodeTableVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/21.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "LeetCodeTableVC.h"

@interface LeetCodeTableVC ()

@property (nonatomic, copy)NSArray *dataSource;

@end

@implementation LeetCodeTableVC

/*
 补充设计模式：
 1、六大设计原则
    单一职责原则：一个类只负责一件事
    依赖倒置原则：抽象不应该依赖于 具体实现，具体实现可以依赖于抽象
    开闭原则：对修改关闭，对扩展开放
    里氏替换原则：父类可以被子类无缝替换，且原有功能不受任何影响
    接口隔离原则：使用多个专门的协议，而不是一个庞大臃肿的协议；协议中的方法也应该尽量少。
    迪米特法则：一个对象应当对其他对象有尽可能少的了解（高内聚，低耦合）
 
 2、常用设计模式：
    责任链模式
    桥接模式
    适配器模式
    单例模式
    命令模式
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[
        @"1、两数之和找下标"
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 1、两数之和找下标
        [self firstFunction];
    } else if (indexPath.row == 1) {
        // 2、字符串反转
        char ch[] = "hello, world";
        char_reverse(ch);
        printf("%s", ch);
    }
}

#pragma mark - 1、两数之和找下标
- (void)firstFunction {
    /*
     题目：给定一个整数数组nums和一个目标值target，在该数组中找出和为目标值的两个整数，返回它们的下标。
          假设每种输入只会对应一个答案。但是，不能重复利用这个数组中同样的元素。
     例如：nums = @[2, 7, 11, 15]; target = 9; 需要返回@[0, 1]
     */
    NSArray *numsArr = @[@1, @2, @3, @4, @5, @6];
    int target = 10;
    NSArray *resultArr1 = [self firstQueMethod1:numsArr target:target];
    NSArray *resultArr2 = [self firstQueMethod2:numsArr target:target];
    NSLog(@"方法1结果：%@, 方法2结果：%@", resultArr1, resultArr2);
}

// 第一种解法
- (NSArray *)firstQueMethod1:(NSArray *)nums target:(int)target {
    NSUInteger count = nums.count;
    for (int i = 0; i < count; i++) {
        for (int j = i + 1; j < count; j++) {
            if (target == [nums[i] intValue] + [nums[j] intValue]) {
                return @[@(i), @(j)];
            }
        }
    }
    return @[];
}

// 第二种解法
- (NSArray *)firstQueMethod2:(NSArray *)nums target:(int)target {
    return @[];
}

#pragma mark - 2、字符串反转
void char_reverse(char *cha) {
    // 指向第一个字符
    char *begin = cha;
    char *end = cha + strlen(cha) - 1;
    while (begin < end) {
        // 交换前后两个字符，同时移动指针
        char temp = *begin;
        *(begin++) = *end;
        *(end--) = temp;
    }
}

#pragma mark - 3、有序数组合并

@end
