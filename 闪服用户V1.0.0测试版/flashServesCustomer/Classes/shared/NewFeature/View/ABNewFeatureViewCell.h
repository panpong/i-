//
//  ABNewFeatureViewCell.h
//  LoveTourGuide
//
//  Created by 002 on 16/1/6.
//  Copyright © 2016年 fhhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABNewFeatureViewCell : UICollectionViewCell

/**
 ‘开始按钮’动画
 */
- (void)showButtonAnim:(BOOL)isShown;

/**
 设置cell对应的引导图
 
 @param imageIndex 引导图索引
 @param images     引导图图片名称数组
 */
- (void)setImageIndex:(NSInteger)imageIndex images:(NSArray<NSString *> *)images;

- (void)setJumpButton:(NSString *)name multipliedByBottom:(CGFloat)mutiple;

- (void)setStartExperienceButton:(NSString *)name rightMargin:(CGFloat)rightMargin topMargin:(CGFloat)topMargin;

- (void)setupUI;

@end
