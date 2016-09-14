//
//  ABProfileAreaViewController.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABProfileAreaViewController : UITableViewController

@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,assign)BOOL isUpdate;

+ (ABProfileAreaViewController *)getProfileAreaViewController;

@end
