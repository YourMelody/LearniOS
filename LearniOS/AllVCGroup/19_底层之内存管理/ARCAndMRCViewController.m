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
@property (nonatomic, strong)dispatch_source_t gcgTimer;
@property (nonatomic, copy)NSString *nameStr;

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
     
     2、NSTimer依赖于RunLoop，如果RunLoop任务过于繁重，可能导致timer不准时
        GCD的定时器会更加准时
     
     3、iOS程序的内存布局，地址从低到高：
        保留
        -> 代码段：编译之后的代码
        -> 数据段：
            字符串常量：如NSString *str = @"123";
            已初始化数据：已初始化的全局变量、静态变量等
            未初始化数据：未初始化的全局变量、静态变量等
        -> 堆（heap）（内部从低到高）：
            通过alloc、malloc、calloc等动态分配的空间
        -> 栈（stack）（内部从高到低）：
            函数调用开销，比如局部变量，分配的内存地址越来越小
        -> 内核区
     
     4、从64bit开始，iOS引入了Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储
     
     5、OC对象的内存管理
        . 在iOS中，使用引用计数来管理OC对象的内存
        . 一个新创建的OC对象引用计数默认是1，当引用计数减为0，OC对象就会销毁，释放对象占用的内存空间
        . 调用retain会让OC对象的引用计数+1，调用release会让引用计数-1
        . 调用alloc、new、copy、mutableCopy方法返回了一个对象，在不需要这个对象时，要调用
            release或autorelease来释放它
        . 可以通过以下私有函数来查看自动释放池的情况
            extern void _objc_autoreleasePoolPrint(void);
     
     6、ARC是LVVM+RunTime相互协作的额结果。
        某个对象销毁时，会根据对象找到对应的弱引用表，将所有弱引用清空置为nil。
     
     7、自动释放池的主要底层数据结构是：__AtAutoreleasePool、AutoreleasePoolPage
        调用了autorelease的对象最终是通过AutoreleasePoolPage对象来管理。
        每个AutoreleasePoolPage占用4096字节，除了存放自己内部的成员变量，剩下的用来存放autorelease对象的地址。
        多有AutoreleasePoolPage通过双向链表的方式连接在一起
     
     8、AutoreleasePoolPage的结构
        调用push方法会将一个POOL_BOUNDARY入栈，并且返回其存放的内存地址
        调用pop时传入POOL_BOUNDARY的内存地址，会从最后一个入栈的对象开始发送release消息，直到遇到这个POOL_BOUNDARY
     
     9、autorelease对象在什么时候被释放：
        iOS在主线程的RunLoop中注册了2个Observer
        . 第一个Observer监听了kCFRunLoopEntry事件，会调用objc_autoreleasePoolPush()
        . 第二个Observer监听了kCFRunLoopBeforeWaiting事件，会调用objc_autoreleasePoolPop()、objc_autoreleasePoolPush()
        autorelease对象的释放，是由RunLoop来控制的。可能在某次RunLoop循环中、RunLoop休眠之前被释放
        
     */
    
    
    // CADisplayLink保证调用频率和屏幕刷新频率一致
//    self.link = [CADisplayLink displayLinkWithTarget:[SystemProxy proxyWithTarget:self] selector:@selector(linkTest)];
//    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[ZFProxy proxyWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    // GCD定时器
//    self.gcgTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
//    dispatch_source_set_timer(self.gcgTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//    dispatch_source_set_event_handler(self.gcgTimer, ^{
//        NSLog(@"GCD定时器---%@", [NSThread currentThread]);
//    });
//    dispatch_resume(self.gcgTimer);
    
    // 崩溃
    [self interview1];
    
    // 正常运行
    [self interview2];
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

- (void)interview1 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            // 系统不会使用Tagged Pointer技术，会正常执行setNameStr:方法
            // 由于set方法中，会调用release，多个线程同时调用release，可能引起坏内存访问，导致崩溃
            // 解决办法：属性用atomic修饰（效率低，不建议）；手动在set方法添加其他锁
            self.nameStr = [NSString stringWithFormat:@"abcdefghijk"];
        });
    }
}

- (void)interview2 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            self.nameStr = [NSString stringWithFormat:@"abc"];
        });
    }
}

@end
