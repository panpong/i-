//
//  ABResultViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABResultViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "UIDevice+KYSAddition.h"
#import "ABAppraiseViewController.h"
#import "CPOrderDetailViewController.h"
#import "AppDelegate.h"
#import "CPModalOrder.h"
@interface ABResultViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtnCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnCenter;


@property (weak, nonatomic) IBOutlet UIImageView *titleInageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (nonatomic,assign) KResultViewControllerType type;
@property (nonatomic,strong) NSArray *typeDataArray;

@end

@implementation ABResultViewController

+ (ABResultViewController *)getResultViewController:(KResultViewControllerType) type{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Pay&Appraise" bundle:nil];
    ABResultViewController *rVC=[storyBoard instantiateViewControllerWithIdentifier:@"ABResultViewController"];
    rVC.type=type;
    NSLog(@"init ABResultViewController");
    return rVC;
}

- (NSArray *)typeDataArray{
    if (!_typeDataArray) {
        _typeDataArray=@[@{@"title1":@"支付成功",
                           @"image":@"成功",
                           @"title":@"支付成功！",
                           @"detail":@"感谢您选择我们的服务",
                           @"leftBtn":@"去评价",
                           @"rightBtn":@"查看订单"},
                         @{@"title1":@"下单成功",
                           @"image":@"成功",
                           @"title":@"下单成功！",
                           @"detail":@"我们正在为您安排工程师上门服务",
                           @"leftBtn":@"继续下单",
                           @"rightBtn":@"查看订单"},
                         @{@"title1":@"支付失败",
                           @"image":@"支付失败",
                           @"title":@"抱歉，获取支付信息失败",
                           @"detail":@"请您到订单详情中查看支付信息",
                           @"leftBtn":@"",
                           @"rightBtn":@"查看订单"},
                         @{@"title1":@"下单成功",
                           @"image":@"成功",
                           @"title":@"下单成功！",
                           @"detail":@"我们正在为您安排工程师上门服务",
                           @"leftBtn":@"继续下单",
                           @"rightBtn":@"查看订单"}];
    }
    return _typeDataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad：%ld",(long)_type);
    
    NSDictionary *dataDic=self.typeDataArray[_type];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBarItem:dataDic[@"title1"] leftButtonIcon:@"返回" rightButtonTitle:nil];
    
    [self.leftButton removeTarget:self action:@selector(clickLeftNavButton) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneBtn setTitle:SERVICE_PHONE_NUM forState:UIControlStateNormal];
    
    [self p_adjustUI];
    
    [self p_adjustConstraint];
    
    [self p_setDataWithDic:dataDic];
}

#pragma mark - Action
- (void)backAction{

    if (KResultViewControllerTypeGeneralOrderSuccess == _type) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        //进入订单列表
        AppDelegate *appDel = [UIApplication sharedApplication].delegate;
        UITabBarController *tabVC=(UITabBarController *)appDel.window.rootViewController;
        UINavigationController *naVC=tabVC.viewControllers[2];
        [naVC popToRootViewControllerAnimated:NO];
        [tabVC setSelectedIndex:2];
        //更新订单列表通知
        [CPModalOrder postOrderListChangeNotification];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    //更新订单列表通知
    [CPModalOrder postOrderListChangeNotification];
}

- (IBAction)leftBtnAction:(id)sender {
    if (KResultViewControllerTypePaySuccess == _type) {
        //评价页
        ABAppraiseViewController *appVC=[ABAppraiseViewController getAppraiseViewController];
        appVC.engineerId=_engineerId;
        appVC.orderId=_orderID;
        [self.navigationController pushViewController:appVC animated:YES];
    }else if(KResultViewControllerTypeOrderSuccess == _type
             ||KResultViewControllerTypeGeneralOrderSuccess == _type){
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
        //下单成功返回
        [self.navigationController popToRootViewControllerAnimated:NO];
        //应该发一个更新订单列表的通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderListChangeNotification" object:nil];
        [CPModalOrder postOrderListChangeNotification];
        //进入订单列表
        AppDelegate *appDel = [UIApplication sharedApplication].delegate;
        UITabBarController *tabVC=(UITabBarController *)appDel.window.rootViewController;
        UINavigationController *naVC=tabVC.viewControllers[0];
        [naVC popToRootViewControllerAnimated:NO];
        //NSLog(@"%@",tabVC.viewControllers[0]);
        [tabVC setSelectedIndex:0];
    }
}

- (IBAction)rightBtnAction:(id)sender {
    //进入订单详情
    CPOrderDetailViewController *orderDetail=[[CPOrderDetailViewController alloc] init];
    //要区分是服务包订单，还是普通订单
    orderDetail.orderID=_orderID;
    orderDetail.isNeedRefreshList=YES;
    [self.navigationController pushViewController:orderDetail animated:YES];
}


- (IBAction)callAction:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneBtn.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)tapAction:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneBtn.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


#pragma mark - private
- (void)p_adjustUI{
    _leftBtn.layer.cornerRadius=3.0;
    _leftBtn.layer.masksToBounds=YES;
    
    _rightBtn.layer.borderWidth=1;
    _rightBtn.layer.borderColor=[UIColor colorWithRed:0 green:162/255.0 blue:227/255.0 alpha:1].CGColor;
    _rightBtn.layer.cornerRadius=3.0;
    _rightBtn.layer.masksToBounds=YES;
}

- (void)p_setDataWithDic:(NSDictionary *)dic{
    _titleInageView.image=[UIImage imageNamed:dic[@"image"]];
    _titleLabel.text=dic[@"title"];
    _detailLabel.text=dic[@"detail"];
    [_leftBtn  setTitle:dic[@"leftBtn"] forState:UIControlStateNormal];
    [_rightBtn setTitle:dic[@"rightBtn"] forState:UIControlStateNormal];
    
    if (KResultViewControllerTypePayFail==_type) {
        _rightBtnCenter.constant=0;
        _leftBtn.hidden=YES;
    }
}

- (void)p_adjustConstraint{
    NSString *machine=[UIDevice currentDevice].machineModelName;
    if ([machine containsString:@"iPhone 5"]||[machine containsString:@"iPod touch 5"]) {
        _imageViewTop.constant=_imageViewTop.constant/3*2;
        _titleLabelTop.constant=_titleLabelTop.constant/3*2;
        _detailLabelTop.constant=_detailLabelTop.constant/3*2;
        _leftBtnTop.constant=_leftBtnTop.constant/3*2;
        _rightBtnTop.constant=_rightBtnTop.constant/3*2;
//        _leftBtnCenter.constant=_leftBtnCenter.constant/3*2;
//        _rightBtnCenter.constant=_rightBtnCenter.constant/3*2;
        //[self.view layoutIfNeeded];
    }
}

@end
