//
//  ObjectiveViewController.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/8.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "ObjectiveViewController.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "NSObject+Test.h"

/**********************************   PersonObj   *************************************/
#pragma mark - PersonObj类，继承自NSObject
@interface PersonObj : NSObject {
    int _age;
}
@end

@implementation PersonObj
@end

/********************************   Student   ******************************************/
#pragma mark - Student类，继承自Person
@interface Student : PersonObj {
    int _no;
}
@end

@implementation Student
@end

/********************************   Man   ******************************************/
@interface Man : PersonObj {
    int _height;
    int _weight;
    int _money;
}
@end

@implementation Man
@end


/********************************   TestObj1   ******************************************/
@interface TestObj1 : NSObject

@property(nonatomic, assign) int age;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, assign) int height;

@end

@implementation TestObj1
@end

/********************************   TestObj2   ******************************************/
@interface TestObj2 : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, assign) int age;
@property(nonatomic, assign) int height;

@end

@implementation TestObj2
@end

/********************************   ObjectiveViewController   ******************************************/
@interface ObjectiveViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, copy)NSArray *dataSource;

@end

@implementation ObjectiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"底层之OC对象";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = @[
                        @"1、NSObject对象占用内存大小",
                        @"2、对象、类对象、元类对象",
                        @"3、测试"
                        ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self objcSizeFunc];
    } else if (indexPath.row == 1) {
        [self instanceAndClassAndMetaClass];
    } else if (indexPath.row == 2) {
        [self testFunction];
    }
}

#pragma mark - 1、对象占用内存空间大小
- (void)objcSizeFunc {
    /*
     1、我们平时编写的OC代码，底层实现其实是C/C++代码：
     OC ---> C/C++ ---> 汇编语言 --> 机器语言
     2、OC的面相对象都是基于C/C++的结构体数据结构实现的
     3、NSObject对象的底层实现为：
     struct NSObject_IMPL {
        Class isa;
     }
     4、一个NSObject对象占用多少内存？
     系统分配了16个字节的空间给NSObject对象，可以通过malloc_size()函数获得（即实际分配的内存大小）。
     但是NSObject对象内部只使用了8个字节的空间用来存放isa指针（在64bit环境下），可以通过class_getInstanceSize()函数获得（即至少需要多少内存）。
     因为CoreFoundation框架内部规定，一个对象至少会分配16个字节空间，并且一定是16的倍数。
     5、内存对齐：结构体的大小必须是最大成员大小的倍数。class_getInstanceSize获取的大小是内存对齐过的大小。
     */
    
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"obj所有成员变量占用的总字节数：%zd", class_getInstanceSize([obj class]));        // 8
    NSLog(@"obj指针所指向内存的大小：%zd", malloc_size((__bridge const void *)obj));        // 16
    
    PersonObj *person = [[PersonObj alloc] init];
    NSLog(@"person成员变量占用字节：%zd", class_getInstanceSize([person class]));            // 16，因为内存对齐
    NSLog(@"person指针所指向内存的大小：%zd", malloc_size((__bridge const void *)person));  // 16
    
    Student *student = [[Student alloc] init];
    NSLog(@"student成员变量占用字节：%zd", class_getInstanceSize([student class]));            // 16
    NSLog(@"student指针所指向内存的大小：%zd", malloc_size((__bridge const void *)student));// 16
    
    Man *man = [[Man alloc] init];
    NSLog(@"man成员变量占用字节：%zd", class_getInstanceSize([man class]));                    // 24，因为内存对齐
    NSLog(@"man指针所指向内存的大小：%zd", malloc_size((__bridge const void *)man));            // 32，因为内存分配都是16的倍数
}


#pragma mark - 2、isa相关
- (void)instanceAndClassAndMetaClass {
    
    /*
     1、实例对象：isa指针+其他成员变量的值
     2、类对象（某个类只有一个类对象）：
     	isa指针+superclass+属性信息（如属性修饰符、属性名字等）+成员变量信息（如变量名称、类型等）+协议信息+对象方法信息等
     3、元类对象（某个类也只有一个元类对象）：
     	isa指针+superclass+类方法信息等
     4、实例对象的isa->类对象
     	类对象的isa->元类对象
     	元类对象的isa->基类的元类对象
     	基类的元类对象的isa->自己
     	基类的元类对象的superclass->基类的类对象
     5、在64bit之前，实例对象的isa和类对象地址相同，类对象的isa和元类对象地址相同
     	从64bit开始，isa需要进行一次位运算，才能计算出真实地址: isa & ISA_MASK
     */
    NSObject *obj1 = [[NSObject alloc] init];
    NSObject *obj2 = [[NSObject alloc] init];
    
    // 获取类对象
    Class objClass1 = [obj1 class];
    Class objClass2 = [obj2 class];
    Class objClass3 = [NSObject class];
    Class objClass4 = object_getClass(obj1);
    Class objClass5 = object_getClass(obj2);
    Class objClass6 = [[NSObject class] class];

    // 6个地址一样，因为某个类只有一个类对象
    NSLog(@"类对象地址：%p---%p---%p---%p---%p---%p", objClass1, objClass2, objClass3, objClass4, objClass5, objClass6);
    
    // 获取元类对象：object_getClass会返回传入参数的isa指向的对象，因此，传入实例对象返回类对象，传入类对象返回元类对象
    Class objMetaClass1 = object_getClass(objClass1);
    Class objMetaClass2 = [objMetaClass1 class];
    NSLog(@"元类对象地址：%p--%p", objMetaClass1, objMetaClass2);
    
    // 判断一个对象是否为元类对象
    NSLog(@"%d---%d---%d", class_isMetaClass(objMetaClass1), class_isMetaClass(objClass5), class_isMetaClass(objClass6));
    
    // 由于NSObject的元类对象的superclass->NSObject的类对象，所以能够成功调用NSObject中的-test对象方法。
    [PersonObj test];
}

- (void)testFunction {
    TestObj1 *obj1 = [[TestObj1 alloc] init];
    obj1.name = @"name1";
    obj1.address = @"address1";
    obj1.age = 18;
    obj1.height = 180;
    NSLog(@"obj1实例对象的成员变量占用内存空: %zd", class_getInstanceSize(obj1.class)); // 32
    NSLog(@"obj1指针所指向内存的大小：%zd", malloc_size((__bridge const void *)obj1)); // 32
    
    TestObj2 *obj2 = [[TestObj2 alloc] init];
    obj2.name = @"name2";
    obj2.address = @"address2";
    obj2.age = 120;
    obj2.height = 190;
    NSLog(@"obj2实例对象的成员变量占用内存空: %zd", class_getInstanceSize(obj2.class)); // 32
    NSLog(@"obj2指针所指向内存的大小：%zd", malloc_size((__bridge const void *)obj2)); // 32
}

@end
