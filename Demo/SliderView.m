//
//  SliderView.m
//  SliderView
//
//  Created by xiong on 16/9/23.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "SliderView.h"
#import "NSString+Utility.h"

@interface SliderView()

@property (nonatomic, strong) NSMutableArray *sliderItemViewArray;

@property (nonatomic, strong) UIView *sliderBottomView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SliderView

#pragma mark - setter / getter

- (void)setNormalColor:(UIColor *)normalColor{
    
    _normalColor = normalColor;
    
    [self setNeedsDisplay];
}

- (void)setSelectColor:(UIColor *)selectColor{
    
    _selectColor = selectColor;
    
    [self setNeedsDisplay];
}

- (void)setBottomColor:(UIColor *)bottomColor {
    
    _bottomColor = bottomColor;
    
    [self setNeedsDisplay];
}

- (void)setItemSpace:(CGFloat)itemSpace {
    
    _itemSpace = itemSpace;
    
    [self setNeedsDisplay];
}

- (void)setItemArray:(NSArray *)itemArray {
    
    _itemArray = itemArray;
    
    if (self.indexOffset >= itemArray.count)
    {
        self.indexOffset = itemArray.count-1;
    }
    
     [self createSliderItemView];
}

- (void)setTitleFont:(UIFont *)titleFont {
    
    _titleFont = titleFont;
    
    [self setNeedsDisplay];
}

- (void)setSliderAlignment:(SliderViewAlignment)sliderAlignment {
    
    _sliderAlignment = sliderAlignment;
    
    [self setNeedsDisplay];
}

- (void)setBottomViewTopConstraint:(CGFloat)bottomViewTopConstraint {
    
    _bottomViewTopConstraint = bottomViewTopConstraint;
    
    [self setNeedsDisplay];;
}

// 设置偏移量
- (void)setIndexOffset:(CGFloat)indexOffset {
    _indexOffset = indexOffset;
    
    // 当前索引
    NSInteger index = indexOffset-CGFLOAT_MIN;
    
    SliderItemView *leftItem = (SliderItemView *)[self.sliderItemViewArray objectAtIndex:index ];
    
    SliderItemView *rightItem ;
    if (index < self.itemArray.count-1) {
        rightItem = (SliderItemView *)[self.sliderItemViewArray objectAtIndex:index + 1];
    }
    
    // 相对于当前屏幕的宽度
    CGFloat rightPageLeftDelta = indexOffset - index;
    CGFloat progress = rightPageLeftDelta;
    
    if ([leftItem isKindOfClass:[SliderItemView class]]) {
        leftItem.textColor = _selectColor;
        leftItem.fillColor = _normalColor;
        leftItem.progress = progress;
    }
    if ([rightItem isKindOfClass:[SliderItemView class]]) {
        rightItem.textColor = _normalColor;
        rightItem.fillColor = _selectColor;
        rightItem.progress = progress;
    }
    
    for (SliderItemView *itemView in self.sliderItemViewArray) {
        if (itemView.tag!= index && itemView.tag != index + 1) {
            itemView.textColor = _normalColor;
            itemView.fillColor = _selectColor;
            itemView.progress = 0;
        }
    }

    [self slideToIndexOffset:indexOffset];
}

#pragma mark - initView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.itemSpace = 30;
        self.indexOffset = 0.0;
        self.bottomViewTopConstraint = 3;
        self.titleFont = [UIFont systemFontOfSize:13];
        self.sliderAlignment = SliderViewAlignmentDefault;
        self.normalColor = [UIColor grayColor];
        self.selectColor = [UIColor redColor];
        self.bottomColor = [UIColor redColor];
        self.sliderItemViewArray = [NSMutableArray arrayWithCapacity:self.itemArray.count];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
    }
    return self;
}

- (void)createSliderItemView {
    
    for (int i = 0; i < self.itemArray.count; i++) {
        
        SliderItemView *itemView = [[SliderItemView alloc]init];
        itemView.textAlignment = NSTextAlignmentCenter;
        itemView.textColor = _normalColor;
        itemView.fillColor = _selectColor;
        itemView.text = [self.itemArray objectAtIndex:i];
        itemView.userInteractionEnabled = YES;
        if (i == self.indexOffset) {
            itemView.progress = 1;
            itemView.font = self.titleFont;
        }else{
            itemView.progress = 0;
            itemView.font = self.titleFont;
        }
        itemView.tag = i;
        CGFloat width = 0;
        if (self.sliderAlignment == SliderViewAlignmentLeft)
        {
            width = [itemView.text getStringWidth:self.titleFont Height:20]+self.itemSpace;
        }
        else
        {
            width = self.frame.size.width / self.itemArray.count;
        }
        
        CGFloat height = [itemView.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size.height;
        CGFloat x = 0;
        x = i>0 ? CGRectGetMaxX(((SliderItemView *)self.sliderItemViewArray[i-1]).frame):0;
        CGFloat y = (self.frame.size.height - height) / 2 - 3;
        itemView.frame = CGRectMake(x, y, width, height);
        
        [self.scrollView addSubview:itemView];
        
        [_sliderItemViewArray addObject:itemView];
        
        
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(x, 0, width, self.frame.size.height)];
        control.tag = i;
        [control addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:control];
    }
    
    SliderItemView *itemView = (SliderItemView *)[self.sliderItemViewArray objectAtIndex:self.indexOffset];
    self.sliderBottomView = [[UIView alloc]initWithFrame:CGRectMake(itemView.center.x-([itemView.text getStringWidth:self.titleFont Height:20])/2,
                                                                CGRectGetMaxY(itemView.frame) + self.bottomViewTopConstraint,
                                                                [itemView.text getStringWidth:self.titleFont Height:20],
                                                                5)];
    self.sliderBottomView.layer.cornerRadius = 2.5;
    self.sliderBottomView.layer.masksToBounds = YES;
    self.sliderBottomView.backgroundColor = self.bottomColor;
    [self.scrollView addSubview:self.sliderBottomView];
    
    CGFloat maxX = CGRectGetMaxX(((SliderItemView*)self.sliderItemViewArray.lastObject).frame);
    if (maxX < self.frame.size.width) {
        maxX = self.frame.size.width;
    }
    self.scrollView.contentSize = CGSizeMake(maxX, self.frame.size.height);
}

