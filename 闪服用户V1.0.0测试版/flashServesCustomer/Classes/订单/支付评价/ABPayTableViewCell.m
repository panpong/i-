//
//  ABPayTableViewCell.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABPayTableViewCell.h"

@interface ABPayTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


@end

@implementation ABPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithDic:(NSDictionary *)dic{
    _titleImageView.image=[UIImage imageNamed:dic[@"image"]];
    _titleImageView.backgroundColor = [UIColor whiteColor];
    _titleLabel.text=dic[@"title"];
    _detailLabel.text=dic[@"detail"];
    _isSelected=[dic[@"selected"] intValue]?YES:NO;
    [_selectBtn setImage:[UIImage imageNamed:_isSelected?@"支付订单-选择1":@"支付订单-选择2"] forState:UIControlStateNormal];
    _selectBtn.enabled = NO;
}

- (void)setIsSelected:(BOOL)isSelected{
    
    _isSelected=isSelected;
    [_selectBtn setImage:[UIImage imageNamed:_isSelected?@"支付订单-选择1":@"支付订单-选择2"] forState:UIControlStateNormal];
}

#pragma mark - Action
- (IBAction)selectAction:(id)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(selectionCell:)]) {
        [_delegate selectionCell:self];
    }
}

@end
