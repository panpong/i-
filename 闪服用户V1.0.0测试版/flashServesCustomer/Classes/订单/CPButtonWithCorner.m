//
//  CPButtonWithCorner.m
//  testShangFu
//
//  Created by yjin on 16/3/14.
//  Copyright © 2016年 pchen. All rights reserved.
//

#import "CPButtonWithCorner.h"

@implementation CPButtonWithCorner

- (void)awakeFromNib {
    
    self.layer.cornerRadius = 5.0f;
    
    [super awakeFromNib];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
