//
//  PersonCategory.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/9.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "PersonCategory.h"

@implementation PersonCategory

- (void)test {
    NSLog(@"%s", __func__);
}

+ (void)load {
    NSLog(@"%s", __func__);
}

+ (void)initialize {
    NSLog(@"%s", __func__);
}

@end
