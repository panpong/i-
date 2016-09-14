//
//  CPCPSimpleOrdereCell.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPSimpleOrdereCell.h"
#import "CPBusiness.h"
#import "ABNetworkManager.h"
#import <Foundation/Foundation.h>
#import "CustomToast.h"

#import "ABPayViewController.h"
#import "CPUpdateOrderView.h"
#import "ABAppraiseViewController.h"
#import "UIView+Extention.h"
#import "CPHeadGreyLable.h"

@interface CPSimpleOrdereCell ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelServiceName;

@property (weak, nonatomic) IBOutlet UILabel *labelServiceStaus;

@property (weak, nonatomic) IBOutlet UILabel *labelServiceTime;

@property (weak, nonatomic) IBOutlet UILabel *labelServiceAddress;

@property (weak, nonatomic) IBOutlet UILabel *labelServiceMoney;

@property (weak, nonatomic) IBOutlet UIButton *buttonOperation;


@property (weak, nonatomic) IBOutlet CPUpdateOrderView *viewUpdateOrder;

// 修改View 的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateOrderViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewUpdate;

// 服务状态的Label 的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLabel;

// 取消操作View高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewCancel;

@property (weak, nonatomic) IBOutlet CPHeadGreyLable *labelHeadPrice;


@end


