//
//  UIButton+Extention.h
//  OCMicroBlog
//
//  Created by 002 on 15/11/4.
//  Copyright © 2015年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extention)


+ (instancetype)buttonWithImageName:(NSString *)imageName
                    BackImageName:(NSString *)backImageName;

+ (instancetype)buttonWithTitle:(NSString *)title
                            color:(UIColor *)color
                         fontSize:(CGFloat)fontSize
                    backImageName:(NSString *)backImageName;

+ (instancetype)buttonWithTitle:(NSString *)title
                        color:(UIColor *)color
                     fontSize:(CGFloat)fontSize
                imageName:(NSString *)imageName;

@end
