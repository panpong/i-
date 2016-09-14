//
//  CPLineLabel.m
//  testShangFu
//
//  Created by yjin on 16/3/15.
//  Copyright © 2016年 pchen. All rights reserved.
//

#import "CPLineLabel.h"
#import "UIView+Extention.h"

@implementation CPLineLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
       [self setBackgroundColor:KColorLine];
        self.height = CPLineHeight;
    }
    return self;
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setBackgroundColor:KColorLine];
   
    NSArray *array =  [self constraints];
    
    
}




//- (void)layoutSubviews {
//
//    self.width = 1 / [UIScreen mainScreen].scale;
//    [super layoutSubviews];
//}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
