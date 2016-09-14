//
//  ABCommonServesCollectionViewCell.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABCommonServesCollectionViewCell.h"

@implementation ABCommonServesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconImageView.layer.cornerRadius = 10;
    _iconImageView.layer.masksToBounds = YES;
    // Initialization code
}

@end
