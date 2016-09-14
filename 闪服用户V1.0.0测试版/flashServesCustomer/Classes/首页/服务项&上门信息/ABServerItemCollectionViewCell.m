//
//  ABServerItemCollectionViewCell.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/23.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServerItemCollectionViewCell.h"
#import "ABCollectionConfig.h"

@implementation ABServerItemCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _titleLabel.layer.borderWidth=1.0;
    _titleLabel.layer.borderColor=[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1].CGColor;
    _titleLabel.layer.cornerRadius=2.0;
    _titleLabel.layer.masksToBounds=YES;
}

- (void)setTitle:(NSString *)title{
    _titleLabel.font=[UIFont systemFontOfSize:KYS_SCREEN_WIDTH>320?14:13];
    _titleLabel.text=title;
}

- (void)setHasSelected:(BOOL)hasSelected{
    if (hasSelected) {
        _titleLabel.backgroundColor=[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1];
        _titleLabel.textColor=[UIColor whiteColor];
    }else{
        _titleLabel.backgroundColor=[UIColor whiteColor];
        _titleLabel.textColor=[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1];
    }
    _hasSelected=hasSelected;
}

@end
