//
//  ABPayTableViewCell.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABPayTableViewCell;

@protocol ABPayTableViewCellDelegate <NSObject>

- (void)selectionCell:(ABPayTableViewCell *)cell;

@end

@interface ABPayTableViewCell : UITableViewCell

@property(nonatomic,weak)__weak id<ABPayTableViewCellDelegate> delegate;

@property(nonatomic,assign)BOOL isSelected;

- (void)setDataWithDic:(NSDictionary *)dic;

@end
