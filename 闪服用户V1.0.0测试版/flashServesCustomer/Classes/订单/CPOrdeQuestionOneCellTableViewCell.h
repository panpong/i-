//
//  CPOrdeQuestionOneCellTableViewCell.h
//  flashServesCustomer
//
//  Created by yjin on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPModalOrder.h"
@interface CPOrdeQuestionOneCellTableViewCell : UITableViewCell

+ (instancetype)OrdeQuestionOneCellTableViewCell
:(UITableView *)table;

@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic,strong)CPModalOrder *modal ;




@end
