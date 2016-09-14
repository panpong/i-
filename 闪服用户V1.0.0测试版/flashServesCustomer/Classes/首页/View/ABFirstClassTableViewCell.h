//
//  ABFirstClassTableViewCell.h
//  flashServesCustomer
//
//  Created by 002 on 16/6/20.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABFirstClassSubclassCollectionView.h"

@interface ABFirstClassTableViewCell : UITableViewCell

// 包含iconImageView、nameLabel的头部视图
@property(nonatomic,strong) UIView *headerView;

// 一级分类图片
@property(nonatomic,strong) UIImageView *iconImageView;

// 图片描述 - 一级分类名称
@property(nonatomic,strong) UILabel *nameLabel;

// 分割线
@property(nonatomic,strong) UIView *sepView;

// 显示服务项的collectionview
@property(nonatomic,strong) ABFirstClassSubclassCollectionView *firstClassSubclassCollectionView;

/**
 构造方法
 
 @param reuseId            重用id
 @param tableView          tableView
 @param indexPath          indexPath
 @param firstClassSubclass 数据源
 
 @return ABFirstClassTableViewCell
 */
+ (instancetype)firstClassTableViewCellWithReuseId:(NSString *)reuseId inTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath firstClassSubclass:(ABFirstClassSubclass *)firstClassSubclass;


@end

