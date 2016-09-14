//
//  CPOrderDetailViewController.h
//  flashServesCustomer
//
//  Created by yjin on 16/4/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBaseViewController.h"
@interface CPOrderDetailViewController : CPBaseViewController

@property (nonatomic,strong)NSString *orderID;

@property (nonatomic, assign)BOOL isNeedRefreshList;


@end
