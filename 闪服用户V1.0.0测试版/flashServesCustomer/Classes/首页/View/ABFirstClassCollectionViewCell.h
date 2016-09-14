//
//  ABFirstClassCollectionViewCell.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFirstClassCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic, copy) NSString *id;

@end
