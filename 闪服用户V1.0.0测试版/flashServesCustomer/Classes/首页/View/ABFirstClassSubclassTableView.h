//
//  ABFirstClassSubclassTableView.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABFirstClassSubclass.h"

@interface ABFirstClassSubclassTableView : UITableView


@property(nonatomic,weak) UIViewController *viewController; // 视图所属控制器
@property(nonatomic,strong) NSArray<ABFirstClassSubclass *> *firstClassSubclass;    // 数据来源

+ (instancetype)firstClassSubclassTableViewWithFrame:(CGRect)frame firstClassSubclass:(NSArray<ABFirstClassSubclass *> *)firstClassSubclass;

@end
