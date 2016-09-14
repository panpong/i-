//
//  ABCollectionHeaderView.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABCollectionHeaderViewDelegate <NSObject>

- (void)minusAction:(NSInteger)count;
- (void)addAction:(NSInteger)count;

@end


@interface ABCollectionHeaderView : UICollectionReusableView


@property (weak, nonatomic) IBOutlet UIView *headerSectionView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *serverCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceCostLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;

@property(nonatomic,weak)__weak id<ABCollectionHeaderViewDelegate> delegate;

@end
