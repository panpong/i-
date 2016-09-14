//
//  ABFirstClassTableViewCell.m
//  flashServesCustomer
//
//  Created by 002 on 16/6/20.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABFirstClassTableViewCell.h"
#import "ABFirstClassSubclass.h"
#import "ABFirstClassSubclassCollectionView.h"
#import "UIView+Extention.h"

#define COUNT_LINE_COLLECTIONVIEW 3  // tableView的每个cell下包裹的collectionView每行的显示个数
#define SIZE_HEIGHT_COLLECTIONVIEWCELL 60 // tableView的每个cell下包裹的collectionViewcell的高度
#define SIZE_HEIGHT_COLLECTIONVIEWHEADERVIEW 35 // tableView的每个cell下包裹的collectionView的HeaderView的高度
#define SIZE_HEIGHT_COLLECTIONVIEWFOOTERVIEW 10 // tableView的每个cell下包裹的collectionView的FooterView的高度
#define SIZE_WIDTH_HEADERVIEW_IMAGEVIEW 25   // tableview的HeaderView里面图像的宽度
#define SIZE_HEIGHT_HEADERVIEW_IMAGEVIEW 25   // tableview的HeaderView里面图像的高度
#define PADDING_HEADERVIEW_NAMELABEL_LEFT 15  // tableview的HeaderView里面label距离图像的间距

// 可重用cell的ID
static NSString * const ABFirstClassSubclassTableViewReuseId = @"ABFirstClassSubclassTableViewReuseId";

@interface ABFirstClassTableViewCell ()

@property(nonatomic,strong) ABFirstClassSubclass *firstClassSubclass;


@end

@implementation ABFirstClassTableViewCell

+ (instancetype)firstClassTableViewCellWithReuseId:(NSString *)reuseId inTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath firstClassSubclass:(ABFirstClassSubclass *)firstClassSubclass {
    ABFirstClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ABFirstClassSubclassTableViewReuseId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    // 设置选中样式
    cell.backgroundColor = KGrayGroundColor;
    cell.firstClassSubclass = firstClassSubclass;
    
    return cell;
}

#pragma mark - 懒加载
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SIZE_HEIGHT_COLLECTIONVIEWHEADERVIEW)];
        _headerView.backgroundColor = KWhiteColor;
    }
    return _headerView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:PADDING_30PX];
        _nameLabel.textColor = KBlackColor;
    }
    return _nameLabel;
}

- (UIView *)sepView {
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = KColorLine;
        _sepView.width = ScreenWidth;
        _sepView.height = 1;
        _sepView.x = 0;
        _sepView.y = SIZE_HEIGHT_COLLECTIONVIEWHEADERVIEW - 1;
    }
    return _sepView;
}

- (ABFirstClassSubclassCollectionView *)firstClassSubclassCollectionView {
    if (!_firstClassSubclassCollectionView) {        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(ScreenWidth / COUNT_LINE_COLLECTIONVIEW, SIZE_HEIGHT_COLLECTIONVIEWCELL);
        _firstClassSubclassCollectionView = [[ABFirstClassSubclassCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    }
    return _firstClassSubclassCollectionView;
}

@end
