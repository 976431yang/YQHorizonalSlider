# YQHorizonalSlider
横向滚动的选择器，灵活自定义

#### 微博：畸形滴小男孩

### 效果：

![image](https://github.com/976431yang/YQHorizonalSlider/blob/master/YQNumberSlideView_DEMO/screenShot/2017-05-13-15_05_53.gif) </br>
![image](https://github.com/976431yang/YQHorizonalSlider/blob/master/YQNumberSlideView_DEMO/screenShot/2017-05-13-15_10_45.gif)

### 使用方法：
##### 直接拖到工程中
##### 引入
```objective-c
#import "YQHorizonalSlider.h"
```

##### 最简单的使用方法
```objective-c
    //初始化
    YQHorizonalSlider *slideView = [[YQNumberSlideView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    //设置数量
    [slideView setLableCount:20];
    //添加到View上显示
    [self.view addSubview:slideView];

    //(可选)加个背景色，方便自己看范围
    slideView.backgroundColor = [UIColor colorWithWhite:0.931 alpha:1.000];
```
###### 完事了，已经可以显示了。

##### 监控选择结果
```objective-c
    //设代理
    slideView.delegate = self;

 //遵循代理
 -(void)horizonalSliderDidChangeIndex:(int)count
{
    //count即是选择的序号
}
```

##### 自定义显示内容（想上面的图片中显示的“小红”“小明”等）
```objective-c
	[slideView setLableCount:8];
	[slideView setShowArray:@[@"小明",@"小红",@"小方",@"小亮",@"小华",@"小坏",@"小丑",@"小帅",]];

    //注意LableCount要和ShowArray的个数保持一致
```
##### 更多自定义显示样式
```objective-c
	//每个显示的Lable的宽度,默认33,(宽度不够会导致字体变小)
	slideView.lableWidth;
    
	//每个显示的Lable的间隔，默认20
	slideView.lableMid;
    
	//选中的Lable的高度,默认25
	slideView.maxHeight;
    
	//未选中的Lable的高度，默认15
	slideView.minHeight;
    
	//lbale的颜色，默认黑色
	slideView.LabColor;
    
	//二级Lable透明度，默认0.6
	slideView.secLevelAlpha;
    
	//三级Lable透明度，默认0.2
	slideView.thirdLevelAlpha;

	//!!!!!!调用完  要调一下 刷新显示，才能生效!!!!!!
	[slideView show];
```
    
##### 焦点变色模式
```objective-c
	[slideView DiffrentColorModeWithMainColorR:0.154 G:1.000 B:0.063 
                                     SecColorR:0.281 G:0.772 B:0.970];

	//!!!!!!调用完  要调一下 刷新显示，才能生效!!!!!!
	[slideView show];
```

