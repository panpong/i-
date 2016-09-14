//
//  ABCityButton.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCityButton : UIButton

@property(nonatomic,strong) UIImageView *iconImageView;

+ (instancetype)cityButtonWithCityName:(NSString *)cityName iconImageName:(NSString *)iconImageName;

@end
