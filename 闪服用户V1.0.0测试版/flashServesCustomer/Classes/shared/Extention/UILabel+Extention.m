//
//  UILabel+Extention.m
//  OCMicroBlog
//
//  Created by 002 on 15/11/4.
//  Copyright © 2015年 002. All rights reserved.
//

#import "UILabel+Extention.h"

@implementation UILabel (Extention)

+ (instancetype)labelWithTitle:(NSString *)title
                     fontSize:(CGFloat) fontSize
                        color:(UIColor *)color {
    
    UILabel *label = [[UILabel alloc] init];
    if (title != nil && ![@"" isEqualToString:title]) {
        label.text = title;
    }
    if (color) {
        label.textColor = color;
    }
    label.font = [UIFont systemFontOfSize:fontSize];
    
    [label sizeToFit];
    
    return label;
}

+ (instancetype)labelWithTitle:(NSString *)title
                     fontSize:(CGFloat) fontSize
                        color:(UIColor *)color isBold:(BOOL)isBold {
    
    UILabel *label = [[UILabel alloc] init];
    if (title != nil && ![@"" isEqualToString:title]) {
        label.text = title;
    }
    if (isBold) {
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    } else {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    if (color) {
        label.textColor = color;
    }    
    
    [label sizeToFit];
    
    return label;
}

/**
 *  便利构造函数
 *
 *  @param title       title
 *  @param fontSize    fontSize
 *  @param color       color
 *  @param screenInset 相对屏幕的左右缩进
 *
 *  @return  UILabel
 */
+ (instancetype)labelWithTitle:(NSString *)title
                     fontSize:(CGFloat) fontSize
                        color:(UIColor *)color
                  screenInset:(CGFloat)screenInset {
    UILabel *label = [[UILabel alloc] init];
    
    if (title != nil && ![@"" isEqualToString:title]) {
        label.text = title;
    }
    if (color) {
        label.textColor = color;
    }
    label.font = [UIFont systemFontOfSize:fontSize];
    
    [label sizeToFit];
    label.numberOfLines = 0;
    
    if (screenInset > 0) {
        label.textAlignment = NSTextAlignmentLeft;
        label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 2 * screenInset;
    } else {
        label.textAlignment = NSTextAlignmentCenter;
    }
    return label;
}

@end
