//
//  YQNumberSlideView.m
//  YQNumberSlideView_DEMO
//
//  Created by problemchild on 2017/5/13.
//  Copyright © 2017年 freakyyang. All rights reserved.
//

#define kViewWidth(v)            v.frame.size.width
#define kViewHeight(v)           v.frame.size.height
#define kViewX(v)                v.frame.origin.x
#define kViewY(v)                v.frame.origin.y
#define kViewMaxX(v)             (v.frame.origin.x + v.frame.size.width)
#define kViewMaxY(v)             (v.frame.origin.y + v.frame.size.height)

#import "YQHorizonalSlider.h"

@interface YQHorizonalSlider ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView   *SCRV;
@property (nonatomic,strong) NSMutableArray *slideLabArr;
@property (nonatomic,strong) NSMutableArray *showArr;
@property int allcount;
@property int lastCount;

@property BOOL  colorMode;
@property float colorModeR;
@property float colorModeG;
@property float colorModeB;
@property float colorModeSR;
@property float colorModeSG;
@property float colorModeSB;

@end

@implementation YQHorizonalSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    //--------------------------------------------------默认参数
    _labelWidth      = 33;
    _labelMid        = 20;
    _maxHeight       = 25;
    _minHeight       = 15;
    _secLevelAlpha   = 0.6;
    _thirdLevelAlpha = 0.2;
    _labColor        = [UIColor blackColor];
    
    //--------------------------------------------------相关View初始化
    
    self.SCRV = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.SCRV.showsHorizontalScrollIndicator = NO;
    self.SCRV.delegate = self;
    [self addSubview:self.SCRV];
    
    self.clipsToBounds = YES;
    self.lastCount     = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(didTap:)];
    [self addGestureRecognizer:tap];
    return self;
}

- (void)reload {
    if (self.slideLabArr.count>0) {
        for (UILabel *lab in self.slideLabArr) {
            [lab removeFromSuperview];
        }
        [self.slideLabArr removeAllObjects];
    }
    if (!self.slideLabArr) {
        self.slideLabArr = [NSMutableArray array];
    }
    
    double scrvX = (kViewWidth(self) - self.labelWidth - 2 * self.labelMid) / 2;
    double scrvY = (kViewHeight(self) - self.maxHeight) / 2;
    self.SCRV.frame = CGRectMake(scrvX, scrvY,
                                 self.labelWidth + self.labelMid,
                                 self.maxHeight);
    
    if (self.allcount > 0) {
        for (int i = 0; i < self.allcount; i++) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
            if (i==0) {
                lab.frame = CGRectMake(self.labelMid, 0,
                                       self.labelWidth, self.maxHeight);
                lab.font = [UIFont systemFontOfSize:self.maxHeight];
            } else {
                UILabel *lastLab = self.slideLabArr[i-1];
                lab.frame = CGRectMake(kViewMaxX(lastLab) + self.labelMid,
                                       self.maxHeight - self.minHeight,
                                       self.labelWidth, self.minHeight);
                lab.font = [UIFont systemFontOfSize:self.minHeight];
            }
            if (i == 0) {
                lab.alpha = 1;
            } else if (i == 1) {
                lab.alpha = self.secLevelAlpha;
            } else {
                lab.alpha = self.thirdLevelAlpha;
            }
            
            lab.adjustsFontSizeToFitWidth = YES;
            if (self.showArr.count > 0) {
                lab.text = (NSString *)self.showArr[i];
            }else{
                lab.text = [NSString stringWithFormat:@"%d", i + 1];
            }
            
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor     = self.labColor;
            if (self.colorMode && i == 0) {
                lab.textColor = [UIColor colorWithRed:self.colorModeR
                                                green:self.colorModeG
                                                 blue:self.colorModeB
                                                alpha:1];
            } else if (self.colorMode) {
                lab.textColor = [UIColor colorWithRed:self.colorModeSR
                                                green:self.colorModeSG
                                                 blue:self.colorModeSB
                                                alpha:1];
            }
            
            [self.SCRV addSubview:lab];
            [self.slideLabArr addObject:lab];
        }
        
        UILabel *lastLab = self.slideLabArr[self.slideLabArr.count - 1];
        self.SCRV.contentSize = CGSizeMake(kViewMaxX(lastLab) + self.labelMid,
                                           0);
        self.SCRV.pagingEnabled = YES;
        self.SCRV.clipsToBounds = NO;
    }
}

- (void)showNumbersWithCount:(int)count {
    self.allcount = count;
    self.showArr = nil;
    [self reload];
}

- (void)showTitlesWithArray:(NSArray <NSString * > *)arr {
    self.showArr = [NSMutableArray arrayWithArray:arr];
    self.allcount = (int)arr.count;
    [self reload];
}

- (void)didTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.SCRV];
    CGFloat labDiff = point.x - (self.labelMid / 2);
    int index = labDiff / (self.labelMid + self.labelWidth);
    [self.delegate horizonalSliderDidTouchIndex:index];
}

