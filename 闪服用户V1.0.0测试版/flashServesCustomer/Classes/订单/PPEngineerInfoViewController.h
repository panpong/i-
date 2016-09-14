//
//  PPEngineerInfoViewController.h
//  flashServesCustomer
//
//  Created by Mr.P on 16/8/30.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPBaseViewController.h"

@interface PPEngineerInfoViewController : CPBaseViewController

@property (nonatomic,assign) NSInteger engineerId;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
