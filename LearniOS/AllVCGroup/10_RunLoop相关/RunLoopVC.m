//
//  RunLoopVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/21.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "RunLoopVC.h"

@interface RunLoopVC ()

@end

@implementation RunLoopVC

/*
 什么是RunLoop
    RunLoop是通过内部维护的事件循环来对时间/消息进行管理的一个对象。
    在没有消息需要处理时，休眠以避免资源占用；
    有消息需要处理时，立刻被唤醒。
 
 数据结构
    NSRunLoop是对CFRunLoop的封装，提供了面向对象的API
    NSRunloopCommonModes不是实际存在的一种mode，是同步Source/Timer/Observer到多个Mode中的一种技术方案。
    1、CFRunLoop
        pthread ->线程  RunLoop和线程是一一对应的关系
        currentMode ->CFRunLoopMode
        modes -> NSMutableSet<CFRunLoopMode *>
        commonModes -> NSMutableSet<NSString *>
        commonModeItems -> Source/Timer/Observer的集合
    2、CFRunLoopMode
        name -> 名称
        sources0 需要手动唤醒线程
        sources1 具备唤醒线程的能力
        observers
        timers
    3、Source/Timer/Observer
 
 事件循环机制
 
 RunLoop与NSTimer
 
 RunLoop与多线程
    主线程的RunLoop是默认开启的；子线程的RunLoop是懒加载的，默认没有开启。
    实现一个常驻线程：
        1、为当前线程开启一个RunLoop
        2、像该RunLoop中添加一个Port/Source等维持RunLoop的事件循环
        3、启动该RunLoop
 */
- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
 网络相关：
 HTTP协议：超文本传输协议
    请求/响应报文
    连接建立流程
    HTTP的特点
        无连接，HTTP的持久连接
        无状态，Cookie/Session
 
 HTTPS和网络安全
 TCP/UDP
 DNS解析
 Session/Cookie
 */

@end