- (void)scrollTo:(int)index {
    if (index >= self.allcount) { return; }
    [self.SCRV setContentOffset:CGPointMake(index *
                                            (self.labelMid + self.labelWidth),
                                            0)
                       animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.x;
    int     count  = (offset) / (self.labelMid + self.labelWidth);
    
    UILabel *lastLab = self.slideLabArr[self.slideLabArr.count - 1];
    if (offset <= kViewMaxX(lastLab) + 1) {
        if (self.lastCount != count) {
            [self.delegate horizonalSliderDidChangeIndex:count];
            self.lastCount = count;
        }
        
        CGFloat countOffset = offset -
                              count * (self.labelMid + self.labelWidth);
        CGFloat offsetRait  = 1;
        if (countOffset != 0) {
            offsetRait = 1-countOffset / (self.labelWidth + self.labelMid);
        }
        
        UILabel *showingLab = nil;
        if (count >= 0 && count < self.slideLabArr.count - 1) {
            showingLab = self.slideLabArr[count];
        }
        
        if (showingLab) {
            showingLab.frame = CGRectMake(kViewX(showingLab),
                                          (self.maxHeight - self.minHeight) *
                                          (1 - offsetRait),
                                          kViewWidth(showingLab),
                                          self.minHeight +
                                          (self.maxHeight - self.minHeight) *
                                          offsetRait);
            showingLab.font = [UIFont systemFontOfSize:kViewHeight(showingLab)];
            showingLab.alpha = 1 - (1 - self.secLevelAlpha) * (1 - offsetRait);
            
            if (self.colorMode) {
                float colorRait = (showingLab.alpha - self.secLevelAlpha) /
                                  (1 - self.secLevelAlpha);
                showingLab.textColor = [self getColorWithRait:colorRait];
            }
        }
        
        if (count < self.slideLabArr.count-1) {
            UILabel *nextLab = self.slideLabArr[count+1];
            if (nextLab) {
                nextLab.frame = CGRectMake(kViewX(nextLab),
                                           (self.maxHeight - self.minHeight) *
                                           offsetRait,
                                           kViewWidth(nextLab),
                                           self.minHeight +
                                           (self.maxHeight - self.minHeight) *
                                           (1 - offsetRait));
                nextLab.font = [UIFont systemFontOfSize:kViewHeight(nextLab)];
                nextLab.alpha = self.secLevelAlpha +
                                (1 - self.secLevelAlpha) * (1 - offsetRait);
                
                if (self.colorMode) {
                    float colorRait = (nextLab.alpha - self.secLevelAlpha) /
                                      (1 - self.secLevelAlpha);
                    nextLab.textColor = [self getColorWithRait:colorRait];
                }
            }
        }
        if (count > 0) {
            UILabel *lastLab = self.slideLabArr[count-1];
            lastLab.frame = CGRectMake(kViewX(lastLab),
                                       (self.maxHeight - self.minHeight),
                                       kViewWidth(lastLab),
                                       self.minHeight);
            lastLab.font = [UIFont systemFontOfSize:kViewHeight(lastLab)];
            lastLab.alpha = self.thirdLevelAlpha +
                            (self.secLevelAlpha - self.thirdLevelAlpha) *
                            offsetRait;
        }
        
        if (count<self.slideLabArr.count-2) {
            UILabel *next2Lab = self.slideLabArr[count+2];
            next2Lab.frame = CGRectMake(kViewX(next2Lab),
                                        (self.maxHeight - self.minHeight),
                                        kViewWidth(next2Lab),
                                        self.minHeight);
            next2Lab.font = [UIFont systemFontOfSize:kViewHeight(next2Lab)];
            next2Lab.alpha = self.thirdLevelAlpha +
                            (self.secLevelAlpha - self.thirdLevelAlpha) *
                            (1 - offsetRait);
        }
        for (int i=0; i < self.slideLabArr.count; i++) {
            if ((i != count) && (i != count + 1) &&
                (i != count - 1) && (i != count + 2)) {
                UILabel *lab = self.slideLabArr[i];
                lab.frame = CGRectMake(kViewX(lab),
                                       (self.maxHeight - self.minHeight),
                                       kViewWidth(lab),
                                       self.minHeight);
                lab.font = [UIFont systemFontOfSize:kViewHeight(lab)];
                lab.alpha = self.thirdLevelAlpha;
            }
        }

    }
}

- (UIColor *)getColorWithRait:(double)rait {
    float R = self.colorModeSR + (self.colorModeR - self.colorModeSR) * rait;
    float G = self.colorModeSG + (self.colorModeG - self.colorModeSG) * rait;
    float B = self.colorModeSB + (self.colorModeB - self.colorModeSB) * rait;
    UIColor *color = [UIColor colorWithRed:R green:G blue:B alpha:1];
    return color;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]) {
        for (UIView *subview in self.SCRV.subviews) {
            CGPoint offset = CGPointMake(point.x - self.SCRV.frame.origin.x +
                                         self.SCRV.contentOffset.x -
                                         subview.frame.origin.x,
                                         
                                         point.y - self.SCRV.frame.origin.y +
                                         self.SCRV.contentOffset.y -
                                         subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event])) {
                return view;
            }
        }
        return self.SCRV;
    }
    return view;
}

- (void)next {
    if (self.lastCount <self.slideLabArr.count-1) {
        [self.SCRV setContentOffset:CGPointMake(self.SCRV.contentOffset.x+
                                                self.labelWidth + self.labelMid,
                                                self.SCRV.contentOffset.y)
                           animated:YES];
    }
}

- (void)pre {
    if (self.lastCount > 0) {
        [self.SCRV setContentOffset:CGPointMake(self.SCRV.contentOffset.x-
                                                self.labelWidth-self.labelMid,
                                                self.SCRV.contentOffset.y)
                           animated:YES];
    }
}

- (void)diffrentColorModeWithMainColorR:(float)mr G:(float)mg B:(float)mb
                             secColorR:(float)sr G:(float)sg B:(float)sb {
    self.colorMode = YES;
    self.colorModeR = mr;
    self.colorModeG = mg;
    self.colorModeB = mb;
    self.colorModeSR = sr;
    self.colorModeSG = sg;
    self.colorModeSB = sb;
    
}
@end
