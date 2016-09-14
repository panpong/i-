//
//  ABServicePackageLoginView.h
//  flashServesCustomer
//
//  Created by 002 on 16/6/1.
//  Copyright © 2016年 002. All rights reserved.
//  '服务包'登录视图

#import <UIKit/UIKit.h>

@interface ABServicePackageLoginView : UIView

// 根据登录是否展示底部View
@property(nonatomic,assign) BOOL isShowBottomView;

// 视图所属控制器
@property(nonatomic,weak) UIViewController *viewController;


+ (instancetype)servicePackageLoginViewWithFrame:(CGRect)frame;

@end