@implementation CPSimpleOrdereCell
//
+ (instancetype)simpleOrdereCell:(UITableView *)table {
    
    // 要和xib 中 cell 的reuse 一样
    static NSString * const reuseID = @"CPSimpleOrdereCell";
    CPSimpleOrdereCell * cell = [table dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        [table registerNib:[UINib nibWithNibName:@"CPSimpleOrdereCell" bundle:nil] forCellReuseIdentifier:reuseID];
        cell = [table dequeueReusableCellWithIdentifier:reuseID];
    }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
    
    [self settingUI];
    [self.buttonOperation addTarget:self action:@selector(buttonClickOperation:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)settingUI {
    
    
    self.labelServiceStaus.textColor = kColorOrange;
    self.labelServiceStaus.font = [UIFont boldSystemFontOfSize:14];
 
    self.labelServiceMoney.font = [UIFont boldSystemFontOfSize:18];
    self.labelServiceMoney.textColor = KColorTextBlack;
    
    self.labelServiceTime.font = [UIFont systemFontOfSize:14];
    self.labelServiceTime.textColor = KColorTextBlack;
    
    self.labelServiceAddress.font = [UIFont systemFontOfSize:14];
    self.labelServiceAddress.textColor = KColorTextBlack;
    
    self.labelServiceName.font = [UIFont systemFontOfSize:14];
    self.labelServiceName.textColor = KColorTextBlack;
    
    self.contentView.backgroundColor = kColorBackground;
    
    
 
    
}

#pragma mark - 点击按钮操作
- (void)buttonClickOperation:(UIButton *)button {

    // 取消，完成，修改：在本地更改：弹出提示框。 支付，评价：操作直接跳转到对应的评价页
    int operation = [self operationStatus:_modal];
    if ( operation == operationCancel || operation == operationFinish || operation == operationUpdate) {
        
        NSString *stringTitle = nil; // 
        if (operation == operationCancel) {
            
            stringTitle = @"是否确认取消订单";
            
        }else if (operation == operationFinish) {
            
            stringTitle = @"确认工程师已完成服务？";
        
        }else if (operation == operationUpdate) {
            
            stringTitle = @"是否确认订单修改";
        }

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:stringTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认 ", nil];
        
        [alertView show];
        
    }else if (operation == operationPay) {
        
        ABPayViewController *payController = [ABPayViewController getPayViewController];
        
        payController.hidesBottomBarWhenPushed = YES;
        payController.orderID = _modal.orderID;
        payController.engineerId = _modal.engineerId;
        payController.orderPrice = [_modal stringOriginPrice];
        [_nav pushViewController:payController animated:YES];
        
    }else if (operation == operationComment) { // 去评价
        
        ABAppraiseViewController *controller = [ABAppraiseViewController  getAppraiseViewController];
        controller.orderId = _modal.orderID;
        controller.engineerId = _modal.engineerId;
        controller.hidesBottomBarWhenPushed = YES;
        [_nav pushViewController:controller animated:YES];
        
    }
    
    
}


- (void)setModal:(CPModalOrder *)modal {
    
    _modal = modal;
    
    self.labelServiceName.text = modal.serviceName;
    self.labelServiceMoney.text =[NSString stringWithFormat:@"￥%@", modal.price];
    self.labelServiceStaus.text  = modal.statusText;
    self.labelServiceAddress.text = modal.serviceAddress;
    self.labelServiceTime.text =  [modal stringTime:modal.serviceTime];
    
    // 是服务包订单---》 隐藏
    // 服务包订单: 就隐藏 价格
    // operation 为0，但是是已评价，显示为已经评价

    if ([modal.type integerValue] != 0 ) { // 是服务包
        
        _labelHeadPrice.hidden = YES;
        _labelServiceMoney.hidden = YES;
        
        
        if ([modal.serviceName isEqualToString:@"服务器故障处理"]) {
        
            NSLog(@"%@",modal.serviceName);
        }
        if ([modal isShowOpertionButton] == NO) { // 不显示按钮的时候
            
             _heightViewCancel.constant = 0;
            
        }else {
            
             _heightViewCancel.constant = 58;
        }
        
    }else { // 不是服务包
        
        _labelHeadPrice.hidden = NO;
        _labelServiceMoney.hidden = NO;
        _heightViewCancel.constant = 58;
        
    }
    
    if (modal.operates.count == 0) { // 已经评价，不是已经评价
       // 已经取消
        [self settingButton:nil];
        
    }else {
        
        [self settingButton:modal.operates[0]];
    }


    self.updateOrderViewHeight.constant = modal.updateViewHeight;
    self.viewUpdateOrder.modal = modal;
    _imageViewUpdate.hidden = ![modal isImageUpdate];
    
    CGFloat height = self.labelServiceStaus.height;
    [self.labelServiceStaus sizeToFit];
    self.labelServiceStaus.height = height;
    self.widthLabel.constant = self.labelServiceStaus.width;
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        return;
    }
    
    int operationStatus = [self operationStatus:_modal];
    if (operationStatus == operationCancel) {
        
        [KABNetworkManager GETURI:@"customer/order/v1.0.1/cancel" parameters:@{@"order_id":_modal.orderID} success:^(id responseObject) {
            
             [_modal postOrderListChangeNotification];
            if (checkNetworkResultObject(responseObject)) {
             
                return ;
            }

             [CustomToast showDialog:responseObject[kErrmsg]];
           
        } failure:^(id object) {
   
            [CustomToast showNetworkError];
            
        }];
        
        
    }  else if (operationStatus == operationFinish) {
        
        [KABNetworkManager GETURI:@"customer/order/v1.0.1/confirmService" parameters:@{@"order_id":_modal.orderID} success:^(id responseObject) {
            
            [_modal postOrderListChangeNotification];
            if (checkNetworkResultObject(responseObject)) {
                
                
                return ;
            }

            [CustomToast showDialog:responseObject[kErrmsg]];
            
        } failure:^(id object) {
            
            [CustomToast showNetworkError];
         
        }];
        
        
    }else if (operationStatus == operationUpdate) { // 修改
        
        [KABNetworkManager GETURI:@"customer/order/v1.0.1/confirmModify" parameters:@{@"order_id":_modal.orderID} success:^(id responseObject) {

            [_modal postOrderListChangeNotification];
            if (checkNetworkResultObject(responseObject)) {

              
                return ;
            }
             [CustomToast showDialog:responseObject[kErrmsg]];
            [_modal postOrderListChangeNotification];
            
        } failure:^(id object) {

            [CustomToast showNetworkError];
            
        }];
  
    }
}

#pragma mark - 返回操作状态
- (int)operationStatus:(CPModalOrder *)modal {
    
    return  [modal operationStatus];
}


- (NSString *)buttongStringWith:(int)operation {
    
    
    return [_modal buttongOperationStringWith:operation];
    
}

- (CGFloat)cellHeight {
    
    return [_modal heightForCell];
    
}


- (void)settingButton:(NSDictionary *)dic{
    
   
    self.buttonOperation.hidden = ![_modal isShowOpertionButton];

     [self.buttonOperation setTitleColor:KColorTextBlack forState:UIControlStateNormal];
      self.buttonOperation.layer.borderWidth = 1;
    
    int operation  =  [self operationStatus:_modal];
    
    
    [self.buttonOperation setTitle:[self buttongStringWith:operation] forState:UIControlStateNormal];
    self.buttonOperation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
     [self.buttonOperation setUserInteractionEnabled:YES];
    
    // 设置button 颜色：
    if( operation == operationCancel  ) {// 取消
        
        self.buttonOperation.layer.borderColor = CPColor(204, 204, 204).CGColor;
          [self.buttonOperation setTitleColor:KColorTextBlack  forState:UIControlStateNormal];
    
    }else if (operationAlreadtComment == operation) {// 已评价
        
        self.buttonOperation.layer.borderColor = [UIColor clearColor].CGColor;
        self.buttonOperation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
     
         [self.buttonOperation setTitleColor:kColorTextGrey forState:UIControlStateNormal];
        [self.buttonOperation setUserInteractionEnabled:NO];
        
    }else{
    
        self.buttonOperation.layer.borderColor = KColorBlue.CGColor;
       [self.buttonOperation setTitleColor:KColorBlue  forState:UIControlStateNormal];
    };
  
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
