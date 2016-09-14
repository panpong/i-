//
//  ABServiceAdressHistoryTableView.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/27.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABLocation.h"
@class ABServiceAdressHistoryTableView;

@protocol ABServiceAdressHistoryTableViewDelegate <NSObject>

@optional

/**
 选中历史记录后执行填充操作
 
 @param ServiceAdressHistoryTableView 历史记录tableview
 @param location                      选中记录的地址对象
 */
- (void)serviceAdressHistoryTableView:(ABServiceAdressHistoryTableView *)ServiceAdressHistoryTableView DidSelectLocation:(ABLocation *)location;

@end

@interface ABServiceAdressHistoryTableView : UITableView

// 代理 - 关于服务地址历史记录
@property(nonatomic,weak) id<ABServiceAdressHistoryTableViewDelegate> historyDelegate;
@property(nonatomic,strong) NSMutableArray<ABLocation *> *historyLocations;


+ (instancetype)serviceAdressHistoryTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
