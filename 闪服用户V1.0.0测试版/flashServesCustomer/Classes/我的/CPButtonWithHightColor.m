//
//  CPButtonWithHightColor.m
//  flashServes
//
//  Created by yjin on 16/5/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPButtonWithHightColor.h"

@interface CPButtonWithHightColor()

@property (nonatomic, strong)UIColor *backerColorTem;

@end

@implementation CPButtonWithHightColor


- (void)setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    
    if (_backerColorTem == nil) {
        
        _backerColorTem = [self backgroundColor] == nil ? [UIColor clearColor] : self.backgroundColor;
    }
    if (highlighted ) {
        
        if (_typeBackGroundColor == BackGroundColorBlue) {
            
            self.backgroundColor = CPColor(0, 143, 208);
        }else  {
            
            self.backgroundColor = CPColor(240, 240, 240);
        }
    
    }else {
        
        self.backgroundColor = [_backerColorTem copy];
       
    }
}

- (BOOL) isTheSameColor2:(UIColor*)color1 anotherColor:(UIColor*)color2
{
         if (CGColorEqualToColor(color1.CGColor, color2.CGColor)) {
                return YES;
            }
         else {
                  return NO;
            }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
