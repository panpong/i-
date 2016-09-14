//
//  CPInformationHomeCell.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/27.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPInformationHomeCell.h"
#import "CPTextLineCell.h"
#import "ABPayViewController.h"
#import "ABAppraiseViewController.h"
#import "ABNetworkManager.h"
#import "CustomToast.h"
@interface CPInformationHomeCell()<UIAlertViewDelegate>
// 依次按 @[@"联系人",@"联系电话",@"服务时间",@"服务地址",@"订单编号",@"下单时间",@"实付金额"]; 排列

@property (weak, nonatomic) IBOutlet CPTextLineCell *textLineCell0;

@property (weak, nonatomic) IBOutlet CPTextLineCell *textLineCell1;

@property (weak, nonatomic) IBOutlet CPTextLineCell *textLineCell2;

@property (weak, nonatomic) IBOutlet CPTextLineCell *textLineCell3;
@property (weak, nonatomic) IBOutlet CPTextLineCell *textLineCell4;

@property (weak, nonatomic) IBOutlet CPTextLineCell *textLineCell5;
@property (weak, nonatomic) IBOutlet CPTextLineCell *textLineCell6;

// 操作按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonOperation;

@property (nonatomic, assign)int  indexView;

@end


@implementation CPInformationHomeCell

- (void)awakeFromNib {
    // Initialization code
      [self.buttonOperation addTarget:self action:@selector(buttonClickOperation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

+ (instancetype)CPInformationHomeCell
:(UITableView *)table {
    
    // 要和xib 中 cell 的reuse 一样
    static NSString * const reuseID = @"CPInformationHomeCell";
    CPInformationHomeCell * cell = [table dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        [table registerNib:[UINib nibWithNibName:@"CPInformationHomeCell" bundle:nil] forCellReuseIdentifier:reuseID];
        cell = [table dequeueReusableCellWithIdentifier:reuseID];
        
    }
    
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)setModal:(CPModalOrder *)modal {
    
    _modal = modal;
    
    [self settingFaulureStyle];

    if (modal.operates.count == 0) {
        
        [self settingButton:nil];
        
    }else {
        
        [self settingButton:modal.operates[0]];
    }
    
}

#pragma mark - 返回操作状态
- (int)operationStatus:(CPModalOrder *)modal {
    
    return  [modal operationStatus];
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
         [self.buttonOperation setTitle:@"已评价" forState:UIControlStateNormal];
        [self.buttonOperation setTitleColor:kColorTextGrey forState:UIControlStateNormal];
        [self.buttonOperation setUserInteractionEnabled:NO];
        
    }else{
        
        self.buttonOperation.layer.borderColor = KColorBlue.CGColor;
        [self.buttonOperation setTitleColor:KColorBlue  forState:UIControlStateNormal];
    };
    
}


- (NSString *)buttongStringWith:(int)operation {
    
    
    return [_modal buttongOperationStringWith:operation];
    
}

- (void)settingFaulureStyle {
    
    // 故障类型、服务类型、设备类型、系统类型、部件
    NSArray * arrayHit = @[@"联系人",@"联系电话",@"服务时间",@"服务地址",@"订单编号",@"下单时间",@"实付金额"];
    
    NSArray *arrayView = @[_textLineCell0,_textLineCell1,_textLineCell2,_textLineCell3,_textLineCell4,_textLineCell5,_textLineCell6];
    
    NSString *cash = [CPModalOrder stringPriceWithDot:YES price:_modal.cash];
    if (cash.length > 0) {
        
        cash = [NSString stringWithFormat:@"%@元",cash];
        
    }
    NSArray *arrayText = @[_modal.contactName,_modal.contactTel, [_modal stringTime:_modal.serviceTime] ,_modal.serviceAddress,_modal.orderNnum,[CPModalOrder stringTimeWithhengNoWeekFormat:_modal.created_at], cash];
    
    int indexView = 0;
    for (int i = 0 ; i < arrayText.count; i++) {
        
        NSString *stringText = arrayText[i];
        if (stringText.length == 0) {
            continue;
        }
        
        CPTextLineCell *textLineView = arrayView[indexView];
        indexView++;
        
        if ([arrayHit[i] isEqualToString:@"服务地址"]) { // 是不是服务地址
            
             [textLineView setLineHint:arrayHit[i] content:arrayText[i] type:CPLineCellTypeConmentTextAddress];
            
        }else {
            
             [textLineView setLineHint:arrayHit[i] content:arrayText[i] type:CPLineCellTypeHintText];
        }
    }
    
    if (_modal.cash.length == 0) {
        
        [_textLineCell6 setLineHint:nil content:nil type:CPLineCellTypeHintText];
        _indexView = 6;
        return;
    }
    
    _indexView = 7;
    
}


- (CGFloat)heightContent {
    
    CGSize size = CGSizeMake(ScreenWidth - 30 - 84, 80);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    
    CGRect rect = [_modal.serviceAddress boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return rect.size.height ;
}


- (CGFloat)cellHeight {
    
    if ([_modal isShowOpertionButton] == NO ) {
        
        return   _indexView * 28 + 10 + 6 + 14 + [self heightContent] ;
    }

    return   _indexView * 28 + 10 + 10 + 14 + [self heightContent]  + 44;
  
}


#pragma mark - 点击按钮操作
- (void)buttonClickOperation:(UIButton *)button {
    
    
    // 取消，完成，修改：在本地更改：弹出提示框。 支付，评价：操作直接跳转到对应的评价页
    int operation = [self operationStatus:_modal];
    if ( operation == operationCancel || operation == operationFinish || operation == operationUpdate) {
        
        NSString *stringTitle = nil;
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
            
        } failure:^(id object) {
            
            [CustomToast showNetworkError];
            
        }];
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
