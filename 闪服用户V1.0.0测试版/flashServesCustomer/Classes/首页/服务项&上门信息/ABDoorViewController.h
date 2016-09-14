//
//  ABDoorViewController.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABLocation.h"


@interface ABDoorViewController : UIViewController

@property(nonatomic,strong)NSMutableDictionary *orderDataDic;

//@property(nonatomic,strong) ABLocation *addressLocation; //缺少门牌号

+ (ABDoorViewController *)getDoorViewController;

@end
