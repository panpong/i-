//
//  ABTabBarViewController.h
//  TransportationCommittee
//
//  Created by yjin on 15/7/6.
//  Copyright (c) 2015年 pchen. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *notificationNextScrollerVC ;
extern NSString *notificationNextScrollerVCKey ;

@class ABTabBar;
@interface ABTabBarViewController : UIViewController
@property (nonatomic ,assign)NSInteger currentIndex;
@property (strong, nonatomic)  ABTabBar *tabBar;
- (instancetype)initWithArrayChilds:(NSArray *)childs tabBars:(NSArray *)tabBars;
- (void)tabClick:(ABTabBar *)tabBar withIndex:(NSInteger)index;
@end
