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
    
     [self createSliderItemView];
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
        
        _itemSpace = 30;
        _indexOffset = 0.0;
        _normalColor = [UIColor grayColor];
        _selectColor = [UIColor redColor];
        _bottomColor = [UIColor redColor];
        _sliderItemViewArray = [NSMutableArray arrayWithCapacity:self.itemArray.count];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
 
    }
    return self;
}

- (void)createSliderItemView {
    
    for (int i = 0; i < self.itemArray.count; i++) {
        
        SliderItemView *itemView = [[SliderItemView alloc]init];
        itemView.tag = i ;
        itemView.textAlignment = NSTextAlignmentCenter;
        itemView.textColor = _normalColor;
        itemView.fillColor = _selectColor;
        itemView.text = [self.itemArray objectAtIndex:i];
        itemView.userInteractionEnabled = YES;
        if (i == 0) {
            itemView.progress = 1;
            itemView.font = [UIFont systemFontOfSize:16];
        }else{
            itemView.progress = 0;
            itemView.font = [UIFont systemFontOfSize:14];
        }
        CGFloat width = [itemView.text getStringWidth:[UIFont systemFontOfSize:14] Height:20]+self.itemSpace;
        CGFloat height = self.frame.size.height;
        CGFloat x = 0;
        x = i>0 ? CGRectGetMaxX(((SliderItemView *)self.sliderItemViewArray[i-1]).frame):0;
        CGFloat y = 0;
        itemView.frame = CGRectMake(x, y, width, height);
        
        [self.scrollView addSubview:itemView];
        
        [_sliderItemViewArray addObject:itemView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [itemView addGestureRecognizer:tap];
    }
    
    SliderItemView *itemView = (SliderItemView *)[self.sliderItemViewArray objectAtIndex:0];
    _sliderBottomView = [[UIView alloc]initWithFrame:CGRectMake(itemView.center.x-([itemView.text getStringWidth:[UIFont systemFontOfSize:14] Height:20])/2,
                                                                self.frame.size.height - 3,
                                                                [itemView.text getStringWidth:[UIFont systemFontOfSize:14] Height:20],
                                                                3)];
    _sliderBottomView.backgroundColor = _bottomColor;
    [self.scrollView addSubview:_sliderBottomView];
    
    CGFloat maxX = CGRectGetMaxX(((SliderItemView*)self.sliderItemViewArray.lastObject).frame);
    if (maxX < self.frame.size.width) {
        maxX = self.frame.size.width;
    }
    _scrollView.contentSize = CGSizeMake(maxX, self.frame.size.height);
}

#pragma mark - tap

- (void)tap:(UITapGestureRecognizer *)tap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:slideAtIndex:)]) {
        
        [self.delegate sliderView:self slideAtIndex:(tap.view.tag)];
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
        _sliderBottomView.frame = CGRectMake(currentItemView.center.x-([currentItemView.text getStringWidth:[UIFont systemFontOfSize:14] Height:20])/2,
                                                                    self.frame.size.height - 3,
                                                                    [currentItemView.text getStringWidth:[UIFont systemFontOfSize:14] Height:20],
                                                                    3);
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
        
        currentItemView.font = [UIFont systemFontOfSize:16-ABS(2*progress)];
    }else{
        
        x = CGRectGetMinX(currentItemView.frame) + self.itemSpace/2 + (CGRectGetMinX(nextItemView.frame) - CGRectGetMinX(currentItemView.frame))*progress;
        w = CGRectGetWidth(currentItemView.frame) - self.itemSpace + (CGRectGetWidth(nextItemView.frame) - CGRectGetWidth(currentItemView.frame))*progress;
        
        currentItemView.font = [UIFont systemFontOfSize:16-2*progress];
        nextItemView.font = [UIFont systemFontOfSize:14 + 2*progress];
        
    }
    
    _sliderBottomView.frame = CGRectMake(x, self.frame.size.height-3, w, 3);
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
