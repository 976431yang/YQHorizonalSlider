//
//  ViewController.m
//  YQNumberSlideView_DEMO
//
//  Created by problemchild on 2017/5/13.
//  Copyright © 2017年 freakyyang. All rights reserved.
//

#import "ViewController.h"

#import "YQHorizonalSlider.h"

@interface ViewController ()<YQHorizonalSliderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lab;

@property(nonatomic,strong) YQHorizonalSlider *slideView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.slideView = [[YQHorizonalSlider alloc]initWithFrame:CGRectMake(30, 80,
                                                                        [UIScreen mainScreen].bounds.size.width-60,
                                                                        50)];
    //设置一个背景色，以便查看范围
    self.slideView.backgroundColor = [UIColor colorWithWhite:0.931 alpha:1.000];
    
    [self.slideView setLabelCount:20];
    //监控代理
    self.slideView.delegate = self;
    [self.view addSubview:self.slideView];
    
    
    /*以下为自定义显示的方法
     //设置数量
     [self.slideView setLabelCount:8];
     [self.slideView setShowArray:@[
     @"小明",
     @"小红",
     @"小方",
     @"小亮",
     @"小华",
     @"小坏",
     @"小丑",
     @"小帅",
     ]];
     //设置一下宽度
     self.slideView.labelWidth = 40;
     //显示
     [self.slideView show];
     */
    
    /*
     //彩色模式
     [self.slideView diffrentColorModeWithMainColorR:0.154 G:1.000 B:0.063
                                           secColorR:0.281 G:0.772 B:0.970];
     
     [self.slideView setLabelCount:20];
     //监控代理
     self.slideView.delegate = self;
     [self.slideView show];
     */
}

- (IBAction)GoLeft:(id)sender {
    [self.slideView pre];
}
- (IBAction)goRight:(id)sender {
    [self.slideView next];
}

- (void)horizonalSliderDidChangeIndex:(int)count
{
    self.lab.text = [NSString stringWithFormat:@"当前页：%d",count+1];
}

- (void)horizonalSliderDidTouchIndex:(int)count
{
    [self.slideView scrollTo:count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
