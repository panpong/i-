//
//  UIImageView+Extention.m
//  OCMicroBlog
//
//  Created by 002 on 15/11/4.
//  Copyright © 2015年 002. All rights reserved.
//

#import "UIImageView+Extention.h"

@implementation UIImageView (Extention)

/**
 *  使用 ‘图片名称’ 创建UIImageView
 *
 *  @param imageName 图片名称
 *
 *  @return UIImageView
 */
+ (instancetype)imageName:(NSString *)imageName {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    return imageView;
}

@end
