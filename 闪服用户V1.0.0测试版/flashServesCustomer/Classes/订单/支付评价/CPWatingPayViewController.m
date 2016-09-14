//
//  CPWatingPayViewController.m
//  flashServesCustomer
//
//  Created by yjin on 16/6/6.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPWatingPayViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "CPModalOrder.h"
#import "UIView+Extention.h"
@interface CPWatingPayViewController ()

@end

@implementation CPWatingPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarItem:@"支付订单" leftButtonIcon:@"返回" rightButtonTitle:nil];
 
    [self.view setBackgroundColor:kColorBackground];
    
    UILabel *label =  [[UILabel alloc] init];
    label.text = @"等待支付......";
    [label sizeToFit];
    label.centerX = ScreenWidth * 0.5;
    label.y = 30 + 64;
    [self.view addSubview:label];
    
}

- (void)clickLeftNavButton {
    
    [CPModalOrder postOrderListChangeNotification];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
