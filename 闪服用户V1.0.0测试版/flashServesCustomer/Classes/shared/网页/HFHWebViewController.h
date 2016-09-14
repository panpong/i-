//
//  HFHWebViewController.h
//  flashServesCustomer
//
//  Created by 002 on 16/5/6.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFHWebViewController : UIViewController

@property (strong, nonatomic) NSURL *homeUrl;

/**
 跳转到web页面，默认有缓存
 
 @param controller 跳转的控制器，一般传调用者控制器self
 @param urlStr     url地址（相对路径）
 @param title      标题
 @param ishidden   是否隐藏tabber栏
 */
+ (void)showWithController:(UIViewController *)controller withUrlStr:(NSString *)urlStr withTitle:(NSString *)title hidesBottomBarWhenPushed:(BOOL)ishidden;

/**
 跳转到web页面，iOS9以上的版本才支持设置缓存方法（即版本>=iOS9设置isCaching = YES才会生效）
 
 @param controller 跳转的控制器，一般传调用者控制器self
 @param urlStr     url地址（相对路径）
 @param title      标题
 @param ishidden   是否隐藏tabber栏
 @param isCaching  是否需要缓存
 */
+ (void)showWithController:(UIViewController *)controller withUrlStr:(NSString *)urlStr withTitle:(NSString *)title hidesBottomBarWhenPushed:(BOOL)ishidden isCaching:(BOOL)isCaching;

/**
 跳转到web页面
 
 @param controller          跳转的控制器，一般传调用者控制器self
 @param urlStr              url地址（相对路径）
 @param title               标题
 @param isShownDeleteButton 是否显示删除按钮 - 此项目中只有指定页面（目前就一个）使用
 @param isCaching           是否需要缓存
 */
+ (void)showWithController:(UIViewController *)controller withUrlStr:(NSString *)urlStr withTitle:(NSString *)title isShownDeleteButton:(BOOL)isShownDeleteButton isCaching:(BOOL)isCaching;

@end
