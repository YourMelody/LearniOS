//
//  XNYouHuaVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/3/17.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "XNYouHuaVC.h"

@interface XNYouHuaVC ()

@end

@implementation XNYouHuaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"底层之性能优化";
    
    /*
     1、在屏幕成像的过程中，CPU和GPU起着至关重要的作用：
        CPU（中央处理器）：对象的创建和销毁、对象属性的调整、布局计算、文本的计算和排版、图片的格式转换和解码、图像的绘制
        GPU（图形处理器）：纹理的渲染
        CPU计算 -> GPU渲染 -> 帧缓存 -> 视频控制器读取 -> 屏幕显示
     
     2、卡顿产生的原因：
        按照60FPS的刷新频率，每16ms就有一次VSync（垂直同步）信号。
        CPU：尽量使用轻量级的对象，比如用不到事件处理的地方，可以考虑使用CALayer取代UIView
            不要频繁调用UIView的相关属性，比如frame、bounds、transform等
            尽量提前计算好布局，在有需要时一次性调整对应的属性，不要多次修改属性
            Autolayout会比直接设置frame消耗更多的CPU资源
            图片的size最好刚好跟UIImageView的size保持一致
            控制线程的最大并发数
            尽量把耗时操作放到子线程
                . 文字处理（尺寸计算、绘制）
                . 图片处理（编码、解码等）
        GPU：尽量减少视图数量和层次
            尽量避免段时间内大量图片的现实，尽可能将多张图片合成一张进行现实
            GPU能处理的最大纹理尺寸是4096x4096，一旦超过这个尺寸，就会占用CPU资源进行处理，所以图片纹理最好不要超过这个
            减少透明的视图（alpha < 1）,不透明的就设置opaque为YES
            尽量避免出现离屏渲染
        卡顿检测：
            添加Observer到主线程RunLoop中，监听RunLoop状态切换的耗时，达到监控卡顿的目的
     
     3、On-Screen Rendering：当前屏幕渲染，在当前用于现实的屏幕缓冲区进行渲染
        Off-Screen Rendering：离屏渲染，在当前屏幕缓冲区外新开辟一个缓冲区进行渲染
        离屏渲染消耗性能的原因：
            . 需要创建新的缓冲区
            . 离屏渲染的整个过程，需要多次切换上下文环境，先试从当前屏幕切换到离屏；等到离屏渲染结束后，将
        离屏缓冲区的渲染结果显示到屏幕上，又需要将上下文环境从离屏切换到当前屏幕
     
     4、哪些操作会产生离屏渲染？
        光栅化，layer.shouldRasterize = YES;
        遮罩，layer.mask
        圆角，同时设置layer.masksToBounds = YES; layer.cornerRadius大于0
        阴影效果 layer.shadowXXX(设置了shadowPath就不会产生离屏渲染)
        
     */
    
    
    // 设计模式和架构相关
    /*
     1、架构（Architecture）：软件开发中的设计方案、类与类之间/模块与模块/客户端与服务端的关系
        MVC、MVP、MVVM、三层架构、四层架构
     
     2、MVC-Apple版(Mode和View之间互相不知道对方存在)
        Model <==> Controller <==> View
        优点：View、Model可以重复利用； 缺点：Controller代码过于臃肿
     
     3、MVC变种：在官方MVC基础上，view知道model的存在
        优点：对Controller进行瘦身，将View内部的细节封装起来，外界不知道View内部的具体实现
        缺点：View依赖于Model
     
     4、MVP：
        Model <==> Presenter <==> View
     
     5、MVVM：
        Model <==> ViewModel <==> View
     */
}

@end
