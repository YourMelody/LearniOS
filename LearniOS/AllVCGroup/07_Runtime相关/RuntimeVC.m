//
//  RuntimeVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/20.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "RuntimeVC.h"
#import "RuntimeObj.h"

@interface RuntimeVC ()

@end

@implementation RuntimeVC

/*
 id == objc_object：
    isa_t
    关于isa操作相关
    弱引用相关
    关联对象相关
    内存管理相关
 
 Class == objc_class，继承自objc_object：
    Class superClass;
    cache_t cache;
    class_data_bits_t bits; 包含变量、属性、方法等
 
 isa == 共用体isa_t（64架构而言）
    指针型isa，64位的值代表Class的地址
    非指针型isa，64位的部分值代表Class的地址
    实例对象的isa指针，指向其类对象，调用实例方法就是通过isa指针，到类对象的方法列表中查找
    类对象的isa指针，指向其元类对象，调用类方法就是通过isa指针，到元类对象的方法列表中查找
 
 catche_t
    用于快速查找方法执行函数
    可增量扩展的哈希表结构
    是局部性原理的最佳应用
    @[bucket_t, bucket_t, ...]
    bucket_t: key -> SEL
              IMP -> 无类型的函数指针
 
 class_data_bits_t主要是对class_rw_t的封装
 class_rw_t代表了类相关的读写信息，是对class_ro_t的封装
    class_ro_t
    protocols
    proterties
    methods 二维数组，内层数组中是method_t
 class_ro_t代表了类相关的只读信息
    name 类名
    ivars 类的成员变量
    properties 属性
    protocols
    methodList method_t的一维数组
 method_t
    名称      SEL name
    返回值     const char* types; v<->void  @<->id  :<->SEL
    参数      const char* types;
    函数体     IMP imp;
    
 
 对象、类对象、元类对象：
    类对象存储实例方法列表等信息
    元类对象存储类方法列表等信息
    类对象和元类对象都是objc_class的数据结构
    实例对象的isa指针指向其类对象，类对象isa指针指向其元类对象，元类对象isa指针都指向根元类对象，根元类的isa指针指向自己
    注意：根元类对象的superclass指向其根类对象，根类对象的isa指针指向其根元类对象。因此，当某个类方法只有声明没有实现，
        但是有同名的实例方法时，当调用该类方法时，不会发生崩溃，而是会调用对应的实例方法。
 
 消息传递
    [self class] <---> objc_msgSend(self, @selector(class))
    [super class] <---> objc_msgSendSuper(super, @selector(class))
 
 消息转发
    1、+(BOOL)resolveInstanceMethod: 返回YES，表示消息已处理；返回NO执行2
    2、指定消息转发目标forwardingTargetForSelector: 返回了转发目标则由转发目标处理消息；返回nil则执行3
    3、methodSignatureForSelector:返回方法签名，则执行4；返回为nil，则标示消息无法处理
    4、forwardInvocation:能处理消息则处理并结束；无法处理，则标记为消息无法处理
 
 Method-Swizzling
 
 @dynamic
    动态执行时语言将函数决议推迟到运行时
    编译时语言在编译期进行函数决议
 
 runtime如何通过Selector找到对应的IMP地址的？
    查找当前实例对象对应类对象的缓存中是否有Selector对应的IMP实现，如果缓存中有，则把缓存中的实现返回给调用放；
    如果缓存中没有，再根据当前类的方法列表，查找Selector对应的IMP实现，当前类中有，直接返回给调用放；
    如果当前类方法列表中没有，再根据当前类的superclass指针，逐级查找父类的方法列表。。。
 
 不能向编译后的类中增加实例变量
 可以向动态添加的类中增加实例变量
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    RuntimeObj *obj = [[RuntimeObj alloc] init];
    [obj test];
    NSLog(@"=====分割线=====");
    [obj otherTest];
    NSLog(@"=====分割线=====");
    // 调用obj不存在的方法，执行方法转发流程
    [obj performSelector:@selector(abc)];
    NSLog(@"=====分割线=====");
    // 动态添加方法
    [obj performSelector:@selector(testImp)];
}

@end
