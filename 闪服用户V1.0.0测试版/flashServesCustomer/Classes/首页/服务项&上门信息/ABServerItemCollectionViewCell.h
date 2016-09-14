//
//  ABServerItemCollectionViewCell.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/23.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABServerItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,assign)BOOL hasSelected;

- (void)setTitle:(NSString *)title;

@end
