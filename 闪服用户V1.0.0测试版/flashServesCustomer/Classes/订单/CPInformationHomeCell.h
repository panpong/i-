//
//  CPInformationHomeCell.h
//  flashServesCustomer
//
//  Created by yjin on 16/4/27.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPModalOrder.h"
@interface CPInformationHomeCell : UITableViewCell


+ (instancetype)CPInformationHomeCell
:(UITableView *)table;
@property (nonatomic, strong)CPModalOrder *modal ;
@property (nonatomic, weak)UINavigationController *nav;
@property (nonatomic, assign)CGFloat cellHeight;

@end
