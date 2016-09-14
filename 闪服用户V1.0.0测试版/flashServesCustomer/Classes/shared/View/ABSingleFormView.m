//
//  ABSingleFormView.m
//  flashServesCustomer
//
//  Created by 002 on 16/6/3.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABSingleFormView.h"
#import "UIView+Extention.h"

#define PDDING_RIGHT_contentTextField 100 // contentTextField右边距

@interface ABSingleFormView ()

@property(nonatomic,strong) UILabel *descLabel;
@property(nonatomic,strong) HFHTextField *contentTextField;
@property(nonatomic,strong) HFHTextView *contentTextView;
@property(nonatomic,assign) CGFloat bottomSepWidth;
@property(nonatomic,assign) CGFloat topSepWidth;

@property(nonatomic,strong) UIView *topSepView;
@property(nonatomic,strong) UIView *bottomSepView;


@end

@implementation ABSingleFormView

- (instancetype)initWithFrmae:(CGRect)frame descLabel:(UILabel *)descLabel contentTextView:(HFHTextView *)contentTextView topSepWith:(CGFloat)topSepWidth bottomSepWith:(CGFloat)bottomSepWidth {
    if (self = [super initWithFrame:frame]) {
        self.bottomSepWidth = bottomSepWidth;
        self.topSepWidth = topSepWidth;
        if (descLabel) {
            self.descLabel = descLabel;
        }
        if (contentTextView) {
            self.contentTextView = contentTextView;
        }
    }
    [self setupUI];
    self.backgroundColor = KWhiteColor;
    return self;
}

- (instancetype)initWithFrmae:(CGRect)frame descLabel:(UILabel *)descLabel contentTextField:(HFHTextField *)contentTextField topSepWith:(CGFloat)topSepWidth bottomSepWith:(CGFloat)bottomSepWidth {
    self.bottomSepWidth = bottomSepWidth;
    self.topSepWidth = topSepWidth;
    if (self = [super initWithFrame:frame]) {
        if (descLabel) {
            self.descLabel = descLabel;
        }
        if (contentTextField) {
            self.contentTextField = contentTextField;
        }
    }
    [self setupUI];
    self.backgroundColor = KWhiteColor;
    return self;
}

+ (instancetype)singleFormViewWithFrame:(CGRect)frmae descLabel:(UILabel *)descLabel contentTextView:(HFHTextView *)contentTextView topSepWith:(CGFloat)topSepWidth bottomSepWith:(CGFloat)bottomSepWidth {
    ABSingleFormView *singleFormView = [[ABSingleFormView alloc] initWithFrmae:frmae descLabel:descLabel contentTextView:contentTextView topSepWith:topSepWidth bottomSepWith:bottomSepWidth];
    return singleFormView;
}

+ (instancetype)singleFormViewWithFrame:(CGRect)frmae descLabel:(UILabel *)descLabel contentTextField:(HFHTextField *)contentTextField topSepWith:(CGFloat)topSepWidth bottomSepWith:(CGFloat)bottomSepWidth {
    ABSingleFormView *singleFormView = [[ABSingleFormView alloc] initWithFrmae:frmae descLabel:descLabel contentTextField:contentTextField topSepWith:topSepWidth bottomSepWith:bottomSepWidth];
    return singleFormView;
}

#pragma mark - UI设置
- (void)setupUI {
    self.backgroundColor = KWhiteColor;
    
    // 1. 添加控件
    [self addSubview:self.descLabel];
    if (self.contentTextField) {
        [self addSubview:self.contentTextField];
    }
    if (self.contentTextView) {
        [self addSubview:self.contentTextView];
    }
    
    // 2. 布局
    self.descLabel.x = PADDING_30PX;
    self.descLabel.centerY = self.height / 2;
//    
//    // 2. 布局
//    self.descLabel.x = PADDING_30PX;
//    self.descLabel.centerY = self.height / 2;
//    
//    self.contentTextField.width = self.width - self.descLabel.right - 3 * PADDING_30PX;
//    self.contentTextField.height = self.height;
//    self.contentTextField.x = PDDING_RIGHT_contentTextField;
//    self.contentTextField.centerY = self.descLabel.centerY;
//    
//    self.contentTextView.width = self.width - self.descLabel.right - 3 * PADDING_30PX;
//    self.contentTextView.height = self.height;
//    self.contentTextView.x = PDDING_RIGHT_contentTextField;
//    self.contentTextView.centerY = self.descLabel.centerY;
//    
    // 分割线
    if (self.bottomSepWidth != 0 ) {
        UIView *bottomSep = [UIView sepView];
        [self addSubview:bottomSep];
        self.bottomSepView = bottomSep;
//        bottomSep.width = self.bottomSepWidth;
//        bottomSep.height = 1;
//        bottomSep.x = PADDING_30PX;
//        if (bottomSep.width == self.width) {
//            bottomSep.x = 0;
//        }
//        bottomSep.y = self.height - 0.5;
    }
    
    if (self.topSepWidth != 0) {
        UIView *topSep = [UIView sepView];
        [self addSubview:topSep];
        self.topSepView = topSep;
//        topSep.width = self.topSepWidth;
//        topSep.height = 1;
//        topSep.x = PADDING_30PX;
//        if (topSep.width == self.width) {
//            topSep.x = 0;
//        }
//        topSep.y = 0;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    // 1. 添加控件
//    [self addSubview:self.descLabel];
//    if (self.contentTextField) {
//        [self addSubview:self.contentTextField];
//    }
//    if (self.contentTextView) {
//        [self addSubview:self.contentTextView];
//    }
    
    self.contentTextField.width = self.width - self.descLabel.right - 3 * PADDING_30PX;
    self.contentTextField.height = self.height;
    self.contentTextField.x = PDDING_RIGHT_contentTextField;
    self.contentTextField.centerY = self.descLabel.centerY;
    
    self.contentTextView.width = self.width - self.descLabel.right - 3 * PADDING_30PX;
    self.contentTextView.height = self.height;
    self.contentTextView.x = PDDING_RIGHT_contentTextField;
    self.contentTextView.centerY = self.height / 2;
    
    // 分割线
    if (self.bottomSepWidth != 0 ) {
//        UIView *bottomSep = [UIView sepView];
//        [self addSubview:bottomSep];
        self.bottomSepView.width = self.bottomSepWidth;
        self.bottomSepView.height = 1;
        self.bottomSepView.x = PADDING_30PX;
        if (self.bottomSepView.width == self.width) {
            self.bottomSepView.x = 0;
        }
        self.bottomSepView.y = self.height - 0.5;
    }
    
    if (self.topSepWidth != 0) {
//        UIView *topSep = [UIView sepView];
//        [self addSubview:topSep];
        self.topSepView.width = self.topSepWidth;
        self.topSepView.height = 1;
        self.topSepView.x = PADDING_30PX;
        if (self.topSepView.width == self.width) {
            self.topSepView.x = 0;
        }
        self.topSepView.y = 0;
    }
   
}

- (NSString *)textValue {
    if (self.contentTextView) {
        _textValue = self.contentTextView.text;
    } else {
        _textValue = self.contentTextField.text;
    }
    return _textValue;
}

@end
