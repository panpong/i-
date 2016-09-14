//
//  KYSServerHeaderView.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/6/3.
//  Copyright © 2016年 002. All rights reserved.
//

#import "KYSServerHeaderView.h"
#import "NSString+KYSAddition.h"

@interface KYSServerHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *citysLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *citysLabelHeight;

@end

@implementation KYSServerHeaderView

- (void)setDataWithDic:(NSDictionary *)dic{
    //14+(17)+11+(14)+14+10
    
    //服务项
    NSString *content=dic[@"content"];
    content = [content stringByReplacingOccurrencesOfString:@"|" withString:@"  |  "];
    _itemLabel.text=content?:@"";
    NSInteger itemHeight = ceilf([content heightForFont:_itemLabel.font width:ScreenWidth-30]);
    itemHeight=itemHeight>17?itemHeight:17;
    
    
    //城市
    NSString *citys=dic[@"citys"];
    citys = [citys stringByReplacingOccurrencesOfString:@"," withString:@"、"];
    _citysLabel.text=citys?:@"";
    NSInteger cityHeight = ceilf([citys heightForFont:_citysLabel.font width:ScreenWidth-15-82]);
    cityHeight=cityHeight>14?cityHeight:14;
    
    self.frame=CGRectMake(0, 0, ScreenWidth, 14+(itemHeight)+11+(cityHeight)+14+10);
    
    _itemLabelHeight.constant=itemHeight;
    _citysLabelHeight.constant=cityHeight;
}

/*
 // 获取当前界面的第一响应对象
 UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
 UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
 if (firstResponder==_desTextView) {
 return;
 }
 // 退出键盘
 [firstResponder resignFirstResponder];
 */

- (IBAction)tap:(id)sender {
    // 获取当前界面的第一响应对象
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    // 退出键盘
    [firstResponder resignFirstResponder];
}

@end
