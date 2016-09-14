//
//  CPAcceptBillCell.h
//  flashServesCustomer
//
//  Created by yjin on 16/6/2.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPAcceptBillCell : UITableViewCell

@property (nonatomic, strong)NSDictionary *modal;

@property (nonatomic,assign)BOOL isLastCell;
+ (instancetype)acceptBillCell:(UITableView *)table;


@end
