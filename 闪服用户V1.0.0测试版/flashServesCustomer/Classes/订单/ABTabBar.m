//
//  ABTabBar.m
//  TransportationCommittee
//
//  Created by yjin on 15/7/6.
//  Copyright (c) 2015年 pchen. All rights reserved.
//

#import "ABTabBar.h"
#import "UIView+Extention.h"
#import "CPLineLabel.h"

@interface ABTabBar()
// 底部的一条线
@property (nonatomic, strong)UIImageView *imageViewLine;

@property (nonatomic,strong)UILabel *labelLine;
@end;

@implementation ABTabBar


- (void)setArrayTab:(NSArray *)arrayTab {
    _arrayTab = arrayTab;
    self.backgroundColor = [UIColor whiteColor];
    self.imageViewLine = [[UIImageView alloc] init];
    for (int i = 0; i < arrayTab.count; i++) {
        
        NSString *title = arrayTab[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        [button setTitle:title forState:UIControlStateNormal];
        if (i == 0) {
            
            [button setTitleColor:KColorBlue forState:UIControlStateNormal];
            
            _imageViewLine.width = [self ImageWidth:button];
        }else {
            
            [button setTitleColor:kColorTextGrey forState:UIControlStateNormal];
        }
        
        [self addSubview:button];
    }
    
    _labelLine = [[UILabel alloc] init];
    [_labelLine setBackgroundColor:KColorLine];
    [self addSubview:_labelLine];
    
    
    [self.imageViewLine setBackgroundColor:KColorBlue];

    
    _imageViewLine.height = 2;
    
    [self addSubview:self.imageViewLine];
}

- (void)buttonClick:(UIButton *)button {
    
    [self cutViewWithIndex:button.tag];
    if ([self.delegate respondsToSelector:@selector(tabClick:withIndex:)]) {
        [self.delegate tabClick:self withIndex:button.tag];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    

     _labelLine.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, CPLineHeight);
    if (self.arrayTab.count == 0 )
    {
        return;
    }
    CGFloat buttonWidth =  [UIScreen mainScreen].bounds.size.width / self.arrayTab.count;
    
    for (int i = 0 ; i < self.subviews.count; i++) {
        
        UIButton *button  = self.subviews[i];
        
        if (![button isKindOfClass:[UIButton class]]) { // 不是button类的时候
            
            return;
        }
        
        button.x = i * buttonWidth;
        button.y = 0 ;
        button.width = buttonWidth;
        button.height = self.bounds.size.height;
        
        if (i == 0) {
            
            self.imageViewLine.centerX = button.centerX;
            self.imageViewLine.y = button.height - 3;
            
        }
    }
    
}

- (void)cutViewWithIndex:(NSInteger)index {
    
   
    if (self.arrayTab.count == 0 )
    {
        return;
    }

    
    for (int i = 0 ; i < self.subviews.count; i++) {
        
        UIButton *button  = self.subviews[i];
        
        if (![button isKindOfClass:[UIButton class]]) { // 不是button类的时候
            
            continue;
        }
        [button setTitleColor:kColorTextGrey forState:UIControlStateNormal];
    }
    
    UIButton *button = self.subviews[index];
    [button setTitleColor:KColorBlue forState:UIControlStateNormal];

    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.imageViewLine.centerX = button.centerX;
     
    }];

}

- (CGFloat)ImageWidth:(UIButton *)button {
    
    CGSize size = CGSizeMake(ScreenWidth - 39 - 15, 50);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:button.titleLabel.font forKey:NSFontAttributeName];
    
    CGRect rect = [button.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    ABLog(@"imageWidht %f",rect.size.width + 20);
    return rect.size.width + 20;

    
}




@end
