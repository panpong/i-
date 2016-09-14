//
//  ABNewFeatureViewController.h
//  LoveTourGuide
//
//  Created by 002 on 16/1/6.
//  Copyright © 2016年 fhhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABNewFeatureViewController : UICollectionViewController

/**
 初始化方法
 
 @param images 引导图名称数组
 
 @return ABNewFeatureViewController
 */
- (instancetype)initWithImages:(NSArray *)images;

/**
 设置‘跳过按钮’
 
 @param name    图片名称
 @param mutiple 按钮底部相对于屏幕底部位置 数值范围0<mutiple<=1，1代表按钮底部和屏幕底部重合，0代表按钮底部等于屏幕顶部
 */
- (void)setJumpButton:(NSString *)name multipliedByBottom:(CGFloat)mutiple;

/**
 设置‘开始体验’按钮

 @param name        图片名称
 @param rightMargin 相对于屏幕右边距离
 @param topMargin   相对于屏幕顶部距离
 */
- (void)setStartExperienceButton:(NSString *)name rightMargin:(CGFloat)rightMargin topMargin:(CGFloat)topMargin;

/**
 设置展示‘开始体验’按钮是否有动画效果
 
 @param isShown isShown
 */
- (void)setStartButtonAnimateShown:(BOOL)isShown;

@end
