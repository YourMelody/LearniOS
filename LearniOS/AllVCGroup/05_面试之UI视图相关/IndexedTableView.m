//
//  IndexedTableView.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/19.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "IndexedTableView.h"
#import "ViewReusePool.h"

@interface IndexedTableView ()

@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)ViewReusePool *reusePool;

@end

@implementation IndexedTableView

- (void)reloadData {
    [super reloadData];
    if (self.containerView == nil) {
        self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.containerView.backgroundColor = [UIColor whiteColor];
        // 避免索引条随着table滚动
        [self.superview insertSubview:self.containerView aboveSubview:self];
    }
    
    if (self.reusePool == nil) {
        self.reusePool = [[ViewReusePool alloc] init];
    }
    
    // 标记所有视图为可重用状态
    [self.reusePool reset];
    // reload字母索引条
    [self reloadIndexedBar];
}

- (void)reloadIndexedBar {
    // 获取字母索引条的显示内容
    NSArray <NSString *> *arrayTitles = nil;
    if ([self.indexedDataSource respondsToSelector:@selector(indexTitlesForIndexTableView:)]) {
        arrayTitles = [self.indexedDataSource indexTitlesForIndexTableView:self];
    }
    
    // 判断字母索引条是否为空
    if (!arrayTitles || arrayTitles.count <= 0) {
        [self.containerView setHidden:YES];
        return;
    }
    
    NSUInteger count = arrayTitles.count;
    CGFloat btnWidth = 60;
    CGFloat btnHeight = self.frame.size.height / count;
    
    for (int i = 0; i < count; i++) {
        NSString *title = arrayTitles[i];
        // 从重用池中取一个button
        UIButton *button = (UIButton *)[self.reusePool dequeueReusableView];
        // 如果没有可重用的button，则创建一个
        if (button == nil) {
            button = [[UIButton alloc] initWithFrame:CGRectZero];
            button.backgroundColor = [UIColor whiteColor];
            [self.reusePool addUsingView:button];
            NSLog(@"新创建一个button");
        } else {
            NSLog(@"button 重用了");
        }
        
        // 添加button到父视图
        [self.containerView addSubview:button];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 设置button的坐标
        [button setFrame:CGRectMake(0, i * btnHeight, btnWidth, btnHeight)];
    }
    [self.containerView setHidden:NO];
    self.containerView.frame = CGRectMake(self.frame.origin.x + self.frame.size.width - btnWidth, self.frame.origin.y, btnWidth, self.frame.size.height);
}

@end
