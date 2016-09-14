//
//  ABNewFeatureViewCell.m
//  LoveTourGuide
//
//  Created by 002 on 16/1/6.
//  Copyright © 2016年 fhhe. All rights reserved.
//

#import "ABNewFeatureViewCell.h"
#import "UIButton+Extention.h"
#import "Masonry.h"

@interface ABNewFeatureViewCell ()

{
    CGFloat _righMargin;
    CGFloat _topMargin;
    NSString *_jumpButtonName;
    NSString *_startExperienceName;
    CGFloat _mutiple;
}

@property(nonatomic,assign) NSInteger imageIndex;   // 引导图索引
@property(nonatomic,strong) UIImageView *iconView;  // 引导图
@property(nonatomic,strong) UIButton *startButton;  // 开始体验按钮
@property(nonatomic,strong) UIButton *jumpButton;   // ‘跳过’

@end

@implementation ABNewFeatureViewCell

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

#pragma mark - 设置界面
- (void)setupUI {
    
    // 1. 添加控件
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.startButton];
    [self.contentView addSubview:self.jumpButton];
    
    self.startButton.hidden = YES;
    
    // 2. 布局
    // 2.1) 引导图
    self.iconView.frame = self.contentView.bounds;
    
    // 2.2) '开始体验' 按钮
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom).multipliedBy(_mutiple);
    }];
    
    // 2.3) ‘跳过’ 按钮
    [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(_topMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-_righMargin);
        NSLog(@"_righMargin%f",_righMargin);
    }];
    
    // 3. 监听方法 - ‘跳过’ 和 ‘开始体验’ 都是跳到主控制器
    [self.startButton addTarget:self action:@selector(startButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.jumpButton addTarget:self action:@selector(startButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 开始按钮监听方法
- (void)startButtonDidClick {
    ABLog(@"切换根控制器");
    // 发通知切换根控制器
    [[NSNotificationCenter defaultCenter] postNotificationName:ABSwitchRootViewControllerNotification object:@"ABHomeViewController"];
}

#pragma mark - 显示按钮动画
- (void)showButtonAnim:(BOOL)isShown {
    
    // 显示按钮
    self.jumpButton.hidden = YES;
    self.startButton.hidden = NO;
    
    if (isShown) {
        self.startButton.transform = CGAffineTransformMakeScale(0.35, 0.35);
        self.startButton.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:1.6     // 动画时长
                              delay:0       // 延时时间
             usingSpringWithDamping:0.6     // 弹力系数，0~1，越小越弹
              initialSpringVelocity:10      // 重力加速度，模拟重力加速度
                            options:0       // 动画选项
                         animations:^{
                             
                             self.startButton.transform = CGAffineTransformIdentity; // 将transform属性还原到动画之前状态
                         }
                         completion:^(BOOL finished) {
                             self.startButton.userInteractionEnabled = YES;
                         }];
    }
}

#pragma mark - 懒加载
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithTitle:nil color:KWhiteColor fontSize:0 backImageName:_startExperienceName];
        [_startButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlight",_startExperienceName]] forState:UIControlStateHighlighted];
    }
    return _startButton;
}

- (UIButton *)jumpButton {
    if (!_jumpButton) {
        _jumpButton = [UIButton buttonWithTitle:nil color:KWhiteColor fontSize:0 backImageName:_jumpButtonName];
    }
    return _jumpButton;
}

#pragma mark - setter
- (void)setImageIndex:(NSInteger)imageIndex images:(NSArray<NSString *> *)images {
    _imageIndex = imageIndex;
    self.iconView.image = [UIImage imageNamed:images[imageIndex]];
    // 显示跳过按钮
    self.jumpButton.hidden = YES;
    if (imageIndex == (images.count - 1)) {
        self.jumpButton.hidden = YES;
    }
    // 隐藏按钮
    self.startButton.hidden = YES;
}

- (void)setJumpButton:(NSString *)name multipliedByBottom:(CGFloat)mutiple {
    if (_mutiple) {
        _mutiple = mutiple;
    } else {
        _mutiple = 0.9;
    }
    if (name) {
        _jumpButtonName = name;
    }
}

- (void)setStartExperienceButton:(NSString *)name rightMargin:(CGFloat)rightMargin topMargin:(CGFloat)topMargin {
    if (name) {
        _startExperienceName = name;
    }
    if (rightMargin) {
        _righMargin = rightMargin;
    } else {
        _righMargin = 10;
    }
    if (topMargin) {
        _topMargin = topMargin;
    } else {
        _topMargin = 15;
    }
}

@end
