//
//  HitTestVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/13.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "HitTestVC.h"
#import "ChildButton.h"

@interface HitTestVC ()

@end

@implementation HitTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)shadowBtnAction:(UIButton *)sender {
    NSLog(@"点击了上面btn---");
}

- (IBAction)moveBtnAction:(ChildButton *)sender {
    NSLog(@"点击了childBtn---");
    if (sender.popBtn) return;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, -90, 80, 80);
    [button setImage:[UIImage imageNamed:@"icon_logo.png"] forState:UIControlStateNormal];
    sender.popBtn = button;
    [sender addSubview:button];
}

@end
