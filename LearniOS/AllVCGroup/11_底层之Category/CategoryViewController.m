//
//  CategoryViewController.m
//  LearniOS
//
//  Created by 张帆 on 2020/3/9.
//  Copyright © 2020年 JKFunny. All rights reserved.
//

#import "CategoryViewController.h"
#import "PersonCategory.h"
#import "PersonCategory+Test1.h"
#import "StudentCategory.h"
#import <objc/runtime.h>

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"底层之Category";
    [self categoryBase];
    
    [self categoryAssociate];
}

- (void)categoryBase {
    /*
     1、所有分类底层都是如下类型的结构体变量：
     	struct _category_t {
     		const char *name;		// 类名
     		struct _class_t *cls;
     		const struct _method_list_t *instance_methods;	// 分类中的对象方法
     		const struct _method_list_t *class_methods;		// 分类中的类方法
     		const struct _protocol_list_t *protocols;		// 分类中的协议
     		const struct _prop_list_t *properties;			// 分类中的属性列表
     	}
     	在编译期，所有分类都转化为这种类型。在运行时，才会将分类中的信息合并到对应的类（类对象、元类对象）中。
     	合并规则是：分类中的方法会合并到类中原有方法的前面，并且最后参与编译的分类在最前面。
     	所以当分类中有和原类同名的方法，会调用分类中的方法。
     2、Category和Class Extension的区别是什么？
     	Class Extension在编译的时候，它的数据就已经包含在类信息中；
     	Category是在运行时，才会将数据合并到类信息中。
     3、+load方法会在runtime加载类、分类时调用，在main函数运行之前。不管该类、分类是否有用到。
     	每个类、分类的+load，在程序运行过程中只调用一次（系统只调用一次，当然也可以手动多次调用，但不会这么使用。）
     	每个分类中的+load方法，也会最终合并到元类的类方法列表中，因此元类的类方法列表中可能存在多个+load方法。
     	需要注意，系统对+load方法的调用，不是通过objc_msgSend()来执行的，而是直接找到方法地址，然后调用。
     4、+load方法的调用顺序
     	1 先调用类的+load
     		按照编译先后顺序调用，先编译的先调用
     		调用子类的+load之前会先调用父类的+load
     	2 再调用分类的+load
     		同样按照编译先后顺序调用，先编译的先调用
     5、+initialize方法会在类第一次接受消息时调用。该方法走的时消息机制objc_msgSend。
     	每个分类中的+initialize方法，也会最终合并到元类的类方法列表中，
     	因此元类的类方法列表中可能存在多个+initialize方法。
     6、+initialize的调用顺序:
     	1、如果父类没有初始化过，先调用父类的+initialize，再调用子类的+initialize
     	2、如果父类已经初始化过，会直接调用自己的+initialize
     	3、因为+initialize是通过objc_msgSend进行调用的，所以有一下特点
     		. 如果子类没有实现+initialize，会调用父类的+initialize，
              因此父类的+initialize可能被多次调用
     		. 如果分类实现了+initialize，就覆盖类本身的+initialize调用
     7、分类中可以添加属性，但是默认只会产生对应属性的get\set方法声明，并没有产生成员变量，
     	以及get/set方法的实现。另外，分类中不能直接添加成员变量。
     8、分类中添加成员变量的方法：
     	存：objc_setAssociatedObject		取：objc_getAssociatedObject
     	需要注意，分类中添加的成员变量，跟类原有的成员变量存储方式不一样。类原有的成员变量列表
     	是只读的，不能在运行添加或删除。
     9、关联对象的原理：
     	关联的对象不是放到原来的类信息中，而是放到一个全局的AssociationsHashMap中，由AssociationsManager管理。
     
     	objc_setAssociatedObject(self, kAvatarKey, avatar, OBJC_ASSOCIATION_COPY_NONATOMIC);
     
     	AssociationsManager包含了AssociationsHashMap
     		-> AssociationsHashMap包含了 key(self): AssociationsMap
                -> AssociationsMap包含 key(kAvatarKey): ObjectAssociation
                	-> ObjectAssociation包含关联的值和关联策略
     
     	如果objc_setAssociatedObject关联的值传nil，则会擦除该关联对象。
     	可以通过objc_removeAssociatedObjects(id object)移除指定对象的所有关联对象
     */
    
    // 先调用父类PersonCategory的+initialize，再调用自己的+initialize
    StudentCategory *student1 = [[StudentCategory alloc] init];
    [student1 test];
    
    
    // PersonCategory的+initialize已经调用过，这里不会再调用
    PersonCategory *person = [[PersonCategory alloc] init];
    // Test2分类最后参与编译，因此会执行Test2分类中的方法：-[PersonCategory(Test2) test]
    [person test];

    // 分类的+load/initialize方法也会合并到类的元类中，
    // 因此可以看到元类的类方法列表中，有多个+load/initialize方法
    // 打印结果 load, initialize, load, initialize, load, initialize,
    [self printMethodNamesOfClass:object_getClass([person class])];
    

    // PersonCategory和StudentCategory的+initialize都调用过，这里不会再调用
    StudentCategory *student2 = [[StudentCategory alloc] init];
    [student2 test];
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

// 分类关联对象
- (void)categoryAssociate {
    PersonCategory *person = [[PersonCategory alloc] init];
    person.age = 10;
    person.name = @"zf";
    person.nickName = @"zzz";
    person.avatar = @"www";
    person.school = @"bjbjbj";
    NSLog(@"age = %d, name = %@, nickName = %@, avatar = %@, school = %@", person.age, person.name, person.nickName, person.avatar, person.school);
}

@end
