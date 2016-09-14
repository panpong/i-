//
//  ABCustomerPickerView.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIPickerView;

@protocol ABCustomerPickerViewDelegate <NSObject>

@optional
- (void)didSelectedCustomerPickerView:(NSString *)selectedStr;

@end

@interface ABCustomerPickerView : UIPickerView

@property(nonatomic,weak) id<ABCustomerPickerViewDelegate> customerPickerViewDelegate;

+ (instancetype)customerPickerViewWithArray:(NSArray *)array;

@end
