//
//  CPViewOrderServer.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/27.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPViewOrderServer.h"
#define marginY 7
#define marginH 0

#import "UIView+Extention.h"
@implementation CPViewOrderServer



- (void)setModal:(CPModalOrder *)modal {
   
    if (_modal != nil) {
        
        return;
    }
    _modal = modal;
    NSArray *stringArray = _modal.services;
    int last = marginY;
    for (int i = 0; i < stringArray.count; i++) {
        
        last = [self addOneSeverView:last strign:stringArray[i]];
    }
    
}

- (CGFloat) addOneSeverView:(CGFloat)lastY strign:(NSDictionary *)text{
    

    float price =  (float)[text[@"price"] integerValue] / 100;
     NSString *strignPrice = [NSString stringWithFormat:@"%0.2f",price];
    
    UILabel *labelSeverName = [[UILabel alloc] init];
    labelSeverName.text = text[@"service_name"];
    labelSeverName.textColor = KColorTextBlack;
    labelSeverName.font = [UIFont systemFontOfSize:15];
    [labelSeverName sizeToFit];
    labelSeverName.x = 15;
    labelSeverName.y = marginH + lastY;
    labelSeverName.height = 28;
    [self addSubview:labelSeverName];
    
    UILabel *labelprice = [[UILabel alloc] init];
    labelprice.text = [NSString stringWithFormat:@"%@元*%@台",strignPrice,text[@"device_num"]];
    labelprice.textColor = KColorTextBlack;
    labelprice.font = [UIFont systemFontOfSize:15];
    [labelprice sizeToFit];

    labelprice.x = ScreenWidth - 15 - labelprice.width;
    labelprice.y = marginH + lastY;
    labelprice.height = 28;
    labelprice.textAlignment = NSTextAlignmentRight;
    [self addSubview:labelprice];
    
    labelSeverName.width = ScreenWidth - labelprice.width - 30 - 8;
    
    if ([text[@"price"] length ] == 0) {
        
        labelprice.hidden = YES;
        
    }else {
          labelprice.hidden = NO;
    }
    
    
    return CGRectGetMaxY(labelSeverName.frame);
}












/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
