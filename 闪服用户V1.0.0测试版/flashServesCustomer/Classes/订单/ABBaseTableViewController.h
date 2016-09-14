//
//  ABBaseTableViewController.h
//  customIBus
//
//  Created by yjin on 15/6/9.
//  Copyright (c) 2015年 aibang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface ABBaseTableViewController : UITableViewController
@property (nonatomic, assign)BOOL isShowHint;

@property (nonatomic, assign)BOOL isNeedRefresh;
@property (nonatomic, assign)BOOL isViewCurrentShow;
// 当前刷新的页面
@property (nonatomic, assign)int page;

- (void)refreshTable;


- (void)showNoLocationHint;
- (void)removeNoLocation;

//  没有数据提示，并且有网络时出现
- (void)showNotDataHintWithImageString:(NSString *)stringImage title:(NSString *)title;


- (void)showNotDataHintWithImageString:(NSString *)stringImage title:(NSString *)title detailTitle:(NSString *)detailTitle;

- (void)removeNotDataHint;
    
// 网络提示 : 当 数据为0 并且没有网络时候就出现
- (void)removeNetworkErrorHint ;
- (void)showNetworkErrorHint ;

- (void)tapClick;

- (void)refreshFauile:(NSArray *)arrayM;
- (void)refreshSuccess ;


  @end
