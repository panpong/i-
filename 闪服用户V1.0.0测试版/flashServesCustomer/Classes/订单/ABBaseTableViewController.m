//
//  ABBaseTableViewController.m
//  customIBus
//
//  Created by yjin on 15/6/9.
//  Copyright (c) 2015年 aibang. All rights reserved.
//

#import "ABBaseTableViewController.h"

#import "CustomToast.h"
#import "ABNetworkManager.h"
#import "UIView+Extention.h"
#import "ABNetworkDelegate.h"

@interface ABBaseTableViewController ()

@property (nonatomic, strong)UILabel *netWorkText;
@property (nonatomic, strong)UIImageView *imageViewIcon;
@property (nonatomic, strong)UILabel *labelNetWorkDetatil;


@property (nonatomic, strong)UITapGestureRecognizer *tap;
@property (nonatomic, strong)UITapGestureRecognizer *locationTap;




@end

@implementation ABBaseTableViewController

- (void)refreshFauile:(NSArray *)arrayM  {
    
    if (arrayM.count > 0) {
        
        [self.tableView.header endRefreshing];
        return;
       
    }
    [self removeNotDataHint];
    [self showNetworkErrorHint];
    [self.tableView.header endRefreshing];
}

- (void)refreshSuccess {
  
    [self removeNetworkErrorHint];
    [self.tableView.header endRefreshing];
}


- (UILabel *)labelNetWorkDetatil {
    if (_labelNetWorkDetatil == nil) {
        _labelNetWorkDetatil = [[UILabel alloc] init];
        [_labelNetWorkDetatil setTextColor:[UIColor clearColor]];
    }
    return _labelNetWorkDetatil;
}


#pragma mark 懒加载
- (UIImageView *)imageViewIcon {
    if (_imageViewIcon == nil) {
        
        _imageViewIcon = [[UIImageView alloc] init];
    }
    return _imageViewIcon;
    
}

- (UILabel *)netWorkText {
    
    if (_netWorkText == nil) {
        _netWorkText = [[UILabel alloc] init];
        [_netWorkText setTextColor:CPColor(200, 200, 200)];
    }
    return _netWorkText;
}


- (void)viewDidAppear:(BOOL)animated {
    
    if (_isNeedRefresh == YES) {
        
        [self.tableView.header beginRefreshing];
        _isNeedRefresh = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    _isViewCurrentShow = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    _isViewCurrentShow = NO;
    
}


#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshTable)];
    
    if (![self.tableView.header isRefreshing]&& [ABNetworkDelegate isLogined] == YES) {
        [self.tableView.header beginRefreshing];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (isDisConnectedNetwork) {// 没有网络，一片空白才出来
        
         [self showNetworkErrorHint];
    }
    
    self.isShowHint = NO;
    self.tableView.backgroundColor = kColorBackground;
}


- (void)viewDidLayoutSubviews {
    
    [self setImageLayout];
    
}

#pragma mark 上拉加载下拉刷新
- (void)refreshTable {
    
    [self.tableView removeFooter];

}

#pragma mark 显示提示
- (void)showHintWithStringImage:(NSString *)stringImage Text:(NSString *)text {
    
    if (self.isShowHint == YES) {
        return;
    }
    
    self.isShowHint = YES;
    [self.tableView addSubview:self.netWorkText];
    [_netWorkText setText:text];
    [_netWorkText sizeToFit];
    
    
    [self.tableView addSubview:self.imageViewIcon];
    [_imageViewIcon setImage:[UIImage imageNamed:stringImage]];
    [self.imageViewIcon sizeToFit];

    
}

- (void)setImageLayout {
    
    CGFloat x = self.tableView.bounds.size.width * 0.5;
    CGFloat y = self.tableView.bounds.size.height * 0.3;
    
    _imageViewIcon.centerX = x;
    _imageViewIcon.centerY = y;
    
    _netWorkText.centerX = x;
    _netWorkText.y = CGRectGetMaxY(_imageViewIcon.frame) + 45;
    
    _labelNetWorkDetatil.centerX = x;
    _labelNetWorkDetatil.y = CGRectGetMaxY(_netWorkText.frame) + 4;
}


- (void)removeHint {
    
    [_imageViewIcon removeFromSuperview];
    
    [_netWorkText removeFromSuperview];
    
    [_labelNetWorkDetatil removeFromSuperview];
    
    self.isShowHint = NO;
}

// 网络提示
- (void)removeNetworkErrorHint  {
    
    [self removeHint];
    [self.tableView removeGestureRecognizer:self.tap];
    self.tap = nil;
}

- (void)showNetworkErrorHint {
    
    [self showHintWithStringImage:@"ios_点击刷新" Text:@"网络不给力,请检查设置后再试"];
//    [self.tableView removeGestureRecognizer:self.tap];//添加前要移除，否则容易出错
    if (self.tap == nil) {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self.tableView addGestureRecognizer:self.tap];
    }
}


// 点击事件
- (void)tapClick {
    if (![self.tableView.header isRefreshing]) {
        [self.tableView.header beginRefreshing];
    }
}

//  没有数据提示
- (void)showNotDataHintWithImageString:(NSString *)stringImage title:(NSString *)title{
    
    [self showHintWithStringImage:stringImage Text:title];
    
}

- (void)showNotDataHintWithImageString:(NSString *)stringImage title:(NSString *)title detailTitle:(NSString *)detailTitle {
    
    if (self.isShowHint == YES) {
        return;
    }
    [self showHintWithStringImage:stringImage Text:title];
    
    self.labelNetWorkDetatil.text = detailTitle;
    [self.labelNetWorkDetatil sizeToFit];
    [self.tableView addSubview:_labelNetWorkDetatil];
}

#pragma mark - 定位

- (void)showNoLocationHint {
    
    [self showHintWithStringImage:nil Text:@"定位失败，请点击重试"];
//    [self.tableView removeGestureRecognizer:self.tap];
    if (self.locationTap == nil) {
        
         self.locationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        
         [self.tableView addGestureRecognizer:self.locationTap];
    }
}
- (void)removeNoLocation {
    
    [self removeHint];
    if (self.locationTap != nil) {
        
        [self.tableView removeGestureRecognizer:self.locationTap];
        self.locationTap = nil;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
//    [self removeNoLocation];
//    [self removeNetworkErrorHint];
    
}

- (void)removeNotDataHint{
     [self removeHint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
