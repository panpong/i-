//
//  ABButtonLeftTitleRightImage.m
//  LoveTourGuide
//
//  Created by yjin on 15/11/10.
//  Copyright © 2015年 pchen. All rights reserved.
//

#import "ABButtonLeftTitleRightImage.h"
#import "UIView+Extention.h"

@implementation ABButtonLeftTitleRightImage

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat imageX ;
    self.titleLabel.x = 0;
    imageX = self.titleLabel.width + 4;
    self.imageView.x = imageX;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
