//
//  RunloopViewController.m
//  LearniOS
//
//  Created by JKFunny on 2020/3/14.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "RunloopViewController.h"
#import "ZFPermenantThread.h"

@interface RunloopViewController ()

@property (nonatomic, strong)ZFPermenantThread *myThread;
@property (nonatomic, assign)BOOL canStop;

@end

@implementation RunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"底层之Runloop";
    
    self.myThread = [[ZFPermenantThread alloc] init];
    
    [self runloopBase];
}

- (void)runloopBase {
    /*
     1、iOS中有2套API来访问和使用Runloop：
        Foundation框架下的NSRunLoop  CoreFoundation框架下的CFRunLoopRef。
        NSRunLoop和CFRunLoopRef都代表着RunLoop对象，NSRunLoop是基于CFRunLoopRef的一层OC包装
     2、RunLoop与线程：
        每条线程都有唯一的一个与之对应的RunLoop对象。RunLoop保存在一个全局的Dictionary中，线程作为Key，RunLoop作为Value；
        线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建，并且在线程结束时销毁。
        主线程的RunLoop已经自动获取（创建），子线程默认没有开启RunLoop
     
     3、RunLoop相关的类
        Core Foundation中关于RunLoop的5个类：
        . CFRunLoopRef
        . CFRunLoopModeRef
        . CFRunLoopSourceRef
        . CFRunLoopTimerRef
        . CFRunLoopObserverRef
     
        底层结构
        typedef struct __CFRunLoop * CFRunLoopRef;
        struct __CFRunLoop {
            pthread_t pthread;
            CFMutableSetRef _commonModes;
            CFMutableSetRef _commonModeItems;
            CFRunLoopModeRef _currentMode;
            CFMutableSetRef _modes; // CFRunLoopModeRef的集合
        }
     
        CFRunLoopModeRef底层结构
        typedef struct __CFRunLoopMode *CFRunLoopModeRef;
        struct __CFRunloopMode {
            CFStringRef _name;
            CFMutableSetRef _source0;
            CFMutableSetRef _source1;
            CFMutableSetRef _observers;
            CFMutableSetRef _timers;
        }
     
    4、CFRunLoopModeRef代表RunLoop的运行模式。一个RunLoop包含若干mode，每个mode又包含若干source0/source1/timer/observer;
        RunLoop启动时只能选择其中一个mode作为currentMode；如果需要切换mode，只能退出当前Loop，再重新选择一个mode进入（好处：不同
        组的source0/source1/timer/observer能分隔开来，互补影响）；如果mode中没有任何source0/source1/timer/observer，
        RunLoop会立马退出。
        常见的两种Mode：
        . kCFRunLoopDefaultMode(NSDefaultRunLoopmode): App默认在该模式下运行
        . UITrackingRunLoopMode: 界面跟踪mode，用于scrollview追踪滑动，保证界面滑动不受其他mode影响
    
     5、Source0：
        . 触摸事件处理
        . performSelector:onThread:
     
        Source1：
        . 基于Port的线程间通信
        . 系统事件捕捉
        
        Timer：
        . NSTimer
        . performSelector:withObject:afterDelay:
     
        Observers：
        . 用于监听RunLoop的状态
        . UI刷新（BeforeWaiting）
        . Autorelease pool的释放
     
        几种状态：
        typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
            kCFRunLoopEntry = (1UL << 0),           // 即将进入Loop
            kCFRunLoopBeforeTimers = (1UL << 1),    // 即将处理Timer
            kCFRunLoopBeforeSources = (1UL << 2),   // 即将处理Source
            kCFRunLoopBeforeWaiting = (1UL << 5),   // 即将进入休眠
            kCFRunLoopAfterWaiting = (1UL << 6),    // 刚从休眠中唤醒
            kCFRunLoopExit = (1UL << 7),            // 即将推出Loop
            kCFRunLoopAllActivities = 0x0FFFFFFFU
        }
     
     6、RunLoop的运行逻辑
        01.通知Observers，进入Loop
        02.通知Observers，即将处理Timers
        03.通知Observers，即将处理Sources
        04.处理Blocks
        05.处理Source0（处理完之后，根据返回值，可能再次处理Blocks）
        06.如果存在Source1，就跳转到第8步
        07.通知Observers，开始休眠（等待消息唤醒）
        08.通知Observers，结束休眠（被某个消息唤醒）
            . 处理Timer
            . 处理GCD Async To Main Queue
            . 处理Source1
        09.处理Blocks
        10.根据前面的执行结果，决定如何操作
            . 回到02
            . 退出Loop
        11.通知Observers，退出Loop
     */
    
    // 获取RunLoop对象
    NSLog(@"%p---%p---%p---%p", [NSRunLoop currentRunLoop], [NSRunLoop mainRunLoop], CFRunLoopGetCurrent(), CFRunLoopGetMain());
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.myThread executeTask:^{
        NSLog(@"执行任务：%@", [NSThread currentThread]);
    }];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self.myThread stop];
}

@end
