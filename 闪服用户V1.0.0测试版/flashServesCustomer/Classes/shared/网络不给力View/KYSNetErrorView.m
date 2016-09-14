//
//  KYSNetErrorView.m
//  flashServes
//
//  Created by Liu Zhao on 16/4/12.
//  Copyright © 2016年 002. All rights reserved.
//

#import "KYSNetErrorView.h"
#import "UIView+Extention.h"
#import "ABNetworkManager.h"
@interface KYSNetErrorView()

@property (nonatomic, strong)UILabel *netWorkText;
@property (nonatomic, strong)UIImageView *imageViewIcon;

@property (nonatomic, strong)UITapGestureRecognizer *tap;

@end


@implementation KYSNetErrorView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        NSLog(@"1:%@",NSStringFromCGRect(self.bounds));
        
        self.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0  blue:246/255.0  alpha:1];
        _tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:_tap];
    }
    return self;
}

- (void)tapGesture{
    if ([_delegate respondsToSelector:@selector(tapAction)]) {
        [_delegate tapAction];
        
        if (isConnectingNetwork) {
          [self hideHint];
        }
    }
}

#pragma mark 显示提示
- (void)showHint{
    [self showHintWithStringImage:@"ios_点击刷新"
                             text:@"网络不给力，请检查设置后再试"];
}

//网络不给力，请检查设置后再试
//ios_点击刷新
- (void)showHintWithStringImage:(NSString *)stringImage
                           text:(NSString *)text{
    
    [self.netWorkText setText:text];
    [self.netWorkText sizeToFit];
    
    [self.imageViewIcon setImage:[UIImage imageNamed:stringImage]];
    [self.imageViewIcon sizeToFit];
    
    [self setImageLayout];
    NSLog(@"2:%@",NSStringFromCGRect(self.imageViewIcon.frame));
    NSLog(@"3:%@",NSStringFromCGRect(self.netWorkText.frame));
}

- (void)hideHint{
    [self removeFromSuperview];
}

- (void)setImageLayout {
    
    
    CGFloat x = self.bounds.size.width * 0.5;
    CGFloat y = (self.bounds.size.height+49) * 0.3;
    
    self.imageViewIcon.centerX = x;
    self.imageViewIcon.y = y;
    
    self.netWorkText.centerX = x;
    self.netWorkText.y = CGRectGetMaxY(_imageViewIcon.frame) + 45;
}

#pragma mark 懒加载
- (UIImageView *)imageViewIcon {
    if (_imageViewIcon == nil) {
        _imageViewIcon = [[UIImageView alloc] init];
        [self addSubview:_imageViewIcon];
    }
    return _imageViewIcon;
    
}

- (UILabel *)netWorkText {
    if (_netWorkText == nil) {
        _netWorkText = [[UILabel alloc] init];
        [_netWorkText setTextColor:kColorTextGrey];
        [_netWorkText setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_netWorkText];
    }
    return _netWorkText;
}


@end
