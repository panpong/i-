
//
//  CPOrdeQuestionOneCellTableViewCell.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPOrdeQuestionOneCellTableViewCell.h"
#import "CPTextLineCell.h"
@interface CPOrdeQuestionOneCellTableViewCell()

// 依次按@[@"故障类型",@"服务类型",@"设备类型",@"系统类型",@"品牌",@"部件"];

@property (weak, nonatomic) IBOutlet CPTextLineCell *viewTextLine1;

@property (weak, nonatomic) IBOutlet CPTextLineCell *viewTextLine2;

@property (weak, nonatomic) IBOutlet CPTextLineCell *viewTextLine3;

@property (weak, nonatomic) IBOutlet CPTextLineCell *viewTextLine4;

@property (weak, nonatomic) IBOutlet CPTextLineCell *viewTextLine5;

@property (weak, nonatomic) IBOutlet CPTextLineCell *viewTextLine6;


@end


@implementation CPOrdeQuestionOneCellTableViewCell


+ (instancetype)OrdeQuestionOneCellTableViewCell
:(UITableView *)table {
    
    // 要和xib 中 cell 的reuse 一样
    static NSString * const reuseID = @"CPOrdeQuestionOneCellTableViewCell";
    CPOrdeQuestionOneCellTableViewCell * cell = [table dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        [table registerNib:[UINib nibWithNibName:@"CPOrdeQuestionOneCellTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
        cell = [table dequeueReusableCellWithIdentifier:reuseID];
        
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModal:(CPModalOrder *)modal {
    
    _modal = modal;
    [self settingFaulureStyle];
}


- (void)settingFaulureStyle {
    
    // 按照这个 顺序 排序的：
    // 故障类型、服务类型、设备类型、系统类型、部件
    NSArray *arrayHit = @[@"故障类型",@"服务类型",@"设备类型",@"系统类型",@"品牌",@"部件"];
    
    NSArray *arrayView = @[_viewTextLine1,_viewTextLine2,_viewTextLine3,_viewTextLine4,_viewTextLine5,_viewTextLine6];
    
    NSArray *arrayText = @[_modal.failureTypes,_modal.serviceTypes, _modal.deviceTypes,_modal.osTypes,_modal.deviceBrands,_modal.deviceComponents];
    
    int indexView = 0; // 得到 textView的 顺序
    for (int i = 0 ; i < arrayText.count; i++) {
        
        NSString *stringText = arrayText[i];
        if (stringText.length == 0) {
            
            continue;
        }
        CPTextLineCell *textLineView = arrayView[indexView];
        indexView++;
        [textLineView setLineHint:arrayHit[i] content:arrayText[i] type:CPLineCellTypeHintTextLeftRight];
        
    }
    
    _cellHeight = indexView * 28 + 14;
    
    for (int i = indexView; i < arrayView.count; i++) {
        
        CPTextLineCell *textLineView = arrayView[i];
        [textLineView setLineHint:nil content:nil type:CPLineCellTypeHintText];
        
    }
    
}



- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = kColorBackground;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
