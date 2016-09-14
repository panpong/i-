//
//  UIButton+Extention.m
//  OCMicroBlog
//
//  Created by 002 on 15/11/4.
//  Copyright © 2015年 002. All rights reserved.
//

#import "UIButton+Extention.h"

@implementation UIButton (Extention)


/**
 *  使用 ‘图片名’ 和 ‘背景图片名’ 创建按钮
 *
 *  @param imageName     图片名
 *  @param backImageName 背景图片名
 *
 *  @return UIButton
 */
+ (instancetype)buttonWithImageName:(NSString *)imageName
                    BackImageName:(NSString *)backImageName
{
    UIButton *btn = [[UIButton alloc] init];
    
    // 设置图片
    if (imageName != nil) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        if ([UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]]) {
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
        }
    }

    // 设置背景图片
    if (backImageName != nil) {
        [btn setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
        if ([UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",backImageName]] ) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",backImageName]] forState:UIControlStateHighlighted];
        }        
    }
    
    return btn;
}

/**
 *  便利构造函数
 *
 *  @param title         标题
 *  @param color         字体颜色
 *  @param fontSize      字体大小
 *  @param backImageName 背景图片名称
 *
 *  @return UIButton
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                            color:(UIColor *)color
                         fontSize:(CGFloat)fontSize
                    backImageName:(NSString *)backImageName {

    UIButton *button = [[UIButton alloc] init];
    
    if (title != nil && ![@"" isEqualToString:title]) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    
    if (backImageName != nil && ![@"" isEqualToString:backImageName]) {
        [button setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",backImageName]] forState:UIControlStateHighlighted];
    }

    return button;
}

/**
 *  便利构造函数
 *
 *  @param title     title
 *  @param color     color
 *  @param fontSize  fontSize
 *  @param imageName imageName
 *
 *  @return UIButton
 */
+ (instancetype)buttonWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize imageName:(NSString *)imageName {
    
    UIButton *button = [[UIButton alloc] init];
    
    if (title != nil && ![@"" isEqualToString:title]) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (fontSize) {
        [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    }
    
    if (imageName != nil && ![@"" isEqualToString:imageName]) {
       [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }    
    [button sizeToFit];
    
    return button;
}



@end
