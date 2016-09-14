//
//  ABAppraiseViewController.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABAppraiseViewController : UIViewController

@property(nonatomic,copy)NSString *engineerId;
@property(nonatomic,copy)NSString *orderId;

+ (ABAppraiseViewController *)getAppraiseViewController;

@end