#pragma mark - tap

- (void)tap:(UIControl *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indexOffset = tap.tag;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:slideAtIndex:)]) {
        
        [self.delegate sliderView:self slideAtIndex:(tap.tag)];
    }
}

#pragma mark - setBottomView

- (void)slideToIndexOffset:(CGFloat)indexOffset {
    
    NSInteger index = _indexOffset-CGFLOAT_MIN;
    
    CGFloat progress = indexOffset - index;
    
    SliderItemView *currentItemView = (SliderItemView *)[self.sliderItemViewArray objectAtIndex:index];
    SliderItemView *nextItemView = nil;

    if (progress == 0) {
        // 纠正偏移量的误差
        _sliderBottomView.frame = CGRectMake(currentItemView.center.x-([currentItemView.text getStringWidth:self.titleFont Height:20])/2,
                                                                    CGRectGetMaxY(currentItemView.frame)+self.bottomViewTopConstraint,
                                                                    [currentItemView.text getStringWidth:self.titleFont Height:20],
                                                                    5);
        [self scrollSelectViewToMiddleWithSelectItem:currentItemView];
        return;
    }
    
    if (index < self.itemArray.count-1) {
        nextItemView = (SliderItemView *)[self.sliderItemViewArray objectAtIndex:index + 1];
    }
    
    CGFloat x = 0;
    CGFloat w = 0;
    
    if ((index == 0 && progress < 0 ) || (index == self.itemArray.count-1 && progress > 0)) { // 当选中的是第一个时
        x = CGRectGetMinX(currentItemView.frame) + self.itemSpace/2 +  (CGRectGetMaxX(currentItemView.frame) - CGRectGetMinX(currentItemView.frame))*progress;
        w = CGRectGetWidth(currentItemView.frame) - self.itemSpace + (CGRectGetWidth(currentItemView.frame)  - CGRectGetWidth(currentItemView.frame))*progress;
        
        currentItemView.font = [UIFont fontWithName:self.titleFont.fontName size:(self.titleFont.pointSize + 3)-ABS(2*progress)];
    }else{
        
        x = CGRectGetMinX(currentItemView.frame) + self.itemSpace/2 + (CGRectGetMinX(nextItemView.frame) - CGRectGetMinX(currentItemView.frame))*progress;
        w = CGRectGetWidth(currentItemView.frame) - self.itemSpace + (CGRectGetWidth(nextItemView.frame) - CGRectGetWidth(currentItemView.frame))*progress;
        currentItemView.font = [UIFont fontWithName:self.titleFont.fontName size:(self.titleFont.pointSize + 3)-ABS(2*progress)];
        nextItemView.font = [UIFont fontWithName:self.titleFont.fontName size:self.titleFont.pointSize+ABS(2*progress)];
    }
    
    _sliderBottomView.frame = CGRectMake(x, CGRectGetMaxY(currentItemView.frame)+self.bottomViewTopConstraint, w, 5);
}

// 将选中的 item 移到屏幕中间
- (void)scrollSelectViewToMiddleWithSelectItem:(SliderItemView *)itemView {

    CGFloat offsetX = (self.frame.size.width - itemView.frame.size.width) / 2;
    
    if (itemView.frame.origin.x <= self.frame.size.width / 2)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (CGRectGetMaxX(itemView.frame) >= (self.scrollView.contentSize.width - self.frame.size.width / 2))
    {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.frame.size.width, 0) animated:YES];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointMake(CGRectGetMinX(itemView.frame) - offsetX, 0) animated:YES];
    }
}

@end



@implementation SliderItemView

// 滑动进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [_fillColor set];
    
    CGRect newRect = rect;
    newRect.size.width = rect.size.width * self.progress;
    UIRectFillUsingBlendMode(newRect, kCGBlendModeSourceIn);
}


@end
