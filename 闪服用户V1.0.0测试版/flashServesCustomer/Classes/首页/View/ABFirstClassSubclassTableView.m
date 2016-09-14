//
//  ABFirstClassSubclassTableView.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABFirstClassSubclassTableView.h"
#import "ABFirstClassSubclassCollectionView.h"
#import "UIView+Extention.h"
#import "UILabel+Extention.h"
#import <SDWebImageManager.h>
#import "ABFirstClassTableViewCell.h"

#define COUNT_LINE_COLLECTIONVIEW 3  // tableView的每个cell下包裹的collectionView每行的显示个数
#define SIZE_HEIGHT_COLLECTIONVIEWCELL 60 // tableView的每个cell下包裹的collectionViewcell的高度
#define SIZE_HEIGHT_COLLECTIONVIEWHEADERVIEW 35 // tableView的每个cell下包裹的collectionView的HeaderView的高度
#define SIZE_HEIGHT_COLLECTIONVIEWFOOTERVIEW 10 // tableView的每个cell下包裹的collectionView的FooterView的高度
#define SIZE_WIDTH_HEADERVIEW_IMAGEVIEW 25   // tableview的HeaderView里面图像的宽度
#define SIZE_HEIGHT_HEADERVIEW_IMAGEVIEW 25   // tableview的HeaderView里面图像的高度
#define PADDING_HEADERVIEW_NAMELABEL_LEFT 15  // tableview的HeaderView里面label距离图像的间距

@interface ABFirstClassSubclassTableView ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation ABFirstClassSubclassTableView


// 可重用cell的ID
static NSString * const ABFirstClassSubclassTableViewReuseId = @"ABFirstClassSubclassTableViewReuseId";

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame firstClassSubclass:(NSArray<ABFirstClassSubclass *> *)firstClassSubclass {
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    [self registerClass:[ABFirstClassTableViewCell class] forCellReuseIdentifier:ABFirstClassSubclassTableViewReuseId];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = KGrayGroundColor;
    self.dataSource = self;
    self.delegate = self;
    if (firstClassSubclass && firstClassSubclass.count > 0) {
        self.firstClassSubclass = firstClassSubclass;
        [self reloadData];
    }
    
    return self;
}

+ (instancetype)firstClassSubclassTableViewWithFrame:(CGRect)frame firstClassSubclass:(NSArray<ABFirstClassSubclass *> *)firstClassSubclass {
    ABFirstClassSubclassTableView *firstClassSubclassTableView = [[ABFirstClassSubclassTableView alloc] initWithFrame:frame firstClassSubclass:firstClassSubclass];
    return firstClassSubclassTableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.firstClassSubclass.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.firstClassSubclass.count > 0) {
        return 1;
    } else {
        return 0;
    }
}

