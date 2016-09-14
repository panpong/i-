//
//  ABCustomerServiceView.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABCustomerServiceView.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import "UIView+Extention.h"
#import "HFHWebViewController.h"
#import "ABNetworkDelegate.h"
#define FONT_SIZE 13 // 字体大小
#define SIZE_HEIGHT_VIEW 31 // VIEW的高度
#define PADDING_DESC_BETWEEN 13 // 两个DESC标签的间距

@interface ABCustomerServiceView ()

@property(nonatomic,strong) UIView *view;
@property(nonatomic,strong) UIButton *commonProblemButton;   // 常见问题按钮
@property(nonatomic,strong) UILabel *descLabel2;    // 联系电话
@property(nonatomic,strong) UIButton *servesCallButton; // ‘客服电话’按钮
@property(nonatomic,strong) UIView *sep1;   // 分割线


@end

@implementation ABCustomerServiceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    self.backgroundColor = KGrayGroundColor;
    
    // 1. 添加控件
    [self addSubview:self.view];
    [self.view addSubview:self.commonProblemButton];
    [self.view addSubview:self.descLabel2];
    [self.view addSubview:self.servesCallButton];
    [self.view addSubview:self.sep1];
    
    // 2. 布局
    self.view.width = self.commonProblemButton.width + self.descLabel2.width + self.servesCallButton.width + PADDING_DESC_BETWEEN;
    self.view.height = self.descLabel2.height;
    self.view.centerX = self.width / 2;
    self.view.centerY = self.height / 2;
    
    self.commonProblemButton.x = 0;
    self.commonProblemButton.centerY = self.view.height / 2;
    
    self.descLabel2.x = self.commonProblemButton.right + PADDING_DESC_BETWEEN;
    self.descLabel2.centerY = self.view.height / 2;
    
    self.servesCallButton.x = self.descLabel2.right;
    self.servesCallButton.centerY = self.view.height / 2;
    
    self.sep1.width = 1;
    self.sep1.height = self.descLabel2.height - 6;
    self.sep1.x = (self.descLabel2.x - self.commonProblemButton.right) / 2 + self.commonProblemButton.right;
    self.sep1.y = self.descLabel2.y + 3;
}

- (void)makeCall {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.servesCallButton.titleLabel.text];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}


#pragma mark - 跳转常见问题界面
- (void)jumpToCommontProblemVC {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[ABNetworkDelegate serverHtml5URL],@"/files/userFAQ.html"];    
    self.viewController.navigationController.navigationBar.hidden = YES;
    [HFHWebViewController showWithController:self.viewController withUrlStr:urlStr withTitle:@"常见问题" hidesBottomBarWhenPushed:YES];
}

#pragma mark - 懒加载
- (UIView *)view {
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.backgroundColor = KGrayGroundColor;
    }
    return _view;
}

- (UIButton *)commonProblemButton {
    if (!_commonProblemButton) {
        _commonProblemButton = [UIButton buttonWithTitle:@"常见问题" color:kColorTextGrey fontSize:13 imageName:nil];
        [_commonProblemButton addTarget:self action:@selector(jumpToCommontProblemVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commonProblemButton;
}

- (UILabel *)descLabel2 {
    if (!_descLabel2) {
        _descLabel2 = [UILabel labelWithTitle:@"联系电话：" fontSize:FONT_SIZE color:kColorTextGrey];
    }
    return _descLabel2;
}

- (UIButton *)servesCallButton {
    if (!_servesCallButton) {
        _servesCallButton = [UIButton buttonWithTitle:SERVICE_PHONE_NUM color:KColorBlue fontSize:FONT_SIZE imageName:nil];
        [_servesCallButton addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    }
    return _servesCallButton;
}

- (UIView *)sep1 {
    if (!_sep1) {
        _sep1 = [[UIView alloc] init];
        _sep1.backgroundColor = kColorTextGrey;
    }
    return _sep1;
    
}

@end
