//
//  RuntimeStudent.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/11.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "RuntimeStudent.h"

@interface RuntimeStudent()
{
    struct {
        char tall : 1;
        char rich : 1;
        char handsome : 1;
    } _tallRichHandsome;
}
@end

@implementation RuntimeStudent

- (void)setTall:(BOOL)tall {
    _tallRichHandsome.tall = tall;
}
- (void)setRich:(BOOL)rich {
    _tallRichHandsome.rich = rich;
}
- (void)setHandsome:(BOOL)handsome {
    _tallRichHandsome.handsome = handsome;
}



- (BOOL)isTall {
    return !!_tallRichHandsome.tall;
}
- (BOOL)isRich {
    return !!_tallRichHandsome.rich;
}
- (BOOL)isHandsome {
    return !!_tallRichHandsome.handsome;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"tall:%d, rich:%d, handsome:%d", self.isTall, self.isRich, self.isHandsome];
}

@end
