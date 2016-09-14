//
//  CPOrderQustionImageCell.h
//  flashServesCustomer
//
//  Created by yjin on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPModalOrder.h"
@interface CPOrderQustionImageCell : UITableViewCell

@property (nonatomic, strong)CPModalOrder *modal ;

+ (instancetype)CPOrderQustionImageCell
:(UITableView *)table;

- (CGFloat)cellHeight;

@end
