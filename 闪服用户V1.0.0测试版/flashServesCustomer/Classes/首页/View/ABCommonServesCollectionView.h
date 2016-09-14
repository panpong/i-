//
//  ABCommonServesCollectionView.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//  ‘常用服务区包括服务图标、服务项’

#import <UIKit/UIKit.h>

@interface ABCommonServesCollectionView : UICollectionView

@property(nonatomic,weak) UIViewController *viewController; // 视图所属的控制器

@property(nonatomic,strong) NSArray *services;   // 数据来源

@end