//#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    // 1. 获取数据模型
//    ABFirstClassSubclass *firstClassSubclass = self.firstClassSubclass[indexPath.section];
//    ABLog(@"firstClassSubclass.services%@",firstClassSubclass.service);
//    ABLog(@"firstClassSubclass.services.count%zd",firstClassSubclass.service.count);
//
//    NSInteger count = 0;
//    if(firstClassSubclass.service.count % COUNT_LINE_COLLECTIONVIEW == 0) {
//        count = firstClassSubclass.service.count / COUNT_LINE_COLLECTIONVIEW;
//    } else {
//        count = firstClassSubclass.service.count / COUNT_LINE_COLLECTIONVIEW + 1;
//     }
//    CGFloat height = (CGFloat)(count * SIZE_HEIGHT_COLLECTIONVIEWCELL + SIZE_HEIGHT_COLLECTIONVIEWHEADERVIEW + SIZE_HEIGHT_COLLECTIONVIEWFOOTERVIEW);
//    
//    return height;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 0. 获取数据模型
    ABFirstClassSubclass *firstClassSubclass = self.firstClassSubclass[indexPath.section];
    
    // 1. 创建cell
    ABFirstClassTableViewCell *cell = [ABFirstClassTableViewCell firstClassTableViewCellWithReuseId:ABFirstClassSubclassTableViewReuseId inTableView:tableView AtIndexPath:indexPath firstClassSubclass:firstClassSubclass];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    // 设置选中样式
    cell.backgroundColor = KGrayGroundColor;
    
    // 2.添加显示头
    [cell.contentView addSubview:cell.headerView];
    
    // 2.2 headerView的imageView
    NSURL *url = [NSURL URLWithString:firstClassSubclass.thumb_url];
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //        ABLog(@"下载进度%lf",(CGFloat)(receivedSize / expectedSize));
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [cell.headerView addSubview:cell.iconImageView];
        cell.iconImageView.image = image;
        cell.iconImageView.width = SIZE_WIDTH_HEADERVIEW_IMAGEVIEW;
        cell.iconImageView.height = SIZE_HEIGHT_HEADERVIEW_IMAGEVIEW;
        cell.iconImageView.x = PADDING_30PX;
        cell.iconImageView.centerY = cell.headerView.height / 2;
    }];
    
    // 2.3 headerView的nameLabel
    cell.nameLabel.text = firstClassSubclass.name;
    [cell.nameLabel sizeToFit];
    [cell.headerView addSubview:cell.nameLabel];
    cell.nameLabel.width = ScreenWidth - (PADDING_30PX + SIZE_WIDTH_HEADERVIEW_IMAGEVIEW + PADDING_HEADERVIEW_NAMELABEL_LEFT);
    cell.nameLabel.x = PADDING_30PX + SIZE_WIDTH_HEADERVIEW_IMAGEVIEW + PADDING_HEADERVIEW_NAMELABEL_LEFT;
    cell.nameLabel.centerY = cell.headerView.height / 2;
    [cell.headerView addSubview:cell.sepView];
    
    // 3. 添加ABFirstClassSubclassCollectionView并且布局
    // 每个collectionView显示的行数
    NSInteger count = 0;
    
    if(firstClassSubclass.service.count % COUNT_LINE_COLLECTIONVIEW == 0) {
        count = firstClassSubclass.service.count / COUNT_LINE_COLLECTIONVIEW;
    } else {
        count = firstClassSubclass.service.count / COUNT_LINE_COLLECTIONVIEW + 1;
    }
    
    cell.firstClassSubclassCollectionView.y = SIZE_HEIGHT_COLLECTIONVIEWHEADERVIEW;
    cell.firstClassSubclassCollectionView.width = ScreenWidth;
    cell.firstClassSubclassCollectionView.height = count * SIZE_HEIGHT_COLLECTIONVIEWCELL;
    
    cell.firstClassSubclassCollectionView.firstClassServesArray = firstClassSubclass.service;
    cell.firstClassSubclassCollectionView.viewController = self.viewController;
    [cell.contentView addSubview:cell.firstClassSubclassCollectionView];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. 获取数据模型
    ABFirstClassSubclass *firstClassSubclass = self.firstClassSubclass[indexPath.section];
    ABLog(@"firstClassSubclass.services%@",firstClassSubclass.service);
    ABLog(@"firstClassSubclass.services.count%zd",firstClassSubclass.service.count);
    
    NSInteger count = 0;
    if(firstClassSubclass.service.count % COUNT_LINE_COLLECTIONVIEW == 0) {
        count = firstClassSubclass.service.count / COUNT_LINE_COLLECTIONVIEW;
    } else {
        count = firstClassSubclass.service.count / COUNT_LINE_COLLECTIONVIEW + 1;
    }
    CGFloat height = (CGFloat)(count * SIZE_HEIGHT_COLLECTIONVIEWCELL + SIZE_HEIGHT_COLLECTIONVIEWHEADERVIEW + SIZE_HEIGHT_COLLECTIONVIEWFOOTERVIEW);
    
    return height;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return SIZE_HEIGHT_COLLECTIONVIEWHEADERVIEW;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return SIZE_HEIGHT_COLLECTIONVIEWFOOTERVIEW;
//}

//
//- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section {
//    
//    // 1. 取数据模型
//    ABFirstClassSubclass *firstClassSubclass = self.firstClassSubclass[section];
//    
//    // 2. 创建headerView及其子视图
//    
//    // 2.1 headerView
//    static NSString *const firstClassSubclassTableViewHeaderViewReuseID = @"firstClassSubclassTableViewHeaderViewReuseID";
//    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:firstClassSubclassTableViewHeaderViewReuseID];
//    headerView.width = ScreenWidth;
//    headerView.height = SIZE_HEIGHT_COLLECTIONVIEWHEADERVIEW;
//
//    // 2.2 headerView的imageView
//    NSURL *url = [NSURL URLWithString:firstClassSubclass.thumb_url];
//    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
////        ABLog(@"下载进度%lf",(CGFloat)(receivedSize / expectedSize));
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        [headerView addSubview:imageView];
//        
//        imageView.width = SIZE_WIDTH_HEADERVIEW_IMAGEVIEW;
//        imageView.height = SIZE_HEIGHT_HEADERVIEW_IMAGEVIEW;
//        imageView.x = PADDING_30PX;
//        imageView.centerY = headerView.height / 2;
//    }];
//    
//    // 2.3 headerView的nameLabel
//    UILabel *nameLabel = [UILabel initWithTitle:firstClassSubclass.name fontSize:PADDING_30PX color:KBlackColor];
//    [headerView addSubview:nameLabel];
//    
//    nameLabel.x = PADDING_30PX + SIZE_WIDTH_HEADERVIEW_IMAGEVIEW + PADDING_HEADERVIEW_NAMELABEL_LEFT;
//    nameLabel.centerY = headerView.height / 2;
//    
//    return headerView;
//}
//
//- (UITableViewHeaderFooterView *)footerViewForSection:(NSInteger)section {
//    static NSString *const firstClassSubclassTableViewFooterViewReuseID = @"firstClassSubclassTableViewFooterViewReuseID";
//    UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:firstClassSubclassTableViewFooterViewReuseID];
//    
//    footerView.backgroundColor = KGrayGroundColor;
//    
//    footerView.width = ScreenWidth;
//    footerView.height = SIZE_HEIGHT_COLLECTIONVIEWFOOTERVIEW;
//    
//    // 顶部加一条分割线
//    UIView *sep = [[UIView alloc] init];
//    sep.backgroundColor = KColorLine;
//    sep.width = ScreenWidth;
//    sep.height = 1;
//    sep.x = 0;
//    sep.y = 0;
//    
//    [footerView addSubview:sep];
//    
//    return footerView;
//}


@end
