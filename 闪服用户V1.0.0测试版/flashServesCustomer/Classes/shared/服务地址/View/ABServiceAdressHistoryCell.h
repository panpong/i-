//
//  ABServiceAdressHistoryCell.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/27.
//  Copyright © 2016年 002. All rights reserved.
//  '服务地址历史记录的cell'

#import <UIKit/UIKit.h>

@interface ABServiceAdressHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

+ (instancetype)serviceAdressHistoryCell:(UITableView *)tableView;

@end
