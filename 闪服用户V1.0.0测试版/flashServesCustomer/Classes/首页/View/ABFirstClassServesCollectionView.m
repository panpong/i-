//
//  ABFirstClassServesCollectionView.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//  '一级服务类分项'View

#import "ABFirstClassServesCollectionView.h"
#import "ABFirstClassCollectionViewCell.h"
#import <SDWebImageManager.h>
#import "ABFirstClassSubclass.h"
#import "ABNetworkManager.h"
#import "CustomToast.h"
#import "NSObject+YYModel.h"
#import "ABFirstClassSubclassViewController.h"

@interface ABFirstClassServesCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) NSArray *images; //‘一级服务类分项’展示图片名称
@property(nonatomic,strong) NSArray *names; //‘一级服务类分项’名称

@end

@implementation ABFirstClassServesCollectionView

// 可重用cell的ID
static NSString * const ABFirstClassServesCollectionViewCellREUSEID = @"ABFirstClassServesCollectionViewCellREUSEID";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = KWhiteColor;
    // 注册cell - nil默认就是[NSBundle mainBundle]
    [self registerNib:[UINib nibWithNibName:@"ABFirstClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ABFirstClassServesCollectionViewCellREUSEID];
    // 设置代理
    self.dataSource = self;
    self.delegate = self;
    self.pagingEnabled = NO;
    self.scrollEnabled = NO;
    return self;
}

+ (instancetype)firstClassServesWithClasses:(NSArray *)classes frame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    ABFirstClassServesCollectionView *collectionView = [[ABFirstClassServesCollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [collectionView reloadData];
    return collectionView;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.images.count > 0) {
        return self.images.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ABFirstClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ABFirstClassServesCollectionViewCellREUSEID forIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:self.images[indexPath.item]];
    cell.iconImageView.image = image;
    cell.descLabel.text = self.names[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPat {    
    
    // 跳转到‘一级服务分类项’控制器
    ABFirstClassSubclassViewController *firstClassSubclassViewController = [ABFirstClassSubclassViewController firstClassSubclassViewControllerWithClassName:self.names[indexPat.item]];
    firstClassSubclassViewController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:firstClassSubclassViewController animated:YES];
    
}

- (NSArray *)images {
    if (!_images) {
        _images = [NSArray arrayWithObjects:@"首页-电脑支持",@"首页-服务器及网络",@"首页-手机_平板", nil];
    }
    return _images;
}

- (NSArray *)names {
    if (!_names) {
        _names = [NSArray arrayWithObjects:@"电脑支持",@"服务器及网络",@"手机/平板", nil];
    }
    return _names;
}

@end
