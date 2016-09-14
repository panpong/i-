//
//  ABServesCallView.m
//  flashServes
//
//  Created by 002 on 16/3/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServesCallView.h"
#import <Masonry.h>
#import "ABServesCallButton.h"
#import "UIImageView+Extention.h"
#import "UIView+Extention.h"
#import "UILabel+Extention.h"

#define PADDING 5

@interface ABServesCallView ()

@property(nonatomic,strong) ABServesCallButton *callButton;
@property(nonatomic,strong) UIImageView *servesIconView;    // 客服电话按钮
@property(nonatomic,strong) UILabel *serveLabel;    // 联系客服标签

@end

@implementation ABServesCallView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

/**
 设置UI
 */
- (void)setupUI {
 
    // 1. 添加控件
    [self addSubview:self.serveLabel];
    [self addSubview:self.servesIconView];
    [self addSubview:self.callButton];
    
    // 2. 布局
    [self.servesIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.serveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.servesIconView.mas_right).offset(PADDING);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serveLabel.mas_right).offset(PADDING);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    // 重新设置大小
    self.width = self.servesIconView.width + self.serveLabel.width + self.callButton.width + 10;
    self.height = self.callButton.height;
}

- (UILabel *)serveLabel {
    if (!_serveLabel) {
        _serveLabel = [UILabel labelWithTitle:@"联系客服" fontSize:14 color:CPColor(132, 132, 132)];
    }
    return _serveLabel;
}

- (UIImageView *)servesIconView {
    if (!_servesIconView) {
        _servesIconView = [UIImageView imageName:@"客服电话"];
    }
    return _servesIconView;
}

- (ABServesCallButton *)callButton {
    if (!_callButton) {
        _callButton = [ABServesCallButton servesTelNum:SERVICE_PHONE_NUM fontSize:14 FontColor:KColorBlue];
    }
    return _callButton;
}

@end
