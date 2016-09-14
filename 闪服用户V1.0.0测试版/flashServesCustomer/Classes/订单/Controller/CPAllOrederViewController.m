//
//  CPRuningOrderViewController.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPRuningOrderViewController.h"
#import "CPBusiness.h"
#import "CPSimpleOrdereCell.h"
#import "CustomToast.h"
#import "CPModalOrder.h"
#import "ABNetworkDelegate.h"


#import "ABPayViewController.h"
#import "CPOrderDetailViewController.h"
#import "CPFinishedOrederViewController.h"
#import "CPAllOrederViewController.h"
@interface CPAllOrederViewController ()

@property (nonatomic, strong)NSMutableArray *arrayMOrder;

// 要加载的页数
@property (nonatomic, assign)int pageWillLoad;
@end

@implementation CPAllOrederViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.contentInset = UIEdgeInsetsMake( -1, 0, 120, 0);
    
    //    self.tableView.rowHeight = 182;
    
    self.arrayMOrder = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderListChange:) name:@"OrderListChangeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:NOTIFICATION_LOGINSUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess:) name:NOTIFICATION_LOGINOUT object:nil];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshViewData{
    
    if (self.isViewCurrentShow == YES) {
        
        [self.tableView.header beginRefreshing];
        
    }else {
        
        self.isNeedRefresh = YES;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}


#pragma mark - 下拉刷新
- (void)refreshTable {
    
    
    if( [ABNetworkDelegate isLogined] == NO ) {
        
        
        return;
    }
    [super refreshTable];
    // 进行中订单
    NSDictionary *paramer = @{@"status":@"0",
                              @"p":@"1"};
    _pageWillLoad = 1;
  
    __weakSelf;
    [CPBusiness getOrderListParamer:paramer success:^(id responseObject) {
        
        if (checkNetworkResultObject(responseObject)) {
            
            NSArray *array = [CPModalOrder arrayModalOrder:responseObject[@"orders"]];
            [self.arrayMOrder removeAllObjects];
            [self.arrayMOrder addObjectsFromArray:array];
            [weakSelf refreshSuccess];
            
            if ([responseObject[@"orders"] count] == 0) { // 没有数据
                
                [self showNotDataHintWithImageString:@"默认图" title:@"目前还没有您的订单，快去下单吧"];
                
                [weakSelf.tableView reloadData];
                return ;
            }
            
           
            if ([responseObject[@"total"] integerValue] > [responseObject[@"pn"] integerValue] ) { // 有其他数据
                
                [weakSelf.tableView addLegendFooterWithRefreshingTarget:self  refreshingAction:@selector(reLoadingTable)];
                _pageWillLoad++;
            }
            [weakSelf.tableView reloadData];
            return ;
        }
        
        [weakSelf refreshFauile:_arrayMOrder];
        [CustomToast showToastWithInfo:responseObject[kErrmsg]];
        
    } failure:^(id object) {
        
        [weakSelf refreshFauile:_arrayMOrder];
        [CustomToast showNetworkError];
        
    }];
    
    
}


// 上啦加载
- (void)reLoadingTable {
    
    // 进行中订单
    NSDictionary *paramer = @{@"status":@"0",
                              @"p":[NSString stringWithFormat:@"%d",_pageWillLoad]};
    
    __weakSelf;
    [CPBusiness getOrderListParamer:paramer success:^(id responseObject) {
        
        [weakSelf.tableView.footer endRefreshing];
        if (checkNetworkResultObject(responseObject)) {
            
            [weakSelf refreshSuccess];
            
            if ([responseObject[@"orders"] count] == 0) { // 没有其他数据
                
                [weakSelf.tableView.footer setState:MJRefreshFooterStateNoMoreData];
                
                return ;
            }
            
            NSArray *array = [CPModalOrder  arrayModalOrder:responseObject[@"orders"]];
            [weakSelf.arrayMOrder addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            _pageWillLoad++;
            return ;
        }
        
        [CustomToast showToastWithInfo:responseObject[kErrmsg]];
        
    } failure:^(id object) {
        
        [weakSelf.tableView.footer endRefreshing];
        [CustomToast showNetworkError];
        
    }];
    
    
}

#pragma mark 数据源代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    CPModalOrder *modal = self.arrayMOrder[indexPath.row];
//    return [modal heightForCell];
    CPModalOrder *modal = self.arrayMOrder[indexPath.row];
    
    CPSimpleOrdereCell *cell =  [CPSimpleOrdereCell simpleOrdereCell:tableView];
    
    cell.modal = modal;
    return [cell cellHeight];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.arrayMOrder.count == 0) {
        
        return 0;
    }
    
    return 1;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayMOrder.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CPModalOrder *modal = self.arrayMOrder[indexPath.row];
    if( modal.isModifyWatingOK ) {
        
        CPSimpleOrdereCell *cell =  [CPSimpleOrdereCell simpleOrdereCell:tableView];
        cell.modal = modal;
        return cell;
        
        
    }else {
        
        CPSimpleOrdereCell *cell =  [CPSimpleOrdereCell simpleOrdereCell:tableView];
        cell.nav = self.navigationController;
        cell.modal = modal;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CPModalOrder *modal = self.arrayMOrder[indexPath.row];
    
    CPOrderDetailViewController *detailVC = [[CPOrderDetailViewController alloc] init];
    
    detailVC.orderID = [modal.orderID copy];
    
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)orderListChange:(NSNotification *)notification {
    
    [self refreshViewData];
    
}

- (void)loginOutSuccess:(NSNotification *)notification {
    
    [self.arrayMOrder removeAllObjects];
    [self.tableView reloadData];
    
}

- (void)loginSuccess:(NSNotification *)notification {
    
    [self refreshViewData];
//    [self performSelector:@selector(refreshViewData) withObject:nil afterDelay:0.5];
    
}


@end


