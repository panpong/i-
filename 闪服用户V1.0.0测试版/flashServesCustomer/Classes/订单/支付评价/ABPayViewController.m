//
//  ABPayViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABPayViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABPayTableViewCell.h"
#import "ABResultViewController.h"
#import "KYSNetwork.h"
#import "CustomToast.h"
#import "ALPayManager.h"
#import "WeiXinPay.h"
#define DEFAULT_PAY_KEY @"ab.pay.way"
#import "ABResultViewController.h"
#import "CPWatingPayViewController.h"
#import "CPModalOrder.h"
@interface ABPayViewController ()<ABPayTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property(nonatomic,strong)NSArray *payArray;
@property(nonatomic,assign)NSInteger selectIndex;

@property (weak, nonatomic) IBOutlet UILabel *labelPrice;




@end

@implementation ABPayViewController

+ (ABPayViewController *)getPayViewController{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Pay&Appraise" bundle:nil];
    ABPayViewController *payVC=[storyBoard instantiateViewControllerWithIdentifier:@"ABPayViewController"];
    
    [[NSNotificationCenter defaultCenter] addObserver:payVC selector:@selector(receiveWXNotification:) name:WXPayResultNotification object:nil];
    return payVC;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (NSArray *)payArray{
    if (!_payArray) {
        NSInteger lastPayWay = [[[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_PAY_KEY] integerValue];
        self.selectIndex=lastPayWay;
        _payArray=@[[@{@"id":@"0",
                       @"selected":0==lastPayWay?@"1":@"0",
                       @"title":@"微信支付",
                       @"detail":@"推荐安装微信5.0及以上版本使用",
                       @"image":@"支付订单"} mutableCopy],
                    [@{@"id":@"1",
                       @"selected":1==lastPayWay?@"1":@"0",
                       @"title":@"支付宝支付",
                       @"detail":@"推荐有支付宝账号的用户使用",
                       @"image":@"支付订单1"} mutableCopy]];
       
        
        
    }
    
    return _payArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBarItem:@"支付订单" leftButtonIcon:@"返回" rightButtonTitle:nil];
    
    _payBtn.layer.cornerRadius=3.0;
    _payBtn.layer.masksToBounds=YES;
    
    _labelPrice.text = [NSString stringWithFormat:@"￥%@",[CPModalOrder stringPriceWithDot:YES price:_orderPrice]];
    
   NSString *price =  [NSString stringWithFormat:@"确认支付￥%@",[CPModalOrder stringPriceWithDot:YES price:_orderPrice]];

    
    [_payBtn setTitle:price forState:UIControlStateNormal];
    
}


#pragma mark - Action
- (IBAction)payAction:(id)sender {
    
    if (-1==_selectIndex) {
        
        [CustomToast showToastWithInfo:@"请选择支方式"];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(_selectIndex) forKey:DEFAULT_PAY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //暂时未接支付，直接调用支付成功接口
    [self p_payOrderSuccess];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.payArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ABPayTableViewCell*cell=(ABPayTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ABPayTableViewCell" forIndexPath:indexPath];
    [cell setDataWithDic:self.payArray[indexPath.row]];
    cell.delegate=self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.payArray[indexPath.row][@"title"]);
    ABPayTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    // 0 1  -1
//    _selectIndex=cell.isSelected?-1:indexPath.row;
    _selectIndex = indexPath.row;
    //修改列表选中状态

    for (int i = 0; i < 2; i++) {
        
        if (i == _selectIndex) {
            
            [self.payArray[i] setObject:@"1" forKey:@"selected"];
        }else {
            
            [self.payArray[i] setObject:@"0" forKey:@"selected"];
        }
        
    }
    
//    
//    for (NSMutableDictionary*dic in self.payArray){
//        NSInteger index=[self.payArray indexOfObject:dic];
////        [dic setObject:index==_selectIndex-1?@"1":@"0" forKey:@"selected"];
//        
//        [dic setObject:index==_selectIndex == index?@"1":@"0" forKey:@"selected"];
//        
//    }
    
    
    
    [tableView reloadData];
}

#pragma mark - ABPayTableViewCellDelegate
- (void)selectionCell:(ABPayTableViewCell *)cell{
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    _selectIndex=cell.isSelected?indexPath.row:0;
    //修改列表选中状态
    for (NSMutableDictionary*dic in self.payArray){
        NSInteger index=[self.payArray indexOfObject:dic];
        [dic setObject:index==_selectIndex?@"1":@"0" forKey:@"selected"];
    }
    [_tableView reloadData];
}


- (void)payWay:(NSDictionary *)responseObject {
    
    __weakSelf;
    if ([responseObject[@"payway"] integerValue] == 1) { // 微信
        
        NSDictionary *dic = responseObject[@"wxpay"];
        
        
        
        [[WeiXinPay sharedWeiXinPay] PayWithDictionary:dic];
        
    }else { // 支付宝
        
        Product *product = [[Product alloc] init];
        //            product.price = [responseObject[@"cash"] floatValue] * 0.01;
        product.price = [_orderPrice floatValue] * 0.01;
        product.subject = @"闪服客户端";
        product.body = @"闪服客户端";
        product.orderId = responseObject[@"serial_num"];
        
        [ALPayManager buyWithProduct:product completeBlock:^(int isSucess) {
            
            if ( isSucess == 0) {
                
                return;
            }
            
            CPWatingPayViewController *watinVC = [[CPWatingPayViewController alloc] init];
            [weakSelf.navigationController pushViewController:watinVC animated:NO];
            
            if (isSucess == 1) {
                
                [weakSelf checkIndentState];
                
                return ;
            } // 失败
          
            
            [weakSelf payFailureResult];
            
        }];
    }
    
}



#pragma mark - private
- (void)p_payOrderSuccess{

    
    BOOL isInstallWeiXin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    
    BOOL isSupportWXPay = isInstallWeiXin && [WXApi isWXAppSupportApi];
    
    if (isSupportWXPay == NO && _selectIndex == 0) {
        
        [CustomToast showToastWithInfo:@"请安装微信客户端或选择其它支付方式"];
        
        return ;
        
    }
    
    NSDictionary *dic=@{@"order_id":_orderID,
                        @"price":_orderPrice,
                        @"payway":[NSString stringWithFormat:@"%ld",(long)_selectIndex+1]};
 
 
    __weakSelf;
    [CustomToast showWating];
    [KYSNetwork payOrderWithParameters:dic success:^(id responseObject) {
        
        [CustomToast hideWating];
        if (checkNetworkResultObject(responseObject)) {
            
            [weakSelf payWay:responseObject];
            return ;
        }
    
        [CustomToast showDialog:responseObject[kErrmsg]];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [CPModalOrder postOrderListChangeNotification];
        
    } failureBlock:^(id object) {
        
       [CustomToast hideWating];
        [CustomToast showNetworkError];
        
    } view:nil];
}

#pragma mark =====private methods


#pragma mark - 检查支付结果

- (void)paySuccessResutlt {
    
    
    ABResultViewController *VC =  [ABResultViewController  getResultViewController:KResultViewControllerTypePaySuccess];
    VC.orderID = _orderID;
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)payFailureResult {
    
    ABResultViewController *VC =  [ABResultViewController  getResultViewController:KResultViewControllerTypePayFail];
    VC.orderID = _orderID;
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)checkIndentState{

    __weakSelf;
    [KABNetworkManager POST:@"customer/order/v1.0.1/isPayed" parameters:@{@"order_id":_orderID} success:^(id responseObject) {
       
        if (checkNetworkResultObject(responseObject)) {
         
            [weakSelf paySuccessResutlt];
            return ;
        }
        
        [weakSelf payFailureResult];
        
    } failure:^(id object) {
     
        [CustomToast showNetworkError];
        [weakSelf payFailureResult];
        
    }];

}

#pragma mark - 微信结果回调
- (void)receiveWXNotification:(NSNotification *)notification {
    
    NSDictionary *dictionary = notification.userInfo;
    
    NSString *stringResult = dictionary[WXPayResultNotificationKey];
    
//    CPWatingPayViewController *watinVC = [[CPWatingPayViewController alloc] init];
//    [self.navigationController pushViewController:watinVC animated:YES];
    
    if ([stringResult isEqualToString:@"WXErrCodeUserCancel"]) {
        return;
    }
    
    CPWatingPayViewController *watinVC = [[CPWatingPayViewController alloc] init];
    [self.navigationController pushViewController:watinVC animated:NO];
    if ([stringResult isEqualToString:@"WXPaySuccess"]) { // 支付成功
        [self checkIndentState];

        return;
    }
    
    [self payFailureResult];
}







@end
