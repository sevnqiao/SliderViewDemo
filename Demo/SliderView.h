//
//  SliderView.h
//  SliderView
//
//  Created by xiong on 16/9/23.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

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
 *  @brief 偏移量
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

@end


@interface SliderItemView : UILabel

/*!
 *  @brief 进度条
 */
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIColor *fillColor;
@end
