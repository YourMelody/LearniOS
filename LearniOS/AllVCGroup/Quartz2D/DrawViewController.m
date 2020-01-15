//
//  DrawViewController.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/14.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "DrawViewController.h"

@interface DrawViewController ()

@property (weak, nonatomic) IBOutlet DrawView *drawV;
@property (weak, nonatomic) IBOutlet UILabel *progressLab;
@property (weak, nonatomic) IBOutlet UISlider *mySlider;

@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.drawV.drawType = self.drawType;
    self.progressLab.hidden = self.drawType != DrawType_Progress;
    self.mySlider.hidden = self.drawType != DrawType_Progress;
}

- (IBAction)changeProgress:(UISlider *)sender {
    self.progressLab.text = [NSString stringWithFormat:@"%.2f%%", sender.value * 100];
    self.drawV.myProgress = sender.value;
}

@end
