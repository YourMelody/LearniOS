//
//  RuntimeMan.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/11.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "RuntimeMan.h"

#define TallMask        (1<<0)
#define RichMask        (1<<1)
#define HandsomeMask    (1<<2)

@interface RuntimeMan()
{
    union {
        char bits;
        
        struct {
            char tall : 1;
            char rich : 1;
            char handsome : 1;
        };
    } _tallRichHandsomeUnion;
}
@end

@implementation RuntimeMan

- (void)setTall:(BOOL)tall {
    if (tall) {
        _tallRichHandsomeUnion.bits |= TallMask;
    } else {
        _tallRichHandsomeUnion.bits &= ~TallMask;
    }
}

- (void)setRich:(BOOL)rich {
    if (rich) {
        _tallRichHandsomeUnion.bits |= RichMask;
    } else {
        _tallRichHandsomeUnion.bits &= ~RichMask;
    }
}

- (void)setHandsome:(BOOL)handsome {
    if (handsome) {
        _tallRichHandsomeUnion.bits |= HandsomeMask;
    } else {
        _tallRichHandsomeUnion.bits &= ~HandsomeMask;
    }
}



- (BOOL)isTall {
    return !!(_tallRichHandsomeUnion.bits & TallMask);
}

- (BOOL)isRich {
    return !!(_tallRichHandsomeUnion.bits & RichMask);
}

- (BOOL)isHandsome {
    return !!(_tallRichHandsomeUnion.bits & HandsomeMask);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"tall:%d, rich:%d, handsome:%d", self.isTall, self.isRich, self.isHandsome];
}

@end
