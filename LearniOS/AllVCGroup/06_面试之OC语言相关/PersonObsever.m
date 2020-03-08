//
//  PersonObsever.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/20.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "PersonObsever.h"
#import "Person.h"

@implementation PersonObsever

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[Person class]]) {
        if ([keyPath isEqualToString:@"name"]) {
            NSLog(@"name is %@", change[NSKeyValueChangeNewKey]);
        } else if ([keyPath isEqualToString:@"weight"]) {
            NSLog(@"weight is %f", [change[NSKeyValueChangeNewKey] floatValue]);
        }
    }
}

@end
