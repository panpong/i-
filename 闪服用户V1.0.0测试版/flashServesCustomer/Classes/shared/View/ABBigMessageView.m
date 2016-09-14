//
//  ABBigMessageView.m
//  flashServes
//
//  Created by 002 on 16/6/2.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABBigMessageView.h"
#import "UIView+Extention.h"

#define PADDING_TOP_textView 110   // textView的上间距
#define PADDING_LEFT_textView 10   // textView的左间距

@interface ABBigMessageView ()

@property(nonatomic,strong) UITextView *textView;

@property(nonatomic,strong) UITapGestureRecognizer *tap;

@property (nonatomic, copy) NSMutableAttributedString *message;

@property(nonatomic,strong) UIView *resignView; // 退出View


@end

@implementation ABBigMessageView

- (instancetype)initWithFrame:(CGRect)frame message:(NSMutableAttributedString *)message {
    if (self = [super initWithFrame:frame]) {
        self.message = message;
        [self setupUI];
    }
    return self;
}

+ (instancetype)bigMessageViewWithFrame:(CGRect)frame message:(NSMutableAttributedString *)message {
    ABBigMessageView *bigMessageView = [[ABBigMessageView alloc] initWithFrame:frame message:message];
    return bigMessageView;
}

#pragma mark - UI设置
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    self.bounds = [UIApplication sharedApplication].keyWindow.bounds;
    
    [self addSubview:self.textView];
    [self addSubview:self.resignView];
    self.textView.x = PADDING_LEFT_textView;
    self.textView.y = PADDING_TOP_textView;
}

// 从Window中移除
- (void)resignWithdrawRuleView {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)show {
    // 1. 添加控件
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark - 懒加载
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.contentInset = UIEdgeInsetsZero;
        _textView.editable = false;
        _textView.width = ScreenWidth - 2 * PADDING_LEFT_textView;               
        
        _textView.attributedText = self.message;
        _textView.height = ScreenHeight;
    }
    return _textView;
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignWithdrawRuleView)];
    }
    return _tap;
}

- (UIView *)resignView {
    if (!_resignView) {
        _resignView = [[UIView alloc] initWithFrame:self.frame];
        _resignView.backgroundColor = [UIColor clearColor];
        [_resignView addGestureRecognizer:self.tap];
    }
    return _resignView;
}

@end
