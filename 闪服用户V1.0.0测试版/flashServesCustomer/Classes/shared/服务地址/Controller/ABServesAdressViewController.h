//
//  ABServesAdressViewController.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//  ‘服务地址’控制器

#import <UIKit/UIKit.h>
#import "ABServesAdressView.h"
@class ABServesAdressViewController,ABLocation;

@protocol ABServesAdressViewController <NSObject>

@optional
- (void)setAdressWithlocation:(ABLocation *)location;

@end

@interface ABServesAdressViewController : UIViewController

@property(nonatomic,weak) id<ABServesAdressViewController> servesAdressDelegate;
@property(nonatomic,strong) ABServesAdressView *servesAdressView;   // 服务视图

+ (instancetype)servesAdressViewControllerWithLocation:(ABLocation *)location;
+ (instancetype)servesAdressViewControllerWithLocation:(ABLocation *)location isNeededHistory:(BOOL)isNeededHistory;

- (void)confirmButtonDidClick;  // 确认按钮点击事件

@end
