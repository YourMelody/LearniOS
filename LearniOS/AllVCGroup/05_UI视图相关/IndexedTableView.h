//
//  IndexedTableView.h
//  LearniOS
//
//  Created by JKFunny on 2020/1/19.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IndexedTableViewDataSource <NSObject>

// 获取一个tableView的字母索引条数据的方法
- (NSArray <NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableView;

@end

@interface IndexedTableView : UITableView

@property (nonatomic, weak)id <IndexedTableViewDataSource> indexedDataSource;

@end
