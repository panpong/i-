//
//  UIImage+Ex.m
//  新浪微博
//
//  Created by 002 on 15/9/29.
//  Copyright (c) 2015年 002. All rights reserved.
//

#import "UIImage+Ex.h"

@implementation UIImage (Ex)

+ (instancetype)originalImage:(NSString *)imageName
{
    return [[self imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
