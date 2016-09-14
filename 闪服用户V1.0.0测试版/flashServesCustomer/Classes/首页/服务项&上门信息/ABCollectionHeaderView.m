//
//  ABCollectionHeaderView.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABCollectionHeaderView.h"

@implementation ABCollectionHeaderView

- (void)awakeFromNib{
    NSInteger count = [_serverCountLabel.text integerValue];
    [_minusBtn setImage:[UIImage imageNamed:count<=1?@"-服务项grey":@"-服务项"] forState:UIControlStateNormal];
}

#pragma mark - Action
- (IBAction)minusAction:(id)sender {
    if ([_serverCountLabel.text integerValue]<=1) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(minusAction:)]) {
        NSInteger count = [_serverCountLabel.text integerValue] - 1;
        [_minusBtn setImage:[UIImage imageNamed:count<=1?@"-服务项grey":@"-服务项"] forState:UIControlStateNormal];
        _serverCountLabel.text=[NSString stringWithFormat:@"%ld",(long)count];
        [_delegate minusAction:count];
    }
}

- (IBAction)addAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(addAction:)]) {
        NSInteger count = [_serverCountLabel.text integerValue] + 1;
        [_minusBtn setImage:[UIImage imageNamed:count<=1?@"-服务项grey":@"-服务项"] forState:UIControlStateNormal];
        _serverCountLabel.text=[NSString stringWithFormat:@"%ld",(long)count];
        [_delegate addAction:count];
    }
}


@end
