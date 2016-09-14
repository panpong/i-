//
//  ABRetrievePasswordViewController.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABRetrievePasswordViewController.h"
#import "ABRetrievePasswordView.h"
#import "UIView+Extention.h"
#import "UIViewController+CustomNavigationBar.h"

@interface ABRetrievePasswordViewController ()

@property(nonatomic,strong) ABRetrievePasswordView *retrievePasswordView;

@end

@implementation ABRetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 设置导航栏
    [self setNavigationBarItem:@"找回密码" leftButtonIcon:@"返回"];
    
    // 2. 设置界面
    [self setupUI];
    
    // 3. 点击当前VIEW退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置UI
- (void)setupUI {
    
    // 1. 添加视图
    [self.view addSubview:self.retrievePasswordView];
    
    // 2. 布局
    self.retrievePasswordView.height = ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR;
    self.retrievePasswordView.width = ScreenWidth;
    self.retrievePasswordView.y = SIZE_HEIGHT_NAVIGATIONBAR;
    self.retrievePasswordView.x = 0;
}

#pragma mark - 隐藏键盘
- (void)keyboardHide {
    
    // 获取当前界面的第一响应对象
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    // 取消注册
    [firstResponder resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 懒加载
- (ABRetrievePasswordView *)retrievePasswordView {
    if (!_retrievePasswordView) {
        _retrievePasswordView = [[ABRetrievePasswordView alloc] init];
        _retrievePasswordView.viewController = self;
    }
    return _retrievePasswordView;
}

@end
