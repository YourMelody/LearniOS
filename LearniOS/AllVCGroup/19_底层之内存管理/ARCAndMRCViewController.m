//
//  ARCAndMRCViewController.m
//  LearniOS
//
//  Created by JKFunny on 2020/3/15.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "ARCAndMRCViewController.h"
#import "ZFProxy.h"
#import "SystemProxy.h"

@interface ARCAndMRCViewController ()

@property (nonatomic, strong)CADisplayLink *link;
@property (nonatomic, strong)NSTimer *timer;

@end

@implementation ARCAndMRCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"底层之内存管理";
    
    [self function1];
}

- (void)function1 {
    /*
     1、CADisplayLink、NSTimer会对target产生强引用，如果target又对他们产生强引用，那么会形成循环引用
     */
    
    
    // CADisplayLink保证调用频率和屏幕刷新频率一致
    self.link = [CADisplayLink displayLinkWithTarget:[SystemProxy proxyWithTarget:self] selector:@selector(linkTest)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[ZFProxy proxyWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
}

- (void)linkTest {
    NSLog(@"%s", __func__);
}

- (void)timerTest {
    NSLog(@"%s", __func__);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self.link invalidate];
    [self.timer invalidate];
}

@end
