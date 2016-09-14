//
//  ABFirstClassServesCollectionView.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//  ‘一级服务类包括服务图标、一级服务名称，通过ID与后台以及服务分类绑定，位置固定。点击图标进入对应的服务分类页面’

#import <UIKit/UIKit.h>

@interface ABFirstClassServesCollectionView : UICollectionView

// 防止循环引用，所以当前View必须添加到一个视图上的时候才能设置，否则不生效：已设置就会被销毁
@property(nonatomic,weak) UIViewController *viewController;


+ (instancetype)firstClassServesWithClasses:(NSArray *)classes frame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;


@end
