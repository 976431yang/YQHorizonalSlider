//
//  YQNumberSlideView.h
//  YQNumberSlideView_DEMO
//
//  Created by problemchild on 2017/5/13.
//  Copyright © 2017年 freakyyang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YQHorizonalSliderDelegate <NSObject>

- (void)horizonalSliderDidChangeIndex:(int)count;

- (void)horizonalSliderDidTouchIndex:(int)count;

@end


@interface YQHorizonalSlider :UIView

#pragma mark -----------------------Function

/**
 *  刷新显示-如果有自定义样式，需要调用此方法
 */
- (void)reload;

/**
 *  展示数字
 *
 *  @param count 数量
 */
- (void)showNumbersWithCount:(int)count;

/**
 *  展示自定义文字
 *
 *  @param arr 文字内容
 */
- (void)showTitlesWithArray:(NSArray <NSString * > *)arr;

/**
 *  手动跳转到下一个
 */
- (void)next;

/**
 *  手动跳转到前一个
 */
- (void)pre;

/**
 *  手动跳转
 */
- (void)scrollTo:(int)index;


#pragma mark -----------------------Property
/**
 *  代理
 */
@property(nonatomic,weak) id <YQHorizonalSliderDelegate> delegate;

/// 每个显示的Label的宽度,默认33,(宽度不够会导致字体变小)
@property (nonatomic, assign) CGFloat labelWidth;

/// 每个显示的Label的间隔，默认20
@property (nonatomic, assign) CGFloat labelMid;

/// 选中的Label的高度,默认25
@property (nonatomic, assign) CGFloat maxHeight;

/// 未选中的Label的高度，默认15
@property (nonatomic, assign) CGFloat minHeight;

/// lbabel的颜色，默认黑色
@property (nonatomic,strong) UIColor *labColor;

/// 二级Label透明度，默认0.6
@property (nonatomic, assign) CGFloat secLevelAlpha;

/// 三级Label透明度，默认0.2
@property (nonatomic, assign) CGFloat thirdLevelAlpha;

/**
 *  焦点变色模式（beta）
 *
 *  @param mr 焦点红 0~1
 *  @param mg 焦点绿 0~1
 *  @param mb 焦点蓝 0~1
 *  @param sr 非焦点红 0~1
 *  @param sg 非焦点绿 0~1
 *  @param sb 非焦点蓝 0~1
 */
- (void)diffrentColorModeWithMainColorR:(float)mr G:(float)mg B:(float)mb
                              secColorR:(float)sr G:(float)sg B:(float)sb;


@end
