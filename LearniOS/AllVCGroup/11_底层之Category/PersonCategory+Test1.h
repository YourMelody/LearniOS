//
//  PersonCategory+Test1.h
//  LearniOS
//
//  Created by 张帆 on 2020/3/9.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "PersonCategory.h"

@interface PersonCategory (Test1)

// 分类中直接添加属性，只会生成对应属性的set/get方法声明，不会生成对应的成员变量及get/set方法的实现
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *nickName;
@property(nonatomic, copy)NSString *avatar;
@property(nonatomic, copy)NSString *school;

@end
