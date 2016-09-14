//
//  CPTextFieldWithMaxLength.m
//  flashServes
//
//  Created by yjin on 16/3/15.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPTextFieldWithMaxLength.h"

@interface CPTextFieldWithMaxLength()<UITextFieldDelegate>



@end


@implementation CPTextFieldWithMaxLength


- (instancetype)init {
    
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self];
     
        self.maxLength = 4;
    }
    return  self;
}

- (void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self];
    self.maxLength = 20;

    [super awakeFromNib];
    
}

- (void)textFieldDidChange:(NSNotification *)notification {
    
    if (self.text.length >= self.maxLength) {
        
        self.text = [self.text substringToIndex:self.maxLength];
        
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
