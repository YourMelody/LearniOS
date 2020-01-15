//
//  DrawView.h
//  LearniOS
//
//  Created by JKFunny on 2020/1/14.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DrawType) {
    DrawType_Line,      // 画直线、折线、曲线
    DrawType_Rect,      // 画矩形、圆角矩形
    DrawType_Round,     // 画圆、椭圆
    DrawType_Arc,       // 画圆、椭圆
    DrawType_Progress,  // 画进度
    DrawType_Pie,       // 画饼状图
    DrawType_Text,      // 画文字
    DrawType_Image,     // 画图片
    DrawType_Snow,      // 下雪
    DrawType_Table,     // 上下文栈相关
    DrawType_Translate, // 上下文的矩阵操作
};

@interface DrawView : UIView

@property (nonatomic, assign)DrawType drawType;
@property (nonatomic, assign)CGFloat myProgress;

@end

NS_ASSUME_NONNULL_END
