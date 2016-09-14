//
//  ABCommonAdressCell.m
//  flashServes
//
//  Created by 002 on 16/3/29.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABCommonAdressCell.h"

@implementation ABCommonAdressCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)commonAdressCell:(UITableView *)table  {
    
    // 要和xib 中 cell 的reuse 一样
    static NSString * const reuseID = @"ReusableCellWithIdentifier";
    ABCommonAdressCell *cell = [table dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell)
    {
        [table registerNib:[UINib nibWithNibName:@"ABCommonAdressCell" bundle:nil] forCellReuseIdentifier:reuseID];
        
        cell = [table dequeueReusableCellWithIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.nameLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.adressLabel setTextColor:[UIColor lightGrayColor]];
        [cell.adressLabel setFont:[UIFont systemFontOfSize:13]];
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
