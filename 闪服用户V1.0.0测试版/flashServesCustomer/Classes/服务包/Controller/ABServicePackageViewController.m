//
//  ABServicePackageViewController.m
//  flashServesCustomer
//
//  Created by 002 on 16/6/1.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServicePackageViewController.h"
#import "ABServicePackageLoginView.h"
#import "UIView+Extention.h"
#import "ABNetworkManager.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABServicePackageTableViewCell.h"
#import "NSString+KYSAddition.h"
#import "KYSNetwork.h"
#import "CustomToast.h"
#import "MJRefresh.h"
#import "ABSumitServicePackageViewController.h"
#import "KYSNetErrorView.h"

@interface ABServicePackageViewController ()<ABServicePackageTableViewCellDelegate,KYSNetErrorViewDelegate>

@property(nonatomic,strong) ABServicePackageLoginView *servicePackageLoginView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArray;

@property(nonatomic,strong) KYSNetErrorView *netErrorView;

@end

@implementation ABServicePackageViewController

+ (ABServicePackageViewController *)getServicePackageViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"ServerPacket" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ABServicePackageViewController"];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarItem:self.title leftButtonIcon:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotification) name:NOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotification) name:NOTIFICATION_PACKAGE_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:NOTIFICATION_LOGINOUT object:nil];
    
    NSLog(@"11111111111");
//    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:nil];
//    //[self p_loadServerPackageList];
//    [self.tableView.header beginRefreshing];
    
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshTable)];
    [self.tableView.header beginRefreshing];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action
//下拉刷新
- (void)refreshTable  {
    NSLog(@"1122334455");
    [self p_loadServerPackageList];
}

- (void)refreshNotification{
    NSLog(@"refreshNotification");
    [self.tableView.header beginRefreshing];
    [self p_loadServerPackageList];
}

- (void)logout{
    [self p_refreshDataWithDic:nil];
}

#pragma mark - KYSNetErrorViewDelegate
- (void)tapAction{
    [self.tableView.header beginRefreshing];
    [self p_loadServerPackageList];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //(26+)+(42+)+35+10
    NSDictionary *dic=self.dataArray[indexPath.row];
    //服务项
    NSString *content=dic[@"content"];
    NSInteger itemHeight = [content heightForFont:[UIFont systemFontOfSize:15.0] width:ScreenWidth-30];
    //城市
    NSString *citys=dic[@"citys"];
    NSInteger cityHeight = [citys heightForFont:[UIFont systemFontOfSize:13.0] width:ScreenWidth-15-82];
    
    return (26+(itemHeight>19?itemHeight:19))+(42+(cityHeight>18?cityHeight:18))+45+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ABServicePackageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ABServicePackageTableViewCell"];
    cell.delegate=self;
    [cell setDataWithDic:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - ABServicePackageTableViewCellDelegate
- (void)placeOrderWithDic:(NSDictionary *)dic{
    NSLog(@"进入下单页");
    ABSumitServicePackageViewController *sVC=[ABSumitServicePackageViewController getSumitServicePackageViewController];
    sVC.orderDataDic=[dic mutableCopy];
    sVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:sVC animated:YES];
}

#pragma mark - private
- (void)p_loadServerPackageList{
    
    [self p_removeNetErrorView];
    
    if (!([ABNetworkDelegate isLogined]&&[KABNetworkDelegate isLongTermUser])) {
        [self p_addUnloginOrNodataView];
        self.servicePackageLoginView.isShowBottomView = ![ABNetworkDelegate isLogined];
        [self.tableView.header endRefreshing];
        if (![KABNetworkDelegate isLongTermUser]) {
            self.dataArray=nil;
            [self.tableView reloadData];
        }
        return;
    }
    
    NSLog(@"已登录且为长期协议用户");
    
    [self p_removeUnloginOrNodataView];
    //[self.tableView.header beginRefreshing];
    __weak typeof(self) wSelf=self;
    [KYSNetwork getPackageListWithParameters:nil success:^(id responseObject) {
        NSLog(@"服务包列表成功");
        [wSelf.tableView.header endRefreshing];
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [wSelf p_refreshDataWithDic:responseObject];
        }
    } failureBlock:^(id object) {
        NSLog(@"服务包列表失败");
        [wSelf.tableView.header endRefreshing];
        //if (isConnectingNetwork) {
            [CustomToast showToastWithInfo:@"网络不给力，请检查设置后再试"];
        //}
        [wSelf p_refreshDataWithDic:nil];
        if (isDisConnectedNetwork) {
            [wSelf p_addNetErrorView];
        }
    } view:nil];
}

- (void)p_refreshDataWithDic:(NSDictionary *)dic{
    //_dataArray=nil;
    _dataArray=dic[@"data"];
    [_tableView reloadData];
    if (!_dataArray.count) {
        [self p_addUnloginOrNodataView];
        self.servicePackageLoginView.isShowBottomView = ![ABNetworkDelegate isLogined];
        return;
    }
}

#pragma mark - UI设置
- (void)p_addUnloginOrNodataView {
    // 1. 添加控件
    self.view.backgroundColor = KGrayGroundColor;
    [self.tableView addSubview:self.servicePackageLoginView];
    
    // 2. 布局
    self.servicePackageLoginView.x = 0;
    self.servicePackageLoginView.y = 0;
}

- (void)p_removeUnloginOrNodataView{
    [self.servicePackageLoginView removeFromSuperview];
}

- (void)p_addNetErrorView{
    [self.tableView addSubview:self.netErrorView];
    [self.netErrorView showHint];
}

- (void)p_removeNetErrorView{
    [self.netErrorView hideHint];
}

#pragma mark - 懒加载
- (ABServicePackageLoginView *)servicePackageLoginView {
    if (!_servicePackageLoginView) {
        _servicePackageLoginView = [ABServicePackageLoginView servicePackageLoginViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR - SIZE_HEIGHT_TABBAR)];
        _servicePackageLoginView.viewController = self;
    }
    return _servicePackageLoginView;
}

#pragma mark - date

- (KYSNetErrorView *)netErrorView{
    if (!_netErrorView) {
        _netErrorView=[[KYSNetErrorView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR - SIZE_HEIGHT_TABBAR)];
        _netErrorView.delegate=self;
    }
    return _netErrorView;
}

@end
