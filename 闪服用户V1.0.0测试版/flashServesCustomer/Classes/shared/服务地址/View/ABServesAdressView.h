//
//  ABServesAdressView.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFHTextField.h"
#import "ABServiceAdressHistoryTableView.h"
@class ABLocation;
@class ABServesAdressViewController;

@interface ABServesAdressView : UIView


@property(nonatomic,strong) HFHTextField *adressTextField; // 小区输入栏
@property(nonatomic,strong) HFHTextField *adressDetailTextField; // 详细地址输入栏
@property(nonatomic,strong) UIButton *adressButton; // 和'adressTextField'大小位置一样的按钮，目的是点击后跳转到下一个界面
@property(nonatomic,strong) UIButton *confirmButton;    // ‘确认’按钮
@property(nonatomic,strong) ABLocation *location;
@property(nonatomic,assign) BOOL isNeededHistory;   // 是否需要历史记录
@property(nonatomic,strong) ABServiceAdressHistoryTableView *serviceAdressHistoryTableView; // 历史记录tableview
@property(nonatomic,weak) ABServesAdressViewController *viewController; // 视图所属的控制器
@property(nonatomic,strong) NSMutableArray<ABLocation *> *historyLocations;

+ (instancetype)servesAdressViewWithFrame:(CGRect)frame isNeedHistory:(BOOL)isNeedHistory;

@end
