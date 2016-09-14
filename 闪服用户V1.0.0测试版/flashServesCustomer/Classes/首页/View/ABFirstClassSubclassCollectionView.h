//
//  ABFirstClassSubclassCollectionView.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//  ‘二级服务项’视图

#import <UIKit/UIKit.h>
#import "ABFirstClassSubclass.h"

@interface ABFirstClassSubclassCollectionView : UICollectionView

@property(nonatomic,weak) UIViewController *viewController;  // 视图所属的控制器

@property(nonatomic,strong) NSArray<ABFirstClassServes *> *firstClassServesArray;    // 数据来源

+ (instancetype)firstClassSubclassCollectionViewWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

@end
