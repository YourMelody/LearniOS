//
//  KVCAndKVOVC.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/8.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "KVCAndKVOVC.h"
#import "PersonKVO.h"
#import <objc/runtime.h>

@interface KVCAndKVOVC ()

@property(nonatomic, strong)PersonKVO *person;
@property(nonatomic, strong)PersonKVO *anotherPer;

@end

@implementation KVCAndKVOVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"底层之KVC和KVO";
    self.view.backgroundColor = [UIColor whiteColor];
    [self kvoBase];
}

- (void)kvoBase {
    /*
     1、KVO: Key-Value Observing 键值监听，可用于监听某个对象属性值的改变
     2、对象的某个属性添加监听之后，系统会通过Runtime动态生成一个新类NSKVONotifying_XXX
     	且新生成的类继承自原有类，然后会修改对象的isa指向新生成类。在NSKVONotifying_XXX内部，
     	重新实现了属性的set方法、class方法、dealloc方法和_isKVOA方法。
     	2.1 重写了set方法:
     		调用了Foundation框架下的_NSSetXXXValueAndNotify方法，在
     		_NSSetXXXValueAndNotify方法内部，又先后调用了willChangeValueForKey:、
     		[super setXXX:]和didChangeValueForKey:，又在didChangeValueForKey内部
     		调用监听器的监听方法observeValueForKeyPath:ofObject:xxxxxx
     	2.2 重写了class方法：
     		return [PersonKVO class];
     		原来的实现可能为 return object_getClass(self);
     	2.3 重写了dealloc方法，用来移除监听
     3、如何手动触发KVO
     	主动调用willChangeValueForKey: 和 didChangeValueForKey:
     4、直接修改成员变量的值，而不是通过set方法修改，不能触发KVO
     5、通过KVC修改属性值，能否触发KVO？
     */
    self.person = [[PersonKVO alloc] init];
    self.person.age = 18;
    self.person.height = 180;
    
    self.anotherPer = [[PersonKVO alloc] init];
    self.anotherPer.age = 22;
    self.anotherPer.height = 188;
    
    // PersonKVO---PersonKVO
    NSLog(@"添加监听之前：%@---%@", object_getClass(self.person), object_getClass(self.anotherPer));
    
    // 添加监听
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.person addObserver:self forKeyPath:@"age" options:options context:@"123"];
    [self.person addObserver:self forKeyPath:@"height" options:options context:@"456"];
    [self.person addObserver:self forKeyPath:@"weight" options:options context:@"789"];
    
    // NSKVONotifying_PersonKVO---PersonKVO
    NSLog(@"添加监听之后：%@---%@", object_getClass(self.person), object_getClass(self.anotherPer));
    
    // 打印方法列表
    // NSKVONotifying_PersonKVO：setHeight:, setAge:, class, dealloc, _isKVOA,
    [self printMethodNamesOfClass:object_getClass(self.person)];
    // PersonKVO：height, setHeight:, setAge:, age,
    [self printMethodNamesOfClass:object_getClass(self.anotherPer)];
}

- (void)kvcBase {
    /*
     1、setValue:forKey:的原理
     	1.1 首先按照setKey:、_setKey: 的顺序查找方法，找到了，直接调用；没有找到，执行下一步
     	1.2 查看accessInstanceVariablesDirectly的返回值，默认返回YES。如果返回NO，则
     		报错：setValue:forUndefinedKey:抛出异常；返回YES则执行下一步
     	1.3 按照_key、_isKey、key、isKey的顺序查找成员变量。找到则直接赋值；没有找到，则抛出1.2中的异常
     2、valurForKey:的原理
     	1.1 首先按照getKey、key、isKey、_key顺序查找方法，找到了，直接调用；没有找到，执行下一步
     	1.2 查看accessInstanceVariablesDirectly的返回值，默认返回YES。如果返回NO，则
     		报错：valueforUndefinedKey:抛出异常；返回YES则执行下一步
     	1.3 按照_key、_isKey、key、isKey顺序查找成员变量。找到则直接赋值；没有找到，则抛出1.2中的异常
     3、通过KVC修改属性值，可以触发KVO，不管是否有set方法，都会触发。因为KVC内部会自动调用
     	willChangeValueForKey:和didChangeValueForKey:
     */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 触发KVO
    self.person.age = 20;
    self.person.height = 183;
    
    // 不会触发KVO，没有对self.anotherPer添加监听
    self.anotherPer.age = 30;
    self.anotherPer.height = 190;
    
    // 修改成员变量+手动触发KVO
    [self.person willChangeValueForKey:@"age"];
    self.person->_age = 40;
    [self.person didChangeValueForKey:@"age"];
    
    // 通过KVC修改成员变量的值，可以触发KVO
    [self.person setValue:@"222" forKey:@"weight"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"监听到了%@的%@属性值发生了变化：%@--%@", object, keyPath, change, context);
}

- (void)dealloc {
    [self.person removeObserver:self forKeyPath:@"age"];
    [self.person removeObserver:self forKeyPath:@"height"];
}

- (void)printMethodNamesOfClass:(Class)cls {
    unsigned int count;
    // 获取方法数组
    Method *methodList = class_copyMethodList(cls, &count);
    NSMutableString *methodStr = [NSMutableString string];
    for (int i = 0; i < count; i++) {
        // 获取方法
        Method aMethod = methodList[i];
        NSString *methodName = NSStringFromSelector(method_getName(aMethod));
        [methodStr appendFormat:@"%@, ", methodName];
    }
    free(methodList);
    NSLog(@"%@：%@", cls, methodStr);
}

@end
