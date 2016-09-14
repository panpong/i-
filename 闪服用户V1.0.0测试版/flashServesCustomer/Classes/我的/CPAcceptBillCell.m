//
//  CPAcceptBillCell.m
//  flashServesCustomer
//
//  Created by yjin on 16/6/2.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPAcceptBillCell.h"
#import "CPHeadGreyLable.h"
#import "CPModalOrder.h"
#import "CPModalOrder.h"
@interface CPAcceptBillCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelPrice;

@property (weak, nonatomic) IBOutlet CPHeadGreyLable *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *labelState;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineMarginX;

@end


@implementation CPAcceptBillCell

+ (instancetype)acceptBillCell:(UITableView *)table {
    
    // 要和xib 中 cell 的reuse 一样
    static NSString * const reuseID = @"CPAcceptBillCell";
    CPAcceptBillCell * cell = [table dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        [table registerNib:[UINib nibWithNibName:@"CPAcceptBill" bundle:nil] forCellReuseIdentifier:reuseID];
        cell = [table dequeueReusableCellWithIdentifier:reuseID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModal:(NSDictionary *)modal {
    
    _modal = modal;
    
    float priceA =  [modal[@"money"] floatValue] ;
    ;
    NSString *price = [NSString stringWithFormat:@"%@元",  [NSString stringWithFormat:@"%0.2f",priceA]];
    
    _labelPrice.text = price;
    _labelState.text = modal[@"status_text"];
    _labelTime.text = [CPModalOrder stringTimeWithhengNoWeekFormat:modal[@"created_at"]] ;

}

- (void)setIsLastCell:(BOOL)isLastCell {
    
    _isLastCell = isLastCell;
    if (_isLastCell == YES) {
        
        _lineMarginX.constant = 0;
        
    }else {
        
           _lineMarginX.constant = 15;
    }
    
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
