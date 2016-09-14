//
//  ABPayViewController.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABPayViewController : UIViewController

@property (nonatomic,copy)NSString *engineerId;
@property (nonatomic,copy)NSString *orderID;
@property (nonatomic,copy)NSString *orderPrice;

+ (ABPayViewController *)getPayViewController;


@end
