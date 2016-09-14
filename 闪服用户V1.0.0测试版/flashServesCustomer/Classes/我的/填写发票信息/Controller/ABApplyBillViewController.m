//
//  ABApplyBillViewController.m
//  flashServesCustomer
//
//  Created by 002 on 16/6/3.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABApplyBillViewController.h"
#import "UIView+Extention.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABApplyBillView.h"

@interface ABApplyBillViewController ()

@property(nonatomic,strong) ABApplyBillView *applyBillView;

// 可开发票金额
@property (nonatomic, copy) NSString *leftMoney;

// 上次发票抬头信息
@property (nonatomic, copy) NSString *lastBillTitle;

@end

@implementation ABApplyBillViewController

- (instancetype)initWithLeftMoney:(NSString *)leftMoney lastBillTitle:(NSString *)lastBillTitle {
    if (self = [super init]) {
        self.leftMoney = leftMoney;
        self.lastBillTitle = lastBillTitle;
    }
    return self;
}

+ (instancetype)applyBillViewControllerWithLeftMoeny:(NSString *)leftMoney lastBillTitle:(NSString *)lastBillTitle {
    ABApplyBillViewController *applyBillViewController = [[ABApplyBillViewController alloc] initWithLeftMoney:leftMoney lastBillTitle:lastBillTitle];
    return applyBillViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarItem:@"输入发票信息" leftButtonIcon:@"返回"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(keyboardHide)];
    [self.view addGestureRecognizer:tap];
    [self setupUI];
}

#pragma mark - UI设置
- (void)setupUI {
    self.view.backgroundColor = KGrayGroundColor;
    // 1. 添加控件
    [self.view addSubview:self.applyBillView];
    
    // 2. 布局
    self.applyBillView.height = ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR;
    self.applyBillView.y = SIZE_HEIGHT_NAVIGATIONBAR;
}

#pragma mark - 监听键盘
- (void)keyboardHide {
    // 获取当前界面的第一响应对象
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    // 取消注册
    [firstResponder resignFirstResponder];
}

#pragma mark - 懒加载
- (ABApplyBillView *)applyBillView {
    if (!_applyBillView) {
        _applyBillView = [ABApplyBillView applyBillViewWithFrame:self.view.frame leftMoney:self.leftMoney lastBillTitle:self.lastBillTitle];
        _applyBillView.viewController = self;
    }
    return _applyBillView;
}

@end
