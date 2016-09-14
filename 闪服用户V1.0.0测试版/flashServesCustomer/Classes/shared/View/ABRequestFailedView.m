
//
//  ABRequestFailedView.m
//  flashServesCustomer
//
//  Created by 002 on 16/5/12.
//  Copyright © 2016年 002. All rights reserved.
//  '请求失败页面'

#import "ABRequestFailedView.h"
#import "UIImageView+Extention.h"
#import "UILabel+Extention.h"
#import "UIView+Extention.h"

@interface ABRequestFailedView ()

@property(nonatomic,strong) UIView *requestFailedView;

@property(nonatomic,strong) UITapGestureRecognizer *refreshTap;

@end

@implementation ABRequestFailedView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame action:(SEL)action object:(id)object {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        // 手势监听方法
        [self.refreshTap addTarget:object action:action];
    }
    return self;
}

+ (instancetype)requestFailedViewWithFrame:(CGRect)frame action:(SEL)action object:(id)object {
    ABRequestFailedView *requestFailedView = [[ABRequestFailedView alloc] initWithFrame:frame action:action object:object];
    return requestFailedView;
}

#pragma mark - UI设置
- (void)setupUI {
    
    // 1.添加控件
    [self addSubview:self.requestFailedView];
    
    // 2. 布局
    self.requestFailedView.x = 0;
    self.requestFailedView.y = 0;
}

- (UIView *)requestFailedView {
    if (!_requestFailedView) {
        _requestFailedView = [[UIView alloc] init];
        _requestFailedView.backgroundColor = kColorBackground;
        _requestFailedView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        UIImageView *refreshImageView = [UIImageView imageName:@"ios_点击刷新"];
        UILabel *descLabel = [UILabel labelWithTitle:@"网络不给力，请检查设置后再试" fontSize:15 color:kColorTextGrey];
        [_requestFailedView addSubview:refreshImageView];
        [_requestFailedView addSubview:descLabel];
        refreshImageView.center = CGPointMake(self.frame.size.width / 2, _requestFailedView.height / 2 - 50);
        refreshImageView.y = (self.frame.size.height - 64) * 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        self.refreshTap = tap;
        refreshImageView.userInteractionEnabled = YES;
        [_requestFailedView addGestureRecognizer:tap];
        
        descLabel.center = refreshImageView.center;
        descLabel.y = refreshImageView.bottom + 45;
        
    }
    return _requestFailedView;
}

@end
