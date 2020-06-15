//
//  Person+Student.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/19.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "Person+Student.h"
#import <objc/runtime.h>

/*
分类Category：
   1、分类常用使用场景：
       1.1、声明私有方法
       1.2、分解体积庞大的类文件
       1.3、把Framework的私有方法公开
   2、分类的特点：
       2.1 运行时决议
       2.2 可以为系统类添加分类
   3、分类中可以添加哪些内容：
       3.1 实例方法
       3.2 类方法
       3.3 协议
       3.4 属性，只添加了对应的get/set方法的声明，并没有get/set方法的实现，也不会添加实例变量
       3.5 通过关联对象添加实例对象
   4、分类添加的方法可以‘覆盖’原类方法：
           效果上是覆盖，原类同名方法仍然存在，只是调用顺序决定调用了分类的方法
      同名类方法谁能生效取决于编译顺序，最后编译的分类方法会生效。
      名字相同的分类会引起编译报错
      即：多个分类有同名方法，最后参与编译的分类中方法会生效；分类中有和原类同名的方法，执行分类的。
 
 
 分类结构体
 struct category_t {
     const char *name;   // 分类名称
     classref_t cls;     // 分类所属的宿主类
     struct method_list_t *instanceMethods;  // 实例方法列表
     struct method_list_t *classMethods;     // 类方法列表
     struct protocol_list_t *protocols;      // 协议列表
     struct property_list_t *instanceProperties; // 实例属性列表
     
     method_list_t *methodsForMeta(bool isMeta) {
         if (isMeta) return classMethods;
         else return instanceMethods;
     }
     
     property_list_t *propertiesForMeta(bool isMeta) {
         if (isMeta) return nil; // classProperties;
         else return instanceProperties;
     }
 }
*/

@implementation Person (Student)

/*
 通过关联对象为分类添加实例变量
    关联对象由AssociationManager管理并在AssociationsHashMap存储。
    所有对象的关联内容都在同一个全局容器中。
 */
- (void)setHeight:(CGFloat)height {
    objc_setAssociatedObject(self, @"height", @(height), OBJC_ASSOCIATION_ASSIGN);
    
}
- (CGFloat)height {
    return [objc_getAssociatedObject(self, @"height") floatValue];
}

@end
