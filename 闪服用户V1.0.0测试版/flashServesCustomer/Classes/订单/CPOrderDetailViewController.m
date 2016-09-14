//
//  CPOrderDetailViewController.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPOrderDetailViewController.h"
#import "PPEngineerInfoViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABNetworkManager.h"
#import "CustomToast.h"

#import "CPOrdeQuestionOneCellTableViewCell.h"
#import "CPOrderQustionImageCell.h"
#import "CPHeadSectionView.h"
#import "CPOrdeQuestionOneCellTableViewCell.h"
#import "CPInformationHomeCell.h"

#import "CPOrderInfoCell.h"

@interface CPOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)CPModalOrder *modalOrder;

@property (nonatomic,strong) NSDictionary *dataDic;

@end

@implementation CPOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.frame = self.view.bounds;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    [_tableView setBackgroundColor:kColorBackground];
    [self.view addSubview:_tableView];
    
    
    [self setNavigationBarItem:@"订单详情" leftButtonIcon:@"返回" rightButtonTitle:@"联系客服"];
    
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
   

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderListChange:) name:@"OrderListChangeNotification" object:nil];
   
    
    
    [self reLoadData];
    
    
};
- (void)reloadEngineerInfo
{
//    __typeof(self) wSelf=self;
//    dispatch_async(dispatch_queue_create("getData", DISPATCH_QUEUE_CONCURRENT), ^{
    
        NSDictionary *paramer = @{@"engineer": _modalOrder.engineerId};
        [KABNetworkManager GETURI:@"customer/info/v1.0.1/userprofile" parameters:paramer success:^(id responseObject) {
            //        [self removeLoadingView ];
            
            if (checkNetworkResultObject(responseObject)) {
                _dataDic = responseObject;
                
                return ;
            }
            
            //        [CustomToast showDialog:responseObject[kErrmsg]];
        } failure:^(id object) {
            //        [CustomToast hideWating];
            //        [CustomToast showNetworkError];
            //        [self showErrorView];
            
        }];
        
//    });
    
}

- (void)reLoadData {
    
    if (self.orderID.length != 0) {
    
        [self showLoadingView];
        NSDictionary *paramer = @{@"order_id":self.orderID};
        [KABNetworkManager GETURI:@"customer/order/v1.0.1/detail" parameters:paramer success:^(id responseObject) {
            [self removeLoadingView ];
            if (checkNetworkResultObject(responseObject)) {
            
                _modalOrder = [CPModalOrder modalDetailOrder:responseObject];
                [self.tableView reloadData];
                dispatch_async(dispatch_queue_create("reloadEngineerInfo", DISPATCH_QUEUE_CONCURRENT), ^{
                    [self reloadEngineerInfo];
                });
                
                return ;
            }
            
            if (_modalOrder == nil) {
                
                [self showErrorView];
            }
           
            [CustomToast showDialog:responseObject[kErrmsg]];
        } failure:^(id object) {
            [CustomToast hideWating];
            [CustomToast showNetworkError];
            [self showErrorView];
            
        }];
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (CGFloat )heightQestionDescribe:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self cellShowFauile:indexPath tableView:_tableView];
    
    if (cell != nil) { //
        
        CPOrdeQuestionOneCellTableViewCell *cellH = (CPOrdeQuestionOneCellTableViewCell *)cell;
        
        if ([_modalOrder isShowFauileRowOne ] && [_modalOrder isShowFauileWhy]) { // 故障原因和 故障服务都显示
            
            if (indexPath.row == 1) {
                
                return [cellH cellHeight] + 10;
            }
            
            return [cellH cellHeight] ;
            
        }else { // 只是显示一个
            
            return [cellH cellHeight] + 10;
            
        }
    }
    return 0;
    
}



- (BOOL)isShowQuestionDescribe {
    
    return  [_modalOrder isShowFauileSection];
}




#pragma mark 数据源代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { // 显示订单信息
        
        if (_modalOrder.engineerName.length == 0) { //不显示 工程师
            
            return _modalOrder.services.count * 28 + 14 + 10 + 40;
        }
        
        return _modalOrder.services.count * 28 + 14 + 105 + 20;
    }
    
    if ([self isShowQuestionDescribe] && indexPath.section == 1) {
        
        return [self heightQestionDescribe:indexPath];
    }
    
    if (indexPath.section == 2 || indexPath.section == 1) { // 上门信息
        
        CPInformationHomeCell *cell = [CPInformationHomeCell CPInformationHomeCell:tableView];
        cell.modal = _modalOrder;
        
        return cell.cellHeight;
        
    }
    
    return 0;
}


