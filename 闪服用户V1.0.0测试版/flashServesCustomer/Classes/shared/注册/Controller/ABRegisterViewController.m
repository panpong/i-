//
//  ABRegisterViewController.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/18.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABRegisterViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "UIView+Extention.h"
#import "ABRegisterView.h"


@interface ABRegisterViewController ()

@end

@implementation ABRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 设置导航栏
    [self setNavigationBarItem:@"注册" leftButtonIcon:@"返回"];

    // 2. 设置UI
    [self setupUI];
    
    // 3. 点击当前VIEW退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI设置
- (void)setupUI {
    
    // 1. 添加控件
    [self.view addSubview:self.registerView];
    
    // 2. 布局
    self.registerView.height = ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR;
    self.registerView.width = ScreenWidth;
    self.registerView.x = 0;
    self.registerView.y = SIZE_HEIGHT_NAVIGATIONBAR;
    
    // 确定registerView的frame后执行registerView内部的UI设置
    [self.registerView setupUI];
}

#pragma mark - 隐藏键盘
- (void)keyboardHide {
    
    // 获取当前界面的第一响应对象
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    // 取消注册
    [firstResponder resignFirstResponder];
}

#pragma mark - 懒加载
- (ABRegisterView *)registerView {
    if (!_registerView) {
        _registerView = [[ABRegisterView alloc] init];
        _registerView.viewController = self;
    }
    return _registerView;
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
