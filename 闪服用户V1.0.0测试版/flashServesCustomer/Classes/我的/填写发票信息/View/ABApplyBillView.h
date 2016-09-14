//
//  ABApplyBillView.h
//  flashServesCustomer
//
//  Created by 002 on 16/6/3.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABApplyBillView : UIScrollView

@property(nonatomic,weak) UIViewController *viewController;

+ (instancetype)applyBillViewWithFrame:(CGRect)frame leftMoney:(NSString *)leftMoney lastBillTitle:(NSString *)lastBillTitle;

@end
