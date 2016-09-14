//
//  ABServiceAdressHistoryCell.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/27.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServiceAdressHistoryCell.h"

@implementation ABServiceAdressHistoryCell

// 要和xib 中 cell 的reuse 一样
static NSString * const reuseID = @"serviceAdressHistoryCellReuseId";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)serviceAdressHistoryCell:(UITableView *)tableView {
    
    ABServiceAdressHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ABServiceAdressHistoryCell" bundle:nil] forCellReuseIdentifier:reuseID];
        
        cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.nameLabel setFont:[UIFont systemFontOfSize:15]];
//        [cell.adressLabel setTextColor:kColorTextGrey];
//        [cell.adressLabel setFont:[UIFont systemFontOfSize:13]];
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
