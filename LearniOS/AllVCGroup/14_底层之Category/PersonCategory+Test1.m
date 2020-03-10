//
//  PersonCategory+Test1.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/9.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "PersonCategory+Test1.h"
#import <objc/runtime.h>

@implementation PersonCategory (Test1)

- (void)test {
    NSLog(@"%s", __func__);
}

+ (void)load {
    NSLog(@"%s", __func__);
}

+ (void)initialize {
    NSLog(@"%s", __func__);
}

// 通过runtime的关联对象，给分类动态添加属性
// 方式一
static const void *NameKey;
- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, &NameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, &NameKey);
}

// 方式二
static const char NickNameKey;
- (void)setNickName:(NSString *)nickName {
    objc_setAssociatedObject(self, &NickNameKey, nickName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)nickName {
    return objc_getAssociatedObject(self, &NickNameKey);
}

// 方式三
#define		kAvatarKey		@"avatar"
- (void)setAvatar:(NSString *)avatar {
    objc_setAssociatedObject(self, kAvatarKey, avatar, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)avatar {
    return objc_getAssociatedObject(self, kAvatarKey);
}

// 方式四
- (void)setSchool:(NSString *)school {
    objc_setAssociatedObject(self, @selector(school), school, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)school {
    return objc_getAssociatedObject(self, _cmd);
    // 这两句等价，方法默认有两个隐式参数，一个是id类型的self，一个是SEL类型的_cmd
//    return objc_getAssociatedObject(self, @selector(school));
}

@end
