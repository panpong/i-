//
//  CPSkillViewCell.h
//  flashServes
//
//  Created by yjin on 16/3/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSkillViewCell : UITableViewCell

+ (instancetype)skillViewCellWith:(UITableView *)tableView ;

@property  (nonatomic, strong)NSArray <NSDictionary *>* arrayKill;
@property (nonatomic, assign)CGFloat heightView;


@end
