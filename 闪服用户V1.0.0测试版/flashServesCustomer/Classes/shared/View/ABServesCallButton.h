//
//  ABServesCall.h
//  flashServes
//
//  Created by 002 on 16/3/21.
//  Copyright © 2016年 002. All rights reserved.
//  '客服电话'

#import <UIKit/UIKit.h>

@interface ABServesCallButton : UIButton

@property (nonatomic, copy) NSString *servesTelNum; // 客服电话号码

/**
 初始化方法
 
 @param num      号码
 @param fontSize 字体大小
 @param color    字体颜色
 
 @return 号码
 */
+ (instancetype)servesTelNum:(NSString *)num fontSize:(NSInteger)fontSize FontColor:(UIColor *)color;

/**
 初始化方法
 
 @param num      号码
 @param fontSize 字体大小
 @param color    字体颜色
 
 @return 号码
 */
- (instancetype)initWithservesTelNum:(NSString *)num fontSize:(NSInteger)fontSize FontColor:(UIColor *)color;

@end
