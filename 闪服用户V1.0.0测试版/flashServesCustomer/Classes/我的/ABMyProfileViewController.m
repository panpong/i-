//
//  ABMyProfileViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABMyProfileViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABProfileAreaViewController.h"

@interface ABMyProfileViewController ()

@end

@implementation ABMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //_isUpdate?@"修改资料":@"我的资料"
    [self setNavigationBarItem:_isUpdate?@"修改资料":@"我的资料" leftButtonIcon:@"返回" rightButtonTitle:nil];

    //加入子ViewController
    ABProfileAreaViewController *areaViewController=[ABProfileAreaViewController getProfileAreaViewController];
    areaViewController.dataDic=_dataDic;
    areaViewController.isUpdate=_isUpdate;
    areaViewController.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    [self addChildViewController:areaViewController];
    [self.view addSubview:areaViewController.view];
}

@end
