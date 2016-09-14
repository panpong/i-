//
//  ABServesCall.m
//  flashServes
//
//  Created by 002 on 16/3/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServesCallButton.h"

@implementation ABServesCallButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)servesTelNum:(NSString *)num fontSize:(NSInteger)fontSize FontColor:(UIColor *)color {
    ABServesCallButton *call = [[self alloc] initWithservesTelNum:num fontSize:fontSize FontColor:color];
    return call;
}

- (instancetype)initWithservesTelNum:(NSString *)num fontSize:(NSInteger)fontSize FontColor:(UIColor *)color {
    
    self = [[ABServesCallButton alloc] init];
    
    if (num && ![@" " isEqualToString:num]) {
        [self setTitle:num forState:UIControlStateNormal];
    }
    
    if (fontSize > 0) {
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    
    if (color) {
        [self setTitleColor:color forState:UIControlStateNormal];
    }
    
    [self sizeToFit];
    
    // 监听
    [self addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)makeCall {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",SERVICE_PHONE_NUM];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
