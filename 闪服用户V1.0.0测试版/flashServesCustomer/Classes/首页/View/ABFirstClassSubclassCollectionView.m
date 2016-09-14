//
//  ABFirstClassSubclassCollectionView.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
// '一级服务分类'的服务项列表

#import "ABFirstClassSubclassCollectionView.h"
#import "ABFirstClassSubclassCollectionViewCell.h"
#import "UIView+Extention.h"
#import "ABServerItemViewController.h"
#import "ABNetworkManager.h"
#import "CustomToast.h"
#import "ABServerItem.h"

#define COUNT_LINE_COLLECTIONVIEW 3  // collectionView每行的显示个数
#define SIZE_HEIGHT_COLLECTIONVIEWCELL 60 // collectionViewcell的高度

@interface ABFirstClassSubclassCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ABFirstClassSubclassCollectionView

// 可重用cell的ID
static NSString * const ABFirstClassSubclassCollectionViewCellReuseId = @"ABFirstClassSubclassCollectionViewCellReuseId";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = KWhiteColor;
    // 注册cell - nil默认就是[NSBundle mainBundle]
    [self registerNib:[UINib nibWithNibName:@"ABFirstClassSubclassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ABFirstClassSubclassCollectionViewCellReuseId];
    // 设置代理
    self.dataSource = self;
    self.delegate = self;
    self.pagingEnabled = NO;
    self.scrollEnabled = NO;
    
    return self;
}

- (instancetype)init {
    self = [super init];
    self.backgroundColor = KWhiteColor;
    // 注册cell - nil默认就是[NSBundle mainBundle]
    [self registerNib:[UINib nibWithNibName:@"ABFirstClassSubclassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ABFirstClassSubclassCollectionViewCellReuseId];
    // 设置代理
    self.dataSource = self;
    self.delegate = self;
    self.pagingEnabled = NO;
    self.scrollEnabled = NO;
    return self;
}

+ (instancetype)firstClassSubclassCollectionViewWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    ABFirstClassSubclassCollectionView *firstClassSubclassCollectionView = [[ABFirstClassSubclassCollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    return firstClassSubclassCollectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio {    
    return self.firstClassServesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. 创建cell
    ABFirstClassSubclassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ABFirstClassSubclassCollectionViewCellReuseId forIndexPath:indexPath];
    
    // 设置cell
    cell.backgroundColor = KWhiteColor;
    
    // 2. 获取数据模型
    ABFirstClassServes *firstClassServes = self.firstClassServesArray[indexPath.item];
    
    // 3. 赋值
    cell.nameLabel.text = firstClassServes.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%zd元",([firstClassServes.price intValue] / 100)];
    
    return cell;    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. 获取数据模型
    ABFirstClassServes *firstClassServes = self.firstClassServesArray[indexPath.item];
    
    // 2. 跳转到下一级控制器
    ABServerItemViewController *serverItemViewController = [ABServerItemViewController getServerItemViewController];
    // 必须赋值
    serverItemViewController.firstClassServes = firstClassServes;
    serverItemViewController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:serverItemViewController animated:YES];
    
}

#pragma mark - set方法
- (void)setFirstClassServesArray:(NSArray<ABFirstClassServes *> *)firstClassServesArray {
    if (_firstClassServesArray != firstClassServesArray) {
        _firstClassServesArray = firstClassServesArray;
        
        // 设置线条,竖线 - COUNT_LINE_COLLECTIONVIEW即列数
        for (int i = 1; i < COUNT_LINE_COLLECTIONVIEW; ++i) {
            UIView *sep = [[UIView alloc] init];
            sep.backgroundColor = KColorLine;
            sep.width = 1;
            sep.height = self.height;
            CGFloat colx = ScreenWidth / COUNT_LINE_COLLECTIONVIEW * i;
            CGFloat coly = 0;
            sep.x = colx;
            sep.y = coly;
            
            [self addSubview:sep];
        }
        
        // 设置线条，横线
        // 行数
        NSInteger rows = 0;
        if (firstClassServesArray.count % COUNT_LINE_COLLECTIONVIEW == 0) {
            rows = firstClassServesArray.count / COUNT_LINE_COLLECTIONVIEW;
        } else {
            rows = firstClassServesArray.count / COUNT_LINE_COLLECTIONVIEW + 1;
        }
        for (int i = 0; i < rows; ++i) {
            UIView *sep = [[UIView alloc] init];
            sep.backgroundColor = KColorLine;
            sep.width = ScreenWidth;
            sep.height = 1;
            CGFloat rowx = 0;
            CGFloat rowy = (i + 1) * SIZE_HEIGHT_COLLECTIONVIEWCELL - 1;
            sep.x = rowx;
            sep.y = rowy;
            
            [self addSubview:sep];
        }        
        [self reloadData];
    }    
}

@end
