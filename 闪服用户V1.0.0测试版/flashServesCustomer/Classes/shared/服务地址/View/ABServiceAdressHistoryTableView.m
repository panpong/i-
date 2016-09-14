

//
//  ABServiceAdressHistoryTableView.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/27.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServiceAdressHistoryTableView.h"
#import "ABLocation.h"
#import "ABServiceAdressHistoryCell.h"
#import "UIView+Extention.h"
#import "ABHistoryLocations.h"
#import "ABNetworkManager.h"

#define SIZE_HEIGHT_TABLEVIEWCELL 55  // tableViewCell的高度
#define COUNT_TABLEVIEW_MAX 20 // 历史记录条数上限s

@interface ABServiceAdressHistoryTableView ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) NSMutableArray *locations;
@property(nonatomic,strong) UIAlertView *deleteAlertView; // 删除历史记录时候的提示
@property(nonatomic,assign) NSInteger deleteIndex;  // 删除的历史记录索引

@end

@implementation ABServiceAdressHistoryTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 要和xib 中 cell 的reuse 一样
static NSString * const reuseID = @"serviceAdressHistoryCellReuseId";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"ABServiceAdressHistoryCell" bundle:nil] forCellReuseIdentifier:reuseID];
        self.rowHeight = SIZE_HEIGHT_TABLEVIEWCELL;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.separatorColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)serviceAdressHistoryTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    ABServiceAdressHistoryTableView *serviceAdressHistoryTableView = [[ABServiceAdressHistoryTableView alloc] initWithFrame:frame style:style];
    return serviceAdressHistoryTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.historyLocations.count > 0) {
        self.backgroundColor = KWhiteColor;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ISSHOWHISTORYLABEL object:@"YES"];
        return 1;
    } else {
        self.backgroundColor = KGrayGroundColor;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ISSHOWHISTORYLABEL object:@"NO"];
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 动态改变tableview的高度
//    self.height = SIZE_HEIGHT_TABLEVIEWCELL * self.locations.count;
//    self setContentSize:CGSizeMake(ScreenWidth, self.height)
    if (self.historyLocations.count > 20) {
        return COUNT_TABLEVIEW_MAX;
    }
    return self.historyLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.创建cell
    ABServiceAdressHistoryCell *cell = [ABServiceAdressHistoryCell serviceAdressHistoryCell:tableView];
    cell.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteSelectedHistoryItem:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2. 取数据
//    ABLocation *location = self.locations[indexPath.row];
    ABLocation *location = [self historyLocations][indexPath.row];
    cell.backgroundColor = KWhiteColor;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@%@",location.name,location.no];
    cell.adressLabel.text = location.address;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. 取数据
    ABLocation *location = self.historyLocations[indexPath.row];
    // 2. 填充 - 代理
    if([self.historyDelegate respondsToSelector:@selector(serviceAdressHistoryTableView:DidSelectLocation:)]) {
        [self.historyDelegate serviceAdressHistoryTableView:self DidSelectLocation:location];
    }
}

- (void)deleteSelectedHistoryItem:(UIButton *)button {
    self.deleteIndex = button.tag;
    [self.deleteAlertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        // 之前是本地缓存
//        [[ABHistoryLocations sharedHistoryLocations] deleteLocation:self.deleteIndex];
        
        // 调用删除接口
        [self deleteTheLocationWithId:self.historyLocations[self.deleteIndex].locationId];
        [self.historyLocations removeObjectAtIndex:self.deleteIndex];
        
        // 删除后刷新
        [self reloadData];
    }
}

- (void)deleteTheLocationWithId:(NSString *)locationId {
    
    NSString *urlStr = @"customer/locations/v1.0.1/delete";
    
    [KABNetworkManager POST:urlStr parameters:@{@"id" : locationId} success:^(id responseObject) {
        if ([@"200" isEqualToString:responseObject[@"errcode"]]) {
            ABLog(@"删除成功:locationId:%@",locationId);
        }
    } failure:^(id object) {
        ABLog(@"删除失败:object:%@",object);
        ABLog(@"删除失败:locationId:%@",locationId);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ISSHOWHISTORYLABEL object:nil];
}

- (void)setHistoryLocations:(NSMutableArray<ABLocation *> *)historyLocations {
    if (_historyLocations != historyLocations) {
        _historyLocations = historyLocations;
        [self reloadData];
    }
}

- (UIAlertView *)deleteAlertView {
    if (!_deleteAlertView) {
        _deleteAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否删除该条记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _deleteAlertView;
}



@end
