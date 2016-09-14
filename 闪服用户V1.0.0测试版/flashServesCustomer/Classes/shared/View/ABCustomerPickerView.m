//
//  ABCustomerPickerView.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABCustomerPickerView.h"

@interface ABCustomerPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) UIView *coverView;  // 遮罩View

@end

@implementation ABCustomerPickerView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        self.dataArray = array;
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

+ (instancetype)customerPickerViewWithArray:(NSArray *)array {
    ABCustomerPickerView *customerPickerView = [[ABCustomerPickerView alloc] initWithArray:array];
    return customerPickerView;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dataArray && self.dataArray.count > 0) {
        return self.dataArray.count;
    } else {
        return 0;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    // 取城市名称
    NSDictionary *dict = self.dataArray[row];
    NSString *cityName = dict[@"name"];
//    NSString *provinceName = dict[@"province"];
    if (!(cityName && ![@"" isEqualToString:cityName])) {
        cityName = @"？？？";
        return cityName;
    } else {
        return cityName;
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    // 取城市名称
    NSDictionary *dict = self.dataArray[row];
    NSString *cityName = dict[@"name"];
    if ([self.customerPickerViewDelegate respondsToSelector:@selector(didSelectedCustomerPickerView:)]) {
        [self.customerPickerViewDelegate didSelectedCustomerPickerView:cityName];
    }
    
    ABLog(@"选择了城市：%@",self.dataArray[row]);
}

#pragma mark - 移除遮罩
- (void)removeCoverView {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.coverView.superview) {
            [self.coverView removeFromSuperview];
        }
    }];
}


#pragma mark - 懒加载
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCoverView)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

@end
