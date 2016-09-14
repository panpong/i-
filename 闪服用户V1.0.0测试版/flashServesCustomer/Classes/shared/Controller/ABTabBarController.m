//
//  ABTabBarController.m
//  flashServes
//
//  Created by 002 on 16/3/11.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABTabBarController.h"
#import "ABHomeViewController.h"
#import "ABOrderViewController.h"
#import "ABProfileViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABNetworkManager.h"
#import "ABLoginViewController.h"
#import "UIView+Extention.h"
#import "ABServicePackageViewController.h"

@interface ABTabBarController()<UITabBarControllerDelegate>

@property(nonatomic,assign) NSUInteger lastSelectedIndex;    // 上一次选择的索引

@end

@implementation ABTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.barTintColor = KWhiteColor;
    
    // 设置代理
    self.delegate = self;
    
    // 添加子控制器
    [self addChildViewControllers];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    ABLog(@"self.tabBar.subviews:%zd",self.tabBar.subviews.count);
    
    // 更改tabBar默认的分割线
    for (UIView  *view in self.tabBar.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.height == 0.5) {
            view.height = 1;
            view.backgroundColor = KColorLine;
            return;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildViewControllers {
    // 替换各自的控制器
    [self addChildVC:[[ABHomeViewController alloc] init] WithTitle:@"首页" imageName:@"tab-首页"];
    [self addChildVC:[ABServicePackageViewController getServicePackageViewController] WithTitle:@"服务包" imageName:@"tab-首页服务包"];
    [self addChildVC:[[ABOrderViewController alloc] init] WithTitle:@"订单" imageName:@"tab-首页订单"];
    [self addChildVC:[ABProfileViewController getProfileViewController] WithTitle:@"我的" imageName:@"tab-首页我的"];
}

/**
 *  添加子控制器
 *
 *  @param VC        子控制器
 *  @param title     子控制器名称
 *  @param imageName iamgename
 */
- (void)addChildVC:(UIViewController *)VC WithTitle:(NSString *) title imageName:(NSString *)imageName {
    
    VC.title = title;
    
    [VC.tabBarItem setImage:[UIImage imageNamed:imageName]];
    [VC.tabBarItem setSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@点击",imageName]]];    
    
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:VC];
    
    nVC.navigationBar.hidden = YES;
    [self addChildViewController:nVC];
    
}


#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (self.selectedIndex != 2) {
        self.lastSelectedIndex = self.selectedIndex;
    }
    // 点击‘订单’时判断用户是否登录
    if (self.selectedIndex == 2) {
        if(![ABNetworkDelegate isLogined]) {
            
//            UINavigationController *navController = (UINavigationController *)viewController;            
            // 进入登录界面
            ABLoginViewController *vc = [ABLoginViewController loginViewControllerWithDesinationController:@"ABOrderViewController" selectedIndex:self.lastSelectedIndex];
            vc.hidesBottomBarWhenPushed = YES;
            [(UINavigationController *)viewController pushViewController:vc animated:YES];
            return;
        }        
    }    
}

@end
