//
//  ABServicePackageTableViewCell.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/6/2.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABServicePackageTableViewCellDelegate <NSObject>

- (void)placeOrderWithDic:(NSDictionary *)dic;

@end

@interface ABServicePackageTableViewCell : UITableViewCell


@property(nonatomic,weak)id<ABServicePackageTableViewCellDelegate> delegate;

- (void)setDataWithDic:(NSDictionary *)dic;

@end
