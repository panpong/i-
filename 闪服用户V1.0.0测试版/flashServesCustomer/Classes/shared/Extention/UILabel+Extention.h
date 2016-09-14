//
//  UILabel+Extention.h
//  OCMicroBlog
//
//  Created by 002 on 15/11/4.
//  Copyright © 2015年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extention)


/**
 *  便利构造函数
 *
 *  @param title    标题
 *  @param fontSize 字体大小
 *  @param color    字体颜色
 *
 *  @return UILabel
 */
+ (instancetype)labelWithTitle:(NSString *)title
                     fontSize:(CGFloat) fontSize
                        color:(UIColor *)color;


/**
 便利构造函数
 
 @param title    标题
 @param fontSize 字体大小
 @param color    字体颜色
 @param isBold   是否加粗
 
 @return UILabel
 */
+ (instancetype)labelWithTitle:(NSString *)title
                     fontSize:(CGFloat) fontSize
                        color:(UIColor *)color isBold:(BOOL)isBold;

+ (instancetype)labelWithTitle:(NSString *)title
                     fontSize:(CGFloat) fontSize
                        color:(UIColor *)color
                  screenInset:(CGFloat)screenInset;

@end
