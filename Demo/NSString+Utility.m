//
//  NSString+Utility.m
//  SaleHouse
//
//  Created by  on 15-1-5.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "NSString+Utility.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


@implementation NSString (Utility)


-(CGFloat)getStringWidth:(UIFont*)font Height:(CGFloat)height
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  font, NSFontAttributeName,
                                  nil];
    
    [attributedString addAttributes:attrSyleDict
                              range:NSMakeRange(0, self.length)];
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                         
                                                       context:nil];
    
    return stringRect.size.width;
}

@end
