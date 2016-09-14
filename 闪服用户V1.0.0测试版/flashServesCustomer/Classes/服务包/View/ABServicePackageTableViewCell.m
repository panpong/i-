//
//  ABServicePackageTableViewCell.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/6/2.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServicePackageTableViewCell.h"
#import "NSString+KYSAddition.h"
#import "NSDate+KYSAddition.h"
#import "KYSNetwork.h"

@interface ABServicePackageTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *citysLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *placeOrderBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityTimesViewHeight;

@property(nonatomic,strong)NSDictionary *dataDic;

@end


@implementation ABServicePackageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _placeOrderBtn.layer.borderWidth=1;
    _placeOrderBtn.layer.borderColor=[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1].CGColor;
    _placeOrderBtn.layer.cornerRadius=3.0;
    _placeOrderBtn.layer.masksToBounds=YES;
}

- (void)setDataWithDic:(NSDictionary *)dic{
    //(26+)+(42+)+35+10
    _dataDic=dic;
    
    //服务项
    NSString *content=_dataDic[@"content"];
    content = [content stringByReplacingOccurrencesOfString:@"|" withString:@"  |  "];
    _itemLabel.text=content?:@"";
    NSInteger itemHeight = [content heightForFont:_itemLabel.font width:ScreenWidth-30];
    _itemViewHeight.constant=26+(itemHeight>19?itemHeight:19)+1;
    
    //城市
    NSString *citys=_dataDic[@"citys"];
    citys = [citys stringByReplacingOccurrencesOfString:@"," withString:@"、"];
    _citysLabel.text=citys?:@"";
    NSInteger cityHeight = [citys heightForFont:_citysLabel.font width:ScreenWidth-15-82];
    _cityTimesViewHeight.constant=42+(cityHeight>18?cityHeight:18)+1;
    
    //服务次数
    NSInteger totalTimes=[_dataDic[@"total_times"] integerValue];
    NSInteger leftTimes=[_dataDic[@"left_times"] integerValue];
    NSMutableAttributedString *attributeString=[[NSMutableAttributedString alloc] init];
    {
        NSString *serverTimesStr=[NSString stringWithFormat:@"%ld",(long)(leftTimes)];
        NSDictionary *attDic=@{NSForegroundColorAttributeName:_itemLabel.textColor,
                               NSFontAttributeName:_timesLabel.font};
        NSAttributedString *attServerStr=[[NSAttributedString alloc] initWithString:serverTimesStr attributes:attDic];
        [attributeString appendAttributedString:attServerStr];
    }
    {
        NSString *totalTimesStr=[NSString stringWithFormat:@" / %ld",(long)totalTimes];
        NSDictionary *attDic=@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                               NSFontAttributeName:_timesLabel.font};
        NSAttributedString *attTotalStr=[[NSAttributedString alloc] initWithString:totalTimesStr attributes:attDic];
        [attributeString appendAttributedString:attTotalStr];
    }
    _timesLabel.attributedText=attributeString;
    
    //下单
    NSInteger type=[_dataDic[@"type"] integerValue];
    _placeOrderBtn.hidden=!(leftTimes&&(2==type));
    
    //服务包有效期
    NSTimeInterval startTime=[_dataDic[@"start_day"] doubleValue];
    NSString *startTimeStr=[[NSDate dateWithTimeIntervalSince1970:startTime] stringWithFormat:@"yyyy-MM-dd"];
    NSTimeInterval endTime=[_dataDic[@"end_day"] doubleValue];
    NSString *endTimeStr=[[NSDate dateWithTimeIntervalSince1970:endTime] stringWithFormat:@"yyyy-MM-dd"];
    _dateLabel.text=[NSString stringWithFormat:@"%@ 至 %@",startTimeStr,endTimeStr];
}


#pragma mark - Action
- (IBAction)placeOrderAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(placeOrderWithDic:)]) {
        [_delegate placeOrderWithDic:_dataDic];
    }
}


@end
