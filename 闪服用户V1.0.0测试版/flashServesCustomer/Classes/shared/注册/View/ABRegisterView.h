//
//  ABRegisterView.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/18.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABRegisterView;

@protocol ABRegisterViewDelegate <NSObject>

@optional
- (void)autoLoginRegisterView:(ABRegisterView *)registerView dictionary:(NSDictionary *)dict;

@end

@interface ABRegisterView : UIScrollView

@property(nonatomic,weak) UIViewController *viewController;
@property(nonatomic,weak) id<ABRegisterViewDelegate> registerViewDelegate;

// UI设置
- (void)setupUI;

@end
