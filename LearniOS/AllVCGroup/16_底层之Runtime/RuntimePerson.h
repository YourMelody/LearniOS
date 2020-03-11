//
//  RuntimePerson.h
//  LearniOS
//
//  Created by 张帆 on 2020/3/11.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimePerson : NSObject

- (void)setTall:(BOOL)tall;
- (void)setRich:(BOOL)rich;
- (void)setHandsome:(BOOL)handsome;

- (BOOL)isTall;
- (BOOL)isRich;
- (BOOL)isHandsome;

@end
