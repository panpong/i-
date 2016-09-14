//
//  ABResultViewController.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,KResultViewControllerType){
    KResultViewControllerTypePaySuccess = 0, // 支付成功
    KResultViewControllerTypeOrderSuccess = 1, // 服务包下单成功
    KResultViewControllerTypePayFail = 2, // 下单失败
    KResultViewControllerTypeGeneralOrderSuccess = 3 //普通下单成功
};

@interface ABResultViewController : UIViewController

@property (nonatomic,copy)NSString *engineerId;
@property (nonatomic,copy)NSString *orderID;

+ (ABResultViewController *)getResultViewController:(KResultViewControllerType) type;

@end
