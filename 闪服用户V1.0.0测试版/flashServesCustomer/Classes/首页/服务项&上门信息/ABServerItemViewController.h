//
//  ABServerItemViewController.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/23.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABFirstClassServes;

@interface ABServerItemViewController : UIViewController

@property(nonatomic,strong) ABFirstClassServes *firstClassServes;

+ (ABServerItemViewController *)getServerItemViewController;

@end
