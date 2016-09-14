//
//  ABCommonAdressCell.h
//  flashServes
//
//  Created by 002 on 16/3/29.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCommonAdressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

+ (instancetype)commonAdressCell:(UITableView *)table;

@end
