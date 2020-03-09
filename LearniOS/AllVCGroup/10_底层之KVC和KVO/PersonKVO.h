//
//  PersonKVO.h
//  LearniOS
//
//  Created by 张帆 on 2020/3/8.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonKVO : NSObject
{
    @public
    int _age;
    int _weight;
}

@property(nonatomic, assign)int age;
@property(nonatomic, assign)int height;

@end
