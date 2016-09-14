//
//  CPUpdateOrderView.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPUpdateOrderView.h"
#import "UIView+Extention.h"
#define marginY 15
#define marginH 8
#import "ABNetworkManager.h"
#import "CustomToast.h"

@interface CPUpdateOrderView ()<UIAlertViewDelegate>

// 修改服务View
@property (nonatomic, strong)UIView *updateSeverView;

// 修改时间View
@property (nonatomic, strong)UIView *updateSeverTimeView;
// 时间， 服务都更改了
@property (nonatomic, strong)UIView *allUpdateSeverView;


@property (nonatomic, assign)int servicePrice;



@end


@implementation CPUpdateOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
    
    
}

- (void)awakeFromNib {
    
     self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setModal:(CPModalOrder *)modal {
    
    _servicePrice = 0;
    _modal = modal;
    for (UIView *view in _updateSeverTimeView.subviews) {
        
        [view removeFromSuperview];
    }
    
    for (UIView *view in _updateSeverView.subviews) {
        
        [view removeFromSuperview];
    }
    
    for (UIView *view  in _allUpdateSeverView.subviews) {
        [view removeFromSuperview];
    }
    
    
    
    if ([modal stateUpdate] == UpdetateStateNone) {
        
        return;
    }
    
    if ([modal stateUpdate] == UpdetateStateOnlyTime) {
    
         [self addUpdateSeverTime: _modal.modify_servicetime];
        
    }else if ([modal stateUpdate] == UpdetateStateOnlySever) {
        
        [self addSeverViewItemStringArray:_modal.modify_services];

        
    }else {
        
        [self addAllSeverViewStringArray:_modal.modify_services Time:_modal.modify_servicetime];

    }
}

#pragma mark - 修改服务时间View
- (void)addUpdateSeverTime:(NSString *)time {
    
    UIView *updateSeverTimeView = [[UIView alloc] init];
    [self addSubview:updateSeverTimeView];
    [updateSeverTimeView setBackgroundColor:kColorBackground];
    _updateSeverTimeView = updateSeverTimeView;
    
    
    CGFloat severViewTimeY = CGRectGetMaxY(_updateSeverView.frame ) + 6;
    if ([_modal stateUpdate] == UpdetateStateOnlyTime) {
        severViewTimeY = 0;
    }
    
    _updateSeverTimeView.frame = CGRectMake(15, severViewTimeY, ScreenWidth - 30, updateTimeCellHeight );
 
    UILabel   *labelHead = [self labelTint: @"修改后服务时间为:"];
    labelHead.x = 8;
    labelHead.y = marginY;
    [_updateSeverTimeView addSubview:labelHead];
    
    UILabel   *labelTime = [[UILabel alloc] init];
    labelTime.text = [_modal stringTimeWithhengFormat:time];
    labelTime.textColor = KColorTextBlack;
    labelTime.font = [UIFont systemFontOfSize:14];
    [labelTime sizeToFit];
    labelTime.x = 8;
    labelTime.y = CGRectGetMaxY(labelHead.frame) + marginH;
    [_updateSeverTimeView addSubview:labelTime];
    
    UIButton *butto = [self buttonWith:_updateSeverTimeView];
    butto.y = 20;
    [butto addTarget:self action:@selector(buttonUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
    
  

}

#pragma mark - 点击更新按钮
- (void)updateSeverTime:(UIButton *)button {
    
    if (button.tag == 0) { // 表示更新服务

        
    }else { // 表示更新时间
    
        
    }
}


- (UIButton *)buttonWith:(UIView *)view  {
    
    UIButton *butto = [UIButton buttonWithType:UIButtonTypeCustom];
    [butto setTitle:@"确认修改" forState:UIControlStateNormal];
    butto.layer.borderColor = KColorBlue.CGColor;
    butto.layer.borderWidth = 1;
    [butto setTitleColor:KColorBlue forState:UIControlStateNormal];
    butto.titleLabel.font = [UIFont systemFontOfSize:14];
    [butto addTarget:self action:@selector(updateSeverTime:) forControlEvents:UIControlEventTouchUpInside];
    
    if (iPhone4 || iPhone5) {
        
         butto.width = 86;
    }else {
        butto.width = 90;
    }
 
    butto.height = 35;
    butto.x = ScreenWidth - 30 - butto.width - 8;
    [view addSubview:butto];
    
    if ([view isEqual:_updateSeverTimeView]) {
        
        butto.tag = 1; // 表示更新时间
    }else {
        
        butto.tag = 0; // 表示更新服务
        
    }
    return butto;
    
}


- (UIView *)allUpdateSeverView {
    
    if (_allUpdateSeverView == nil) {
        
        UIView *updateSeverView = [[UIView alloc] init];
        [self addSubview:updateSeverView];
        [updateSeverView setBackgroundColor:kColorBackground];
        _allUpdateSeverView = updateSeverView;
    }
    return _allUpdateSeverView;
    
}


- (void)addAllSeverViewStringArray:(NSArray *)stringArray Time:(NSString *)time {
    
    UILabel *labelHead = [self labelTint:@"修改后服务项为:"];
    labelHead.x = 8;
    labelHead.y = marginY;
    [self.allUpdateSeverView addSubview:labelHead];
    
    int last = CGRectGetMaxY(labelHead.frame);
    for (int i = 0; i < stringArray.count; i++) {
        
        last = [self addOneSeverView:last strign:stringArray[i] view:_allUpdateSeverView];
    }
    
    UILabel   *labelHeadTime = [self labelTint: @"修改后服务时间为:"];
    labelHeadTime.x = 8;
    labelHeadTime.y = last + marginH;
    [_allUpdateSeverView addSubview:labelHeadTime];
    
    UILabel   *labelTime = [[UILabel alloc] init];
    labelTime.text = [_modal   stringTimeWithhengFormat:time];
    labelTime.textColor = KColorTextBlack;
    labelTime.font = [UIFont systemFontOfSize:14];
    [labelTime sizeToFit];
    labelTime.x = 8;
    labelTime.y = CGRectGetMaxY(labelHeadTime.frame) + marginH;
    [_allUpdateSeverView addSubview:labelTime];
    

    CGFloat timeY = CGRectGetMaxY(labelTime.frame) + marginH;
    UIView *orderPriveView = [[UIView alloc] init];
    orderPriveView.frame = CGRectMake(0, timeY, ScreenWidth - 30, 59);
    orderPriveView.backgroundColor = kColorBackground;
    [_allUpdateSeverView addSubview:orderPriveView];
    
    
    UIImageView *imageLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的订单-修改服务项-虚线"]];
    imageLine.frame = CGRectMake(0, 0, orderPriveView.width, 1);
    [orderPriveView addSubview:imageLine];
    
    
    UILabel *labelOrder = [self labelTint:@"订单总价"];
    labelOrder.frame = CGRectMake(8, 0, labelOrder.width, 59);
    [orderPriveView addSubview:labelOrder];
    
    
    UILabel *labelPrice = [[UILabel alloc] init];
    NSString *stringPrice =  [CPModalOrder stringPriceWithDot:YES price:[NSString stringWithFormat:@"%d",_servicePrice]];
    labelPrice.text = [NSString stringWithFormat:@"￥%@", stringPrice];
    labelPrice.textColor = KColorTextBlack;
    labelPrice.font = [UIFont boldSystemFontOfSize:18];
    
    [labelPrice sizeToFit];
    int xlabelPrice = CGRectGetMaxX(labelOrder.frame) + 8;
    labelPrice.frame = CGRectMake(xlabelPrice, 0, labelPrice.width + 8, 59);
    [orderPriveView addSubview:labelPrice];
    
    UIButton *butto = [self buttonWith:orderPriveView];
    butto.centerY = 30;
    [butto addTarget:self action:@selector(buttonUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat height = CGRectGetMaxY(orderPriveView.frame);
    _allUpdateSeverView.frame = CGRectMake(15, 0, ScreenWidth - 30, height);
    

}



- (void)addSeverViewItemStringArray:(NSArray *)stringArray{

    UIView *updateSeverView = [[UIView alloc] init];
    [self addSubview:updateSeverView];
    [updateSeverView setBackgroundColor:kColorBackground];
    _updateSeverView = updateSeverView;
    
    UILabel   *labelHead = [self labelTint:@"修改后服务项为:"];
    labelHead.x = 8;
    labelHead.y = marginY;
    [_updateSeverView addSubview:labelHead];
    
    int last = CGRectGetMaxY(labelHead.frame);
    for (int i = 0; i < stringArray.count; i++) {

         last = [self addOneSeverView:last strign:stringArray[i]];
    }
    
    
    UIView *orderPriveView = [[UIView alloc] init];
    orderPriveView.frame = CGRectMake(0, last + marginY, ScreenWidth - 30, 59);
    orderPriveView.backgroundColor = kColorBackground;
    [_updateSeverView addSubview:orderPriveView];
    
    UIImageView *imageLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的订单-修改服务项-虚线"]];
    imageLine.frame = CGRectMake(0, 0, orderPriveView.width, 1);
    [orderPriveView addSubview:imageLine];
  
    
    UILabel *labelOrder = [self labelTint:@"订单总价"];
    labelOrder.frame = CGRectMake(8, 0, labelOrder.width, 59);
    [orderPriveView addSubview:labelOrder];
    

    UILabel *labelPrice = [[UILabel alloc] init];
    NSString *stringPrice =  [CPModalOrder stringPriceWithDot:YES price:[NSString stringWithFormat:@"%d",_servicePrice]];
    labelPrice.text = [NSString stringWithFormat:@"￥%@", stringPrice];
    labelPrice.textColor = KColorTextBlack;
    labelPrice.font = [UIFont boldSystemFontOfSize:18];
    
    [labelPrice sizeToFit];
    int xlabelPrice = CGRectGetMaxX(labelOrder.frame) + 8;
    labelPrice.frame = CGRectMake(xlabelPrice, 0, labelPrice.width + 8, 59);
    [orderPriveView addSubview:labelPrice];
  
    UIButton *butto = [self buttonWith:orderPriveView];
    butto.centerY = 30;
    [butto addTarget:self action:@selector(buttonUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    CGFloat height = CGRectGetMaxY(orderPriveView.frame);
    updateSeverView.frame = CGRectMake(15, 0, ScreenWidth - 30, height);
    
    if ([_modal stateUpdate] == UpdetateStateAll) {
        butto.hidden = YES;
    }else {
        butto.hidden = NO;
    }
    
}

#pragma mark - 确认修改
- (void)buttonUpdateClick:(UIButton *)button {
    
  UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:nil message:@"是否确认订单修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
    // customer/order/v1.0.1/confirmModify


    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [KABNetworkManager GETURI:@"customer/order/v1.0.1/confirmModify" parameters:@{@"order_id":_modal.orderID} success:^(id responseObject) {
            
            [_modal postOrderListChangeNotification];
            if (checkNetworkResultObject(responseObject)) {
                
                
                return ;
            }
            [CustomToast showDialog:responseObject[kErrmsg]];
            
        } failure:^(id object) {
            
            [CustomToast showNetworkError];
            
        }];
        
    }
 
}


- (UILabel  *)labelTint:(NSString *)stringTint {
    
    UILabel   *labelTint = [[UILabel alloc] init];
    labelTint.text = stringTint;
    labelTint.textColor = kColorTextGrey;
    labelTint.font = [UIFont systemFontOfSize:14];
    [labelTint sizeToFit];
    
    return labelTint;
}
- (CGFloat)addOneSeverView:(CGFloat)lastY strign:(NSDictionary *)text view:(UIView *)superView {
    
    UILabel *labelSeverName = [[UILabel alloc] init];
    labelSeverName.text = text[@"service_name"];
    labelSeverName.textColor = KColorTextBlack;
    labelSeverName.font = [UIFont systemFontOfSize:15];
    [labelSeverName sizeToFit];
    labelSeverName.x = 8;
    labelSeverName.y = marginH + lastY;
    
    [superView addSubview:labelSeverName];
    
    NSString *stringPrice = [CPModalOrder stringPriceWithDot:NO price:text[@"price"]];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%@元*%@台",stringPrice,text[@"device_num"]];
    
    
    _servicePrice = [text[@"price"] integerValue] * [text[@"device_num"] integerValue] + _servicePrice;
    
    label.textColor = KColorTextBlack;
    label.font = [UIFont systemFontOfSize:15];
    [label sizeToFit];
    label.x = ScreenWidth - 30 - label.width - 8;
    label.y = marginH + lastY;
    [superView addSubview:label];
    
    labelSeverName.width = label.x - 10;
    
    return CGRectGetMaxY(labelSeverName.frame);
    
}



- (CGFloat) addOneSeverView:(CGFloat)lastY strign:(NSDictionary *)text{

    UILabel *labelSeverName = [[UILabel alloc] init];
    labelSeverName.text = text[@"service_name"];
    labelSeverName.textColor = KColorTextBlack;
    labelSeverName.font = [UIFont systemFontOfSize:15];
    [labelSeverName sizeToFit];
    labelSeverName.x = 8;
    labelSeverName.y = marginH + lastY;
    
    [_updateSeverView addSubview:labelSeverName];
    
    NSString *stringPrice = [CPModalOrder stringPriceWithDot:NO price:text[@"price"]];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%@元*%@台",stringPrice,text[@"device_num"]];
    
    
    _servicePrice = [text[@"price"] integerValue] * [text[@"device_num"] integerValue] + _servicePrice;
    
    label.textColor = KColorTextBlack;
    label.font = [UIFont systemFontOfSize:15];
    [label sizeToFit];
    label.x = ScreenWidth - 30 - label.width - 8;
    label.y = marginH + lastY;
    [_updateSeverView addSubview:label];

    labelSeverName.width = label.x - 10;

    return CGRectGetMaxY(labelSeverName.frame);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
