//
//  CPCPSimpleOrdereCell.h
//  flashServesCustomer
//
//  Created by yjin on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPModalOrder.h"
@interface CPSimpleOrdereCell : UITableViewCell

+ (instancetype)simpleOrdereCell:(UITableView *)table ;

@property (nonatomic, weak)UINavigationController *nav;
@property (nonatomic, strong)CPModalOrder *modal;


- (CGFloat)cellHeight;

@end
