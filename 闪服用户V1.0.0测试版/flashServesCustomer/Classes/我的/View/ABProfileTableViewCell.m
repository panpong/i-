//
//  ABProfileTableViewCell.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/18.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABProfileTableViewCell.h"
#import "NSString+KYSAddition.h"

@interface ABProfileTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneBtnWidth;

@end

@implementation ABProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithDic:(NSDictionary *)dic{
    _titleImageView.image=[UIImage imageNamed:dic[@"image"]];
    _titleLabel.text=dic[@"title"];
    
    NSInteger tag=[dic[@"tag"] integerValue];
    if (1==tag) {
        //电话
        _phoneBtn.hidden=NO;
        [_phoneBtn setTitle:SERVICE_PHONE_NUM forState:UIControlStateNormal];
        NSString *phoneText=self.phoneBtn.titleLabel.text;
        CGFloat phoneWidth=phoneText.length?[phoneText widthForFont:self.phoneBtn.titleLabel.font]:0.0;
        _phoneBtnWidth.constant=phoneWidth+10;
        [self setNeedsLayout];
    }else{
        _phoneBtn.hidden=YES;
    }
}

- (IBAction)callAction:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",SERVICE_PHONE_NUM];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


@end
