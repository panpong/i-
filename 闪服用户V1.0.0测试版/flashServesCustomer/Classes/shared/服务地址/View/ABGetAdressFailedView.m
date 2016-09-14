//
//  ABGetAdressFailedView.m
//  flashServes
//
//  Created by 002 on 16/4/6.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABGetAdressFailedView.h"
#import "UILabel+Extention.h"
#import "UIView+Extention.h"

@interface ABGetAdressFailedView ()

@property(nonatomic,strong) UILabel *label1;
@property(nonatomic,strong) UILabel *label2;
//@property(nonatomic,strong) UILabel *label3;

@end

@implementation ABGetAdressFailedView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+ (instancetype)getAdressFalied {
    
    ABGetAdressFailedView *view  = [[ABGetAdressFailedView alloc] init];
    view.width = ScreenWidth;
    view.backgroundColor = [UIColor whiteColor];
    [view layout];
    return view;
}

- (void)layout {
    
    // 1. 添加控件
    [self addSubview:self.label1];
    [self addSubview:self.label2];
//    [self addSubview:self.label3];
    
//    self.height = self.label1.height + self.label2.height + self.label3.height;
    self.height = self.label1.height + self.label2.height;
    
    // 2. 布局
    self.label1.centerX = self.centerX;
    self.label1.y = self.y;
    
    self.label2.centerX = self.centerX;
    self.label2.y = self.label1.bottom;
    
//    self.label3.centerX = self.centerX;
//    self.label3.y = self.label2.bottom;
    
}

- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [UILabel labelWithTitle:@"找不到地址?" fontSize:PADDING_30PX color:[UIColor lightGrayColor]];
    }
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [UILabel labelWithTitle:@"请尝试只输入小区、大厦名称。" fontSize:PADDING_30PX color:[UIColor lightGrayColor]];
    }
    return _label2;
}

//- (UILabel *)label3 {
//    if (!_label3) {
//        _label3 = [UILabel initWithTitle:@"详细地址（如门牌号）可稍后输入哦。" fontSize:PADDING_30PX color:[UIColor lightGrayColor]];
//    }
//    return _label3;
//}
@end
