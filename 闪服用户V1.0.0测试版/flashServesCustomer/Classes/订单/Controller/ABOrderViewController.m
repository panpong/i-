//
//  ABOrderViewController.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/15.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABOrderViewController.h"
#import "ABTabBarViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "CPRuningOrderViewController.h"
#import "CPAllOrederViewController.h"
#import "CPFinishedOrederViewController.h"
@interface ABOrderViewController ()

@property (nonatomic,strong)ABTabBarViewController *tabVC ;

@end

@implementation ABOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    CPRuningOrderViewController *runVC  = [[CPRuningOrderViewController alloc] init];
    CPFinishedOrederViewController *finishedVC  = [[CPFinishedOrederViewController alloc] init];
    CPAllOrederViewController *allVC  = [[CPAllOrederViewController alloc] init];
    
    NSArray *array = @[runVC,finishedVC,allVC];
    // 进行中、已完成、和全部订单
    
    NSArray *array2 = @[@"进行中",@"已完成",@"全部订单"];
    
    self.tabVC = [[ABTabBarViewController alloc] initWithArrayChilds:array tabBars:array2];
    self.tabVC.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    [self addChildViewController:self.tabVC];
    [self.view addSubview:self.tabVC.view];
    
    [self setNavigationBarItem:@"我的订单" leftButtonIcon:nil rightButtonTitle:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
