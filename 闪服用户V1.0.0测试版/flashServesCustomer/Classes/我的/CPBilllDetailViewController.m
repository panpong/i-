//
//  CPBilllDetailViewController.m
//  flashServesCustomer
//
//  Created by yjin on 16/6/2.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPBilllDetailViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABNetworkManager.h"
#import "CustomToast.h"
#import "CPModalOrder.h"

@interface CPBilllDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelPhone;

@property (weak, nonatomic) IBOutlet UILabel *labelAddres;

@property (weak, nonatomic) IBOutlet UILabel *labelBillHead;

@property (weak, nonatomic) IBOutlet UILabel *labelBillContent;

@property (weak, nonatomic) IBOutlet UILabel *labelBillPrice;


@property (weak, nonatomic) IBOutlet UILabel *labelBillTime;

@property (nonatomic, strong)NSDictionary *modal ;
@property (weak, nonatomic) IBOutlet UILabel *labelState;

@property (nonatomic, strong)NSString  *invoice_id ;
@end

@implementation CPBilllDetailViewController

+ (instancetype)billlDetailViewCotnroller:(NSString *)invoice_id  {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPBillDetail" bundle:nil];
    CPBilllDetailViewController *detail = sb.instantiateInitialViewController;
    detail.invoice_id = invoice_id
    ;
    return  detail;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackground;
    [self setNavigationBarItem:@"申请发票" leftButtonIcon:@"返回" rightButtonTitle:nil];
    

    
    [self reLoadData];
}

- (void)setModal:(NSDictionary *)modal {
    
    _modal = modal;

    float priceA =  [modal[@"money"] floatValue] ;
    ;
    NSString *price = [NSString stringWithFormat:@"%@元",  [NSString stringWithFormat:@"%0.2f",priceA]];
    
    
    _labelAddres.text = modal[@"address"];
    _labelBillContent.text = modal[@"content"];
    _labelBillHead.text = modal[@"title"];
    _labelBillPrice.text = price;
    _labelBillTime.text =     [CPModalOrder stringTimeWithNoWeek:modal[@"created_at"]];
    
    _labelName.text = modal[@"contact"];
    _labelPhone.text = modal[@"mobile"];
    _labelState.text = modal[@"status_text"];
    
 
}


- (void)reLoadData {
    
    [self showLoadingView];
    NSDictionary *paramer = @{@"invoice_id":_invoice_id};
    [KABNetworkManager GETURI:@"customer/invoices/v1.0.1/detail" parameters:paramer success:^(id responseObject) {
        [self removeLoadingView ];
        if (checkNetworkResultObject(responseObject)) {
            
            self.modal = responseObject[
            @"invoice"];
            return ;
        }
        
        if (_modal == nil) {
            
            [self showErrorView];
        }
        
        [CustomToast showDialog:responseObject[kErrmsg]];
    } failure:^(id object) {
        
        [CustomToast hideWating];
        [CustomToast showNetworkError];
        [self showErrorView];
        
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
