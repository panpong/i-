//
//  ABSettingTableViewCell.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABSettingTableViewCell.h"

@interface ABSettingTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ABSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithDic:(NSDictionary *)dic{
    _titleLabel.text=dic[@"title"];
}

@end