- (void)rightButtonClick:(UIButton *)button {

    NSURL *phoneURL = [NSURL URLWithString: [NSString stringWithFormat: @"tel:/%@",SERVICE_PHONE_NUM]];
    UIWebView *  phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_modalOrder == nil) {
        
        return 0;
    }
    
    if (_modalOrder.isShowFauileSection) {
        
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CPHeadSectionView *view = [CPHeadSectionView headSectionView];
    
    NSArray *arrayText = @[@"订单信息",@"问题描述",@"上门信息"];
    
    NSArray *arrayImage = @[@"订单详情-订单信息",@"订单详情-问题描述",@"订单详情-上门信息"];
    
    if (section == 0) {
        
        [view settingHeadSection:arrayImage[section] title:arrayText[section] text2:_modalOrder.statusText];
        
    }else {
        
        if ([_modalOrder isShowFauileSection] == NO) {
            
            [view settingHeadSection:arrayImage[2] title:arrayText[2]];
            
        }else {
        
          [view settingHeadSection:arrayImage[section] title:arrayText[section]];
        }
    }
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_modalOrder.isShowFauileSection && section == 1) {
        
        if ([_modalOrder isShowFauileRowOne] && [_modalOrder  isShowFauileWhy]) { // 同时显示
            
            return 2;
            
        }
    }

    return 1;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self cellShowFauile:indexPath tableView:tableView];
    if (cell != nil) {
        
        return cell;
    }
    
    if (indexPath.section == 2 || indexPath.section == 1) {
        
        CPInformationHomeCell *cell = [CPInformationHomeCell CPInformationHomeCell:tableView];
        
        
        cell.modal = _modalOrder;
        cell.nav = self.navigationController;
        return cell;
        
    }
    
    CPOrderInfoCell *infocell = [CPOrderInfoCell orderInfoCell:tableView];
    infocell.modal = _modalOrder;
    
    UIView *view = (UIView *)[infocell.contentView viewWithTag:100];
    UIImageView *iv = (UIImageView *)[view viewWithTag:100];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    
    tap.numberOfTapsRequired = 1;
    [iv addGestureRecognizer:tap];
    
    [iv setUserInteractionEnabled:YES];
    return infocell;

    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)click
{
    NSLog(@"<<<<<<<<<<<<<<<<<<<");
    
    if (_dataDic == nil) {
        [CustomToast showDialog:@"数据正在加载" time:0.5];
        return;
    }
    PPEngineerInfoViewController *vc = [[PPEngineerInfoViewController alloc] initWithDic:_dataDic];
    vc.engineerId = [self.modalOrder.engineerId intValue];
    
    
    [self.navigationController pushViewController:vc animated:YES];
   
   
    
}





- (UITableViewCell *)cellShowFauile:(NSIndexPath *)indexPath
tableView:(UITableView *)tableView{
    
    if ([_modalOrder isShowFauileSection] && indexPath.section == 1) { // 显示问题描述
        
        if ([_modalOrder isShowFauileRowOne] && [_modalOrder  isShowFauileWhy]) { // 显示故障原因 和显示 故障服务列表
            
            if (indexPath.row == 0 ) { // 显示服务列表
                
                CPOrdeQuestionOneCellTableViewCell *cell = [CPOrdeQuestionOneCellTableViewCell OrdeQuestionOneCellTableViewCell:tableView];
                
                cell.modal = _modalOrder;
                return cell;
                
            }else { // 显示故障原因
                
                CPOrderQustionImageCell *cell = [CPOrderQustionImageCell CPOrderQustionImageCell:tableView];
                cell.modal = _modalOrder;
                return cell;
            }
            
        }
        
        if ([_modalOrder isShowFauileRowOne]) { // 只是显示服务列表
            
            CPOrdeQuestionOneCellTableViewCell *cell = [CPOrdeQuestionOneCellTableViewCell OrdeQuestionOneCellTableViewCell:tableView];
            
            cell.modal = _modalOrder;
            return cell;
            
        }else { // 这是显示故障原因
            
            CPOrderQustionImageCell *cell = [CPOrderQustionImageCell CPOrderQustionImageCell:tableView];
            cell.modal = _modalOrder;
            return cell;
            
            
        }
    
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  
}


- (void)orderListChange:(NSNotification *)notification {

    [self reLoadData];
    
}


- (void)tapClick {
    
    [self reLoadData];
}

// 去掉tableview中section的headerview粘性
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat sectionHeaderHeight = 35;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 163, 0);
//    }
//    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 163, 0);
//    }
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
