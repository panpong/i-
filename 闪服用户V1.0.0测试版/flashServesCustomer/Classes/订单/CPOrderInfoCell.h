//
//  CPOrderInfoCell.h
//  flashServesCustomer
//
//  Created by yjin on 16/4/27.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPModalOrder.h"
@interface CPOrderInfoCell : UITableViewCell

+ (instancetype)orderInfoCell
:(UITableView *)table;



@property (nonatomic, strong)CPModalOrder *modal;
@end
