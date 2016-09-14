//
//  ABUpdatePasswordViewController.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABUpdatePasswordViewController : UIViewController

@property(nonatomic,strong)NSDictionary *dataDic;

+ (ABUpdatePasswordViewController *)getUpdatePasswordViewController;

@end
