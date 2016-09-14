//
//  ABServicePackageLoginView.m
//  flashServesCustomer
//
//  Created by 002 on 16/6/1.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServicePackageLoginView.h"
#import "UIImageView+Extention.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import "UIView+Extention.h"
#import "ABNetworkManager.h"
#import "ABLoginViewController.h"

//#defin
#define PADDDING_TOP_logoImageView (86) // logoImageView的 ‘顶部间距’
#define PADDDING_TOP_descriptionLabel1 33 // descriptionLabel1的 ‘顶部间距’
#define PADDDING_TOP_descriptionLabel2 22 // descriptionLabel2的 ‘顶部间距’
#define PADDDING_TOP_descriptionLabel3 5 // descriptionLabel3的 ‘顶部间距’
#define PADDDING_TOP_makeCallButton 14 // makeCallButton的 ‘顶部间距’
#define PADDDING_BOTTOM_bottomView 15 // bottomView的 ‘底部间距’


@interface ABServicePackageLoginView ()

@property(nonatomic,strong) UIImageView *logoImageView;
@property(nonatomic,strong) UILabel *descriptionLabel1;
@property(nonatomic,strong) UILabel *descriptionLabel2;
@property(nonatomic,strong) UILabel *descriptionLabel3;
@property(nonatomic,strong) UIButton *makeCallButton;
@property(nonatomic,strong) UILabel *descriptionLabel4;
@property(nonatomic,strong) UIButton *loginButton;
@property(nonatomic,strong) UIView *bottomView;


@end

@implementation ABServicePackageLoginView


- (instancetype)initWithFrame:(CGRect)frmae {
    if (self = [super initWithFrame:frmae]) {
        [self setupUI];
    }
    return self;
}


+ (instancetype)servicePackageLoginViewWithFrame:(CGRect)frame {
    ABServicePackageLoginView *servicePackageLoginView = [[ABServicePackageLoginView alloc] initWithFrame:frame];
    return servicePackageLoginView;
}

#pragma mark - UI设置
- (void)setupUI {
    // 1. 添加控件
    [self addSubview:self.logoImageView];
    [self addSubview:self.descriptionLabel1];
    [self addSubview:self.descriptionLabel2];
    [self addSubview:self.descriptionLabel3];
    [self addSubview:self.makeCallButton];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.descriptionLabel4];
    [self.bottomView addSubview:self.loginButton];
    
    // 2. 布局
    self.logoImageView.centerX = self.width / 2;
    self.logoImageView.y = PADDDING_TOP_logoImageView;
    if (iPhone5) {
        self.logoImageView.y = toiPhone5Vaule(PADDDING_TOP_logoImageView);
    }
    
    self.descriptionLabel1.centerX = self.logoImageView.centerX;
    self.descriptionLabel1.y = self.logoImageView.bottom + PADDDING_TOP_descriptionLabel1;
    if (iPhone5) {
        self.descriptionLabel1.y = self.logoImageView.bottom + toiPhone5Vaule(PADDDING_TOP_descriptionLabel1);
    }
    
    self.descriptionLabel2.centerX = self.logoImageView.centerX;
    self.descriptionLabel2.y = self.descriptionLabel1.bottom + PADDDING_TOP_descriptionLabel2;
    if (iPhone5) {
        self.descriptionLabel2.y = self.descriptionLabel1.bottom + toiPhone5Vaule(PADDDING_TOP_descriptionLabel2);
    }
    
    self.descriptionLabel3.centerX = self.logoImageView.centerX;
    self.descriptionLabel3.y = self.descriptionLabel2.bottom + PADDDING_TOP_descriptionLabel3;
    if (iPhone5) {
        self.descriptionLabel3.y = self.descriptionLabel2.bottom + toiPhone5Vaule(PADDDING_TOP_descriptionLabel3);
    }
    
    self.makeCallButton.centerX = self.logoImageView.centerX;
    self.makeCallButton.y = self.descriptionLabel3.bottom + PADDDING_TOP_makeCallButton;
    if (iPhone5) {
        self.makeCallButton.y = self.descriptionLabel3.bottom + toiPhone5Vaule(PADDDING_TOP_makeCallButton);
    }
    
    self.bottomView.centerX = self.logoImageView.centerX;
    self.bottomView.bottom = self.height - PADDDING_BOTTOM_bottomView;
    if (iPhone5) {
        self.bottomView.bottom = self.height - toiPhone5Vaule(PADDDING_BOTTOM_bottomView);
    }
    self.descriptionLabel4.x = 0;
    self.descriptionLabel4.centerY = self.bottomView.height / 2;
    
    self.loginButton.x = self.descriptionLabel4.right;
    self.loginButton.centerY = self.descriptionLabel4.centerY;
    
}

#pragma mark - 登录按钮点击事件
- (void)loginButtonDidClick {
    ABLoginViewController *loginViewController = [[ABLoginViewController alloc] init];
    loginViewController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:loginViewController animated:YES];
}

#pragma mark - 拨打电话
- (void)makeCall {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",SERVICE_PHONE_NUM];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - 懒加载
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIImageView imageName:@"ios-服务包-默认图"];        
    }
    return _logoImageView;
}

- (UILabel *)descriptionLabel1 {
    if (!_descriptionLabel1) {
        _descriptionLabel1 = [UILabel labelWithTitle:@"线下支付  充值返现  高优先级" fontSize:18 color:KBlackColor];
        _descriptionLabel1.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionLabel1;
}

- (UILabel *)descriptionLabel2 {
    if (!_descriptionLabel2) {
        _descriptionLabel2 = [UILabel labelWithTitle:@"我们目前已经累计服务过5000家以上的企业" fontSize:PADDING_28PX color:KColorTextPlaceHold];
        _descriptionLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionLabel2;
}

- (UILabel *)descriptionLabel3 {
    if (!_descriptionLabel3) {
        _descriptionLabel3 = [UILabel labelWithTitle:@"立即申请，享受不定期的巡检服务，立减优惠！" fontSize:PADDING_28PX color:KColorTextPlaceHold];
        _descriptionLabel3.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionLabel3;
}

- (UIButton *)makeCallButton {
    if (!_makeCallButton) {
        _makeCallButton = [UIButton buttonWithTitle:[NSString stringWithFormat:@"立即拨打 %@",SERVICE_PHONE_NUM] color:KColorBlue fontSize:PADDING_30PX imageName:nil];
        [_makeCallButton addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    }
    return _makeCallButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = self.backgroundColor;
        _bottomView.width = self.descriptionLabel4.width + self.loginButton.width;
        _bottomView.height = self.descriptionLabel4.height;
    }
    return _bottomView;
}

- (UILabel *)descriptionLabel4 {
    if (!_descriptionLabel4) {
        _descriptionLabel4 = [UILabel labelWithTitle:@"我已申请服务包，去" fontSize:PADDING_30PX color:KColorTextPlaceHold];
    }
    return _descriptionLabel4;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithTitle:@"登录" color:KColorBlue fontSize:PADDING_30PX imageName:nil];
        [_loginButton addTarget:self action:@selector(loginButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

#pragma mark - setter
- (void)setIsShowBottomView:(BOOL)isShowBottomView {
    _isShowBottomView = isShowBottomView;
    self.loginButton.hidden = !_isShowBottomView;
    self.descriptionLabel4.hidden = !_isShowBottomView;
}

@end
