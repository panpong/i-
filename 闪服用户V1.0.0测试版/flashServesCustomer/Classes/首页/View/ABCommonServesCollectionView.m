//
//  ABCommonServesCollectionView.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//  ‘常用服务’CollectionView

#import "ABCommonServesCollectionView.h"
#import "ABCommonServesCollectionViewCell.h"
#import <SDWebImageManager.h>
#import "ABNetworkManager.h"
#import "CustomToast.h"
#import "ABServerItem.h"
#import "ABServerItemViewController.h"
#import "UMMobClick/MobClick.h"

@interface ABCommonServesCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>


@end

@implementation ABCommonServesCollectionView

// 可重用cell的ID
static NSString * const ABCommonServesCollectionViewCellReuesId = @"ABCommonServesCollectionViewCellReuesId";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = KWhiteColor;
    // 注册cell - nil默认就是[NSBundle mainBundle]
    [self registerNib:[UINib nibWithNibName:@"ABCommonServesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ABCommonServesCollectionViewCellReuesId];
    // 设置代理
    self.dataSource = self;
    self.delegate = self;
    self.pagingEnabled = NO;
    self.scrollEnabled = NO;


    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.services.count > 0) {
        return 1;
    } else {
        return 0;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.services.count > 0) {
        return self.services.count;
    } else {
        return 0;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ABCommonServesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ABCommonServesCollectionViewCellReuesId forIndexPath:indexPath];
    NSDictionary *dict = self.services[indexPath.item];
    NSURL *url = [NSURL URLWithString:dict[@"thumb_url2"]];
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        // 按照iconImageView的大小填充图片
        cell.iconImageView.contentMode = UIViewContentModeScaleToFill;
        cell.iconImageView.image = image;
    }];
    
    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",indexPath.item+1]];
    cell.descLabel.text = dict[@"name"];
    cell.id = dict[@"id"];
    ABLog(@"dict:%@",dict);
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 友盟统计
    NSString *eventId = [NSString stringWithFormat:@"commonServesItem%ld",indexPath.item + 1];
    [MobClick event:eventId];
    // 1. 取数据
    NSDictionary *dict = self.services[indexPath.item];
    ABFirstClassServes *firstClassServes = [ABFirstClassServes firstClassServesWithDict:dict];
    
    // 2. 跳转到‘服务项详情’控制器
    ABServerItemViewController *serverItemViewController = [ABServerItemViewController getServerItemViewController];    
    // 必须赋值
    serverItemViewController.firstClassServes = firstClassServes;
    serverItemViewController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:serverItemViewController animated:YES];
}

- (void)setServices:(NSArray *)services {
    if (_services != services) {
        _services = services;
        [self reloadData];
    }
}

@end
