//
//  Person.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/19.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "Person.h"

/*
 类扩展Extension
 1、作用
    1.1 声明私有属性
    1.2 声明私有方法
    1.3 声明私有成员变量
 2、分类和扩展的区别
    2.1 Category运行时决议，Extension编译时决议
    2.2 Extension只以声明的形式存在，多数情况下寄生于宿主类的.m中
    2.3 不能为系统类添加扩展，可以为系统类添加分类
 */
@interface Person ()

@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *address;

@end

@implementation Person

- (void)increaseWeight {
    _weight++;
}

- (void)kvoIncreaseWeight {
    [self willChangeValueForKey:@"weight"];
    _weight++;
    [self didChangeValueForKey:@"weight"];
}

@end
