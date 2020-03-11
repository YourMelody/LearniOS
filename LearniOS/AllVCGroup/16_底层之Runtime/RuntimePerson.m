//
//  RuntimePerson.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/11.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "RuntimePerson.h"

#define TallMask		(1<<0)
#define RichMask		(1<<1)
#define HandsomeMask	(1<<2)

@interface RuntimePerson()
{
    char _tallRichHandsome;
}
@end

@implementation RuntimePerson

- (instancetype)init {
    if (self = [super init]) {
        _tallRichHandsome = 0b00000000;
    }
    return self;
}

- (void)setTall:(BOOL)tall {
    if (tall) {
        _tallRichHandsome |= TallMask;
    } else {
        _tallRichHandsome &= ~TallMask;
    }
}

- (void)setRich:(BOOL)rich {
    if (rich) {
        _tallRichHandsome |= RichMask;
    } else {
        _tallRichHandsome &= ~RichMask;
    }
}

- (void)setHandsome:(BOOL)handsome {
    if (handsome) {
        _tallRichHandsome |= HandsomeMask;
    } else {
        _tallRichHandsome &= ~HandsomeMask;
    }
}



- (BOOL)isTall {
    return !!(_tallRichHandsome & TallMask);
}

- (BOOL)isRich {
    return !!(_tallRichHandsome & RichMask);
}

- (BOOL)isHandsome {
    return !!(_tallRichHandsome & HandsomeMask);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"tall:%d, rich:%d, handsome:%d", self.isTall, self.isRich, self.isHandsome];
}

@end
