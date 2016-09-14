//
//  ABCityButton.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABCityButton.h"
#import "UIView+Extention.h"

@implementation ABCityButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCityName:(NSString *)cityName iconImageName:(NSString *)iconImageName {
    self = [super init];
    if (self) {
        [self setTitle:cityName forState:UIControlStateNormal];
        if (iconImageName && ![@"" isEqualToString:iconImageName]) {
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconImageName]];
        [self addSubview:_iconImageView];
        }                
        [self sizeToFit];
    }
    return self;
}

+ (instancetype)cityButtonWithCityName:(NSString *)cityName iconImageName:(NSString *)iconImageName {
    ABCityButton *cityButton = [[ABCityButton alloc] initWithCityName:cityName iconImageName:iconImageName];
    return cityButton;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
//    CGFloat imageX ;
//    self.titleLabel.x = 0;
//    imageX = self.titleLabel.width + 4;
//    self.imageView.x = imageX;
    self.height = 34;
    self.titleLabel.x = 0;
    self.titleLabel.centerY = self.height / 2;
    
    // 添加图片控件 - 不用系统是因为需要旋转图片
    self.iconImageView.x = self.titleLabel.right + 4;
    self.iconImageView.centerY = self.titleLabel.centerY;
    
    self.width = self.titleLabel.width + self.iconImageView.width + 4;
}

@end
