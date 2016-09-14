//
//  ABSumitServicePackageViewController.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/6/2.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOTIFICATION_PACKAGE_UPDATE @"kys.package.update"

@interface ABSumitServicePackageViewController : UIViewController

@property(nonatomic,strong)NSMutableDictionary *orderDataDic;

+ (ABSumitServicePackageViewController *)getSumitServicePackageViewController;

@end
