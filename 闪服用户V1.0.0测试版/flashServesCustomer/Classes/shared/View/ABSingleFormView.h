//
//  ABSingleFormView.h
//  flashServesCustomer
//
//  Created by 002 on 16/6/3.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFHTextField.h"
#import "HFHTextView.h"

@interface ABSingleFormView : UIView

@property (nonatomic, copy) NSString *textValue;

+ (instancetype)singleFormViewWithFrame:(CGRect)frmae descLabel:(UILabel *)descLabel contentTextView:(HFHTextView *)contentTextView topSepWith:(CGFloat)TopSepWith bottomSepWith:(CGFloat)bottomSepWidth;

+ (instancetype)singleFormViewWithFrame:(CGRect)frmae descLabel:(UILabel *)descLabel contentTextField:(HFHTextField *)contentTextField topSepWith:(CGFloat)TopSepWith bottomSepWith:(CGFloat)bottomSepWidth;

@end
