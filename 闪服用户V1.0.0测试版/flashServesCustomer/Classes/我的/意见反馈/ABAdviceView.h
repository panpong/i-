//
//  ABAdviceView.h
//  LoveTourGuide
//
//  Created by 002 on 15/12/20.
//  Copyright © 2015年 fhhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABAdviceView : UIView

@property(nonatomic,strong) UITextField *adviceText;    // 意见反馈输入框

@property(nonatomic,strong) UILabel *desc;  // "请留下您的联系方式，感谢您的支持！"

@property(nonatomic,strong) UITextField *phoneText; // 手机号输入框

@end
