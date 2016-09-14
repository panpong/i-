//
//  CPHeadSectionView.h
//  flashServesCustomer
//
//  Created by yjin on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPHeadSectionView : UIView

+ (instancetype)headSectionView ;
- (void)settingHeadSection:(NSString *)imageString title:(NSString *)title;
- (void)settingHeadSection:(NSString *)imageString title:(NSString *)title text2:(NSString *)text2;
@end
