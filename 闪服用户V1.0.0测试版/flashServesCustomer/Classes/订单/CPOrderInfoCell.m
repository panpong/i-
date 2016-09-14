//
//  CPOrderInfoCell.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/27.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPOrderInfoCell.h"
#import "CPViewOrderServer.h"
#import <UIImageView+WebCache.h>
#import "CPHeadGreyLable.h"
@interface CPOrderInfoCell()


@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *labelPrice;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

// 服务View高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewServer;

@property (weak, nonatomic) IBOutlet CPViewOrderServer *viewOrderServer;


@property (weak, nonatomic) IBOutlet CPHeadGreyLable *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lableWorkId;


@end


@implementation CPOrderInfoCell

+ (instancetype)orderInfoCell
:(UITableView *)table {
    
    // 要和xib 中 cell 的reuse 一样
    static NSString * const reuseID = @"CPOrderInfoCell";
    CPOrderInfoCell * cell = [table dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        [table registerNib:[UINib nibWithNibName:@"CPOrderInfoCell" bundle:nil] forCellReuseIdentifier:reuseID];
        cell = [table dequeueReusableCellWithIdentifier:reuseID];
      
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// 拨打电话
- (IBAction)buttonPhoneClick:(id)sender {

    NSURL *phoneURL = [NSURL URLWithString: [NSString stringWithFormat: @"tel:/%@",_modal.engineerTel]];
    UIWebView *  phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self addSubview:phoneCallWebView];
   
}



-(void)setModal:(CPModalOrder *)modal {
    
    _modal = modal;
    
    if (_modal.stringOriginPrice.length == 0) {
        
        _labelPrice.hidden = YES;
        _labelTotalPrice.hidden = YES;
        
    }
    _labelPrice.text = [NSString stringWithFormat:@"%@元",_modal.price ];
    _labelTime.text = [_modal stringHourceTime:_modal.duration];
    _labelName.text = _modal.engineerName;
    _lableWorkId.text = _modal.work_id;
    [_imageViewIcon sd_setImageWithURL:[NSURL URLWithString: _modal.engineerThumburl] placeholderImage:nil];
    
    _heightViewServer.constant = _modal.services.count * 28 + 14;
    _viewOrderServer.modal = _modal;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
