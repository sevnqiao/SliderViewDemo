//
//  SliderView.h
//  SliderView
//
//  Created by xiong on 16/9/23.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SliderViewAlignment)
{
    SliderViewAlignmentDefault = 1,
    SliderViewAlignmentJustified = 2,
    SliderViewAlignmentLeft = SliderViewAlignmentDefault
};

@class SliderView;

@protocol SliderViewDelegate <NSObject>

@optional

/*!
 *  @brief 点击了相应的模块
 *
 *  @param sliderView SliderView
 *  @param index      模块的 index
 */
- (void)sliderView:(SliderView *)sliderView slideAtIndex:(NSInteger)index;

@end

@interface SliderView : UIView


/*!
 *  @brief 代理
 */
@property (nonatomic, assign) id<SliderViewDelegate> delegate;

/*!
 *  @brief 数据源
 */
@property (nonatomic, strong) NSArray *itemArray;

/*!
 *  @brief item 间距 （default = 30）
 */
@property (nonatomic, assign) CGFloat itemSpace;

/*!
 *  @brief 偏移量 (default 传入对应的 scrollview 的 contentOffset/width)
 */
@property (nonatomic, assign) CGFloat indexOffset;

/*!
 *  @brief 默认颜色 (default = grayColor)
 */
@property (nonatomic, strong) UIColor *normalColor;

/*!
 *  @brief 选中颜色 (default = redColor)
 */
@property (nonatomic, strong) UIColor *selectColor;

/*!
 *  @brief 底部线条颜色 (default = redColor)
 */
@property (nonatomic, strong) UIColor *bottomColor;

/**
 *  @brief 底部指示 view 和 title 之间的间隙 (default = 3)
 */
@property (nonatomic, assign) CGFloat bottomViewTopConstraint;


/**
 *  @brief 标题字体 （default = pingfang SC 13）
 */
@property (nonatomic, strong) UIFont *titleFont;


/**
 *  @brief 对齐方式， （default = SliderViewAlignmentLeft）
 */
@property (nonatomic, assign) SliderViewAlignment sliderAlignment;

@end


@interface SliderItemView : UILabel

/*!
 *  @brief 进度条
 */
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIColor *fillColor;
@end
