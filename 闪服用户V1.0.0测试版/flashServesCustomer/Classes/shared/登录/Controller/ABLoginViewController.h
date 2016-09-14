//
//  ABLoginViewController.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/15.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABLoginViewController : UIViewController


/**
 初始化方法
 
 @param desinationControllerStr 目标控制器登录成功后调整的目标控制器的'字符串名称'
 
 @return ABLoginViewController
 */

+ (instancetype)loginViewControllerWithDesinationController:(NSString *)desinationControllerStr;

/**
 初始化方法
 
 @param desinationControllerStr 目标控制器登录成功后调整的目标控制器的'字符串名称'
 @param index                   登录界面点击返回的索引，确定返回到tabbarController的哪个界面
 
 @return ABLoginViewController
 */
+ (instancetype)loginViewControllerWithDesinationController:(NSString *)desinationControllerStr selectedIndex:(NSUInteger)index;


/**
 目标控制器登录成功后调整的目标控制器
 
 @param desinationController 目标控制器
 
 @return ABLoginViewController
 */
+ (instancetype)loginViewControllerWithDesinationViewController:(UIViewController *)desinationViewController;

@end
