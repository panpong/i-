//
//  ABTabBar.h
//  TransportationCommittee
//
//  Created by yjin on 15/7/6.
//  Copyright (c) 2015年 pchen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABTabBar;
@protocol tabBarProtocol

- (void)tabClick:(ABTabBar *)tabBar withIndex:(NSInteger)index;


@end

@interface ABTabBar : UIView

@property (nonatomic, strong)NSArray *arrayTab;

- (void)cutViewWithIndex:(NSInteger )index;


@property (nonatomic, weak)id delegate;




@end
