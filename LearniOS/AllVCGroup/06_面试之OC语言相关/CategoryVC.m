//
//  CategoryVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/19.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "CategoryVC.h"
#import "Person+Student.h"
#import "PersonObsever.h"

@interface CategoryVC ()

@end

@implementation CategoryVC

/*
代理delegate：
   1、代理是一种设计模式
   2、iOS中以@protocol形式体现
   3、一对一
   4、协议中可以定义方法和属性
   5、一般声明为weak以规避循环引用


通知NSNotification：
   1、是使用观察者模式实现的，用于跨层传递消息的机制
   2、传递方式为一对多
   3、通知机制：Notification_Map--@{notificationName: Observers_List}

KVO即Key-value observing的缩写
   1、KVO是OC对观察者设计模式的又一实现
   2、Apple使用isa混写（isa-swizzling）来实现KVO
   3、注册某个对象的观察者
       -> addObserverForKeyPath:
       -> 运行时动态创建继承自原类A的子类NSKVONotifying_A
       -> 将A的isa指向NSKVONotifying_A
       -> 重写子类中该对象的setter方法，重写的setter方法负责通知所有观察对象
            - (void)setValue:(id)obj {
                [self willChangeValueForKey:@"keyPath"];
                // 调用父类实现
                [super setValue:obj];
                [self didChangeValueForKey:@"keyPath"];
            }
 
 KVC即Key-value coding的缩写，会破坏面向对象编程思想，可以为对象的私有变量 赋值
    1、valueForKey系统实现流程：
        首先判断通过key访问的变量，是否有对应的get方法；注意 -getKey: -key: 和 -isKey: 方法都会认为get方法是存在的
        如果没有，判断是否有对应的同名/相似名称的实例变量。注意 _key _isKey key isKey都认为是存在对应的实例变量
            系统提供了+(BOOL)accessInstanceVariablesDirectly方法，默认返回YES，可以控制是否存在实例变量。
        如果不存在 对应的实例变量，系统调用valueForUndefinedKey:，抛出NSUndefinedKeyException异常
    - (id)valueForKey:(NSString *)key;
 
    2、setValue:forKey:系统实现流程基本类似valueForKey
    - (void)setValue:(id)value forKey:(NSString *)key;
 
 属性关键字
    1、读写权限 readwrite(默认值) readonly
    2、原子性
        atomic(默认值)
            能保证对属性的赋值和获取操作是线程安全的，但不能保证对属性的操作是线程安全的
            例如atomic修饰的数组，不能保证对数组元素的增加、删除操作是线程安全的
        nonatomic
    3、引用计数
        retain/strong 修饰对象
        assign 既可修饰对象，也可修饰基本数据类型；不改变引用计数；修饰的对象被释放后，指针仍然指向原对象的地址，产生悬垂指针。
        unsafe_unretained 基本只在MRC使用
        weak 修饰对象，不改变引用计数；所修饰的对象被释放后，会自动置为nil
        copy 深拷贝会产开辟新的内存空间；浅拷贝会增加对象的引用计数。
             可变对象的copy和mutableCopy都是深拷贝
             不可变对象的copy是浅拷贝，mutableCopy是深拷贝
             copy返回的都是不可变对象
    MRC下重写retain修饰变量的setter方法
    - (void)setObj:(id)obj {
        if (_obj != obj) {
            [_obj release];
            _obj = [obj retain];
        }
    }
    
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    Person *person = [[Person alloc] init];
    PersonObsever *ob = [[PersonObsever alloc] init];
    NSLog(@"%s", object_getClassName(person));  // Person
    [person addObserver:ob forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [person addObserver:ob forKeyPath:@"weight" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"%s", object_getClassName(person));  // NSKVONotifying_Person
    person.name = @"测试";        // 触发kvo
    // 1、通过kvc设置value，也可以触发kvo
    [person setValue:@"kvc设值" forKey:@"name"];  // 会调用setter方法，触发kvo
    // 2、通过成员变量直接赋值，不会触发kvo
    person.weight = 10;         // 触发kvo
    [person increaseWeight];    // 不会触发kvo
    [person kvoIncreaseWeight]; // 会触发kvo
    person.height = 10;
}

@end
