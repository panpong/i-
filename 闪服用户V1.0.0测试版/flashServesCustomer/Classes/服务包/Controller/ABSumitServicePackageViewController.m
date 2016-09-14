//
//  ABSumitServicePackageViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/6/2.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABSumitServicePackageViewController.h"
#import "NSString+KYSAddition.h"
#import "UIViewController+CustomNavigationBar.h"
#import <Masonry/Masonry.h>
#import "KYSServerHeaderView.h"
#import "ABDoorTableViewController.h"
#import "ABLocation.h"
#import "NSDate+KYSAddition.h"
#import "CustomToast.h"
#import "KYSNetwork.h"
#import "NSDictionary+KYSAddition.h"
#import "ABResultViewController.h"

@interface ABSumitServicePackageViewController ()<ABDoorTableViewControllerDelegate>

@property(nonatomic,strong)ABDoorTableViewController *areaViewController;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *selectView;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) NSString *dateStr;
@property (nonatomic,strong) NSString *timeStr;
@property (nonatomic,strong) ABLocation *location;

@end

@implementation ABSumitServicePackageViewController

+ (ABSumitServicePackageViewController *)getSumitServicePackageViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"ServerPacket" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ABSumitServicePackageViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarItem:@"服务包下单" leftButtonIcon:@"返回" rightButtonTitle:nil];
    
    //14+(17)+11+(14)+14+10
    KYSServerHeaderView *headerView=[[NSBundle mainBundle] loadNibNamed:@"KYSServerHeaderView" owner:nil options:nil][0];
    [headerView setDataWithDic:_orderDataDic];
    
    NSLog(@"%@",headerView);
    //加入子ViewController
    _areaViewController=[ABDoorTableViewController getDoorTableViewController];
    _areaViewController.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 -49);
    _areaViewController.delegate=self;
    [self addChildViewController:_areaViewController];
    [self.view addSubview:_areaViewController.view];
    
    _areaViewController.tableView.tableHeaderView=headerView;
}

#pragma mark - Action
- (IBAction)submitOrderAction:(id)sender {
    [self p_summitOrder];
}

//点击时间选择器背景
- (void)tap{
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
}

- (void)btnAction:(UIButton *)btn{
    ABLog(@"%ld",(long)btn.tag);
    if(2==btn.tag){
        if (self.datePicker.datePickerMode == UIDatePickerModeDate) {
            //选择日期，点击确定
            //保存日期
            _dateStr=[self.datePicker.date stringWithFormat:DOOR_DATE];
            NSLog(@"%@",_dateStr);
            //切换为时间选择
            self.datePicker.datePickerMode=UIDatePickerModeTime;
        }else{
            //选择时间，点击确定
            _timeStr=[self.datePicker.date stringWithFormat:DOOR_TIME];
            NSLog(@"%@",_timeStr);
            [UIView animateWithDuration:0.5 animations:^{
                self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
            } completion:^(BOOL finished) {
                NSString *dateTimeStr=[NSString stringWithFormat:@"%@ %@",_dateStr,_timeStr];
                NSDate *dateTime=[NSDate dateWithString:dateTimeStr format:DOOR_DATE_TIME];
                NSLog(@"%@",[dateTime stringWithFormat:DOOR_DATE_TIME]);
                _areaViewController.serverTimeTextField.text=dateTimeStr;
                [self.backView removeFromSuperview];
            }];
        }
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
        } completion:^(BOOL finished) {
            [self.backView removeFromSuperview];
        }];
    }
}

#pragma mark - ABDoorTableViewControllerDelegate
- (void)showDatePicker{
    [self.view addSubview:self.backView];
    self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, self.view.frame.size.height-180, self.view.frame.size.width, 180);
    } completion:^(BOOL finished) {
        //CGRectMake(0, _backView.frame.size.height-180, self.view.frame.size.width, 180)
    }];
}

- (void)getSelectedDate:(NSDate *)date{
    //@"yyyy-MM-dd EEEE HH:mm"
    NSString *dateTimeStr=[NSString stringWithFormat:@"%@ %@",_dateStr,_timeStr];
    NSDate *dateTime=[NSDate dateWithString:dateTimeStr format:DOOR_DATE_TIME];
    NSLog(@"%@",[dateTime stringWithFormat:DOOR_DATE_TIME]);
}

- (void)p_summitOrder{
    
    if (![self p_checkOrderLocationDic]) {
        return;
    }
    
    if (![self p_checkOrderDataDic]) {
        return;
    }
    
    NSMutableDictionary *dataDic=[self p_createOrderDataDic] ;
    NSDictionary *locationDic=[self p_createOrderLocationDic];
    
    [dataDic setObject:[locationDic jsonStringEncoded] forKey:@"location"];
    
    NSLog(@"%@",locationDic);
    NSLog(@"%@",dataDic);
    
//    if (![self p_checkOrderDataDic]) {
//        return;
//    }
//    NSDictionary *orderDic=@{@"data":[[self p_createOrderDataDic] jsonStringEncoded],
//                             @"location":@""};
    
    __weak typeof(self) wSelf=self;
    [KYSNetwork summitPackagePalceOrderWithParameters:dataDic success:^(id responseObject) {
        NSLog(@"订单提交成功");
        NSLog(@"%@",responseObject);
        //刷新历史地址
        [KABNetworkManager getLastSnapshot];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PACKAGE_UPDATE object:nil];
        ABResultViewController *resultVC=[ABResultViewController getResultViewController:KResultViewControllerTypeOrderSuccess];
        resultVC.orderID=responseObject[@"id"];
        [wSelf.navigationController pushViewController:resultVC animated:YES];
    } failureBlock:^(id object) {
        NSLog(@"订单提交失败");
        NSLog(@"%@",object);
        if ([object isKindOfClass:[NSDictionary class]]) {
            if (50002 == [object[@"errcode"] integerValue]) {
                //发出服务项更改(下架)通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOADHOMEVIEW object:nil];
                //回到首页
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
        }
        
        if (isConnectingNetwork) {
            [CustomToast showToastWithInfo:@"订单提交失败"];
        }
    } view:self.view];
}

- (NSMutableDictionary *)p_createOrderDataDic{
    //服务时间
    NSString *dateTimeStr=self.areaViewController.serverTimeTextField.text;
    NSDate *dateTime=[NSDate dateWithString:dateTimeStr format:DOOR_DATE_TIME];
    NSTimeInterval service_at=[dateTime timeIntervalSince1970];
    //故障描述
    NSString *des=self.areaViewController.desTextView.text;
    
    // 故障图片ids
    NSString *photoIds = @"";
    if ( _areaViewController.photoIdsArrayM.count > 0) {
        photoIds = [ _areaViewController.photoIdsArrayM  componentsJoinedByString:@","];
    }
    
    NSMutableDictionary *dic=[@{@"package_id":_orderDataDic[@"id"]?:@"",
                                @"service_at":[NSString stringWithFormat:@"%f",service_at],
                                @"contact_name":self.areaViewController.contactsTextField.text,
                                @"contact_tel":self.areaViewController.mobileTextField.text,
                                @"failure_desc":des.length?des:@"",
                                @"failure_photos":photoIds} mutableCopy];//故障描述图片
//    [_orderDataDic addEntriesFromDictionary:dic];
//    NSLog(@"%@",_orderDataDic);
    return dic;
}

- (NSDictionary *)p_createOrderLocationDic{
    NSDictionary *dic=@{@"name":self.areaViewController.location.name?:@"",
                        @"address":self.areaViewController.location.address?:@"",
                        @"no":self.areaViewController.location.no?:@"",//门牌号
                        @"longitude":self.areaViewController.location.longitude?:@"",
                        @"latitude":self.areaViewController.location.latitude?:@"",
                        @"city":self.areaViewController.location.city?:@""};//故障描述图片
    return dic;
}

- (BOOL)p_checkOrderDataDic{
    if (!self.areaViewController.serverTimeTextField.text.length) {
        [CustomToast showToastWithInfo:@"请选择服务时间"];
        return NO;
    }
    if (!self.areaViewController.contactsTextField.text.length) {
        [CustomToast showToastWithInfo:@"请输入联系人姓名"];
        return NO;
    }
    if (!self.areaViewController.mobileTextField.text.length) {
        [CustomToast showToastWithInfo:@"请输入联系电话"];
        return NO;
    }
    //    if (![self isMobile:self.areaViewController.mobileTextField.text]) {
    //        [CustomToast showToastWithInfo:@"电话号码格式有误"];
    //        return NO;
    //    }
    return YES;
}

- (BOOL)p_checkOrderLocationDic{
    if (!self.areaViewController.location||!self.areaViewController.serverAddressTextField.text.length) {
        [CustomToast showToastWithInfo:@"请选择服务地址"];
        return NO;
    }
    return YES;
}

#pragma mark - 正则判断手机号码合法性
- (BOOL)isMobile:(NSString *)mobileNumbel {
    
    NSString *mobileNum = [mobileNumbel stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    /**
     以13、14、15、17、18等我国正常手机号起始位开头的11位数字
     */
    NSString * MOBIL = @"^[1][34578][0-9]{9}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    
    if ([regextestmobile evaluateWithObject:mobileNum]) {
        return YES;
    }
    
    return NO;
}

#pragma  mark - data
- (UIView *)backView{
    if (!_backView) {
        _backView=[[UIView alloc] initWithFrame:self.view.bounds];
        _backView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.15];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_backView addGestureRecognizer:tap];
        
        _selectView=[[UIView alloc] init];
        _selectView.backgroundColor=[UIColor whiteColor];
        _selectView.frame=CGRectMake(0, _backView.frame.size.height-180, self.view.frame.size.width, 180);
        _selectView.backgroundColor=[UIColor whiteColor];
        [_backView addSubview:_selectView];
        
        UIButton *btn1=[[UIButton alloc] init];
        btn1.tag=1;
        btn1.frame=CGRectMake(0, 0, 50, 40);
        [btn1 setTitle:@"取消" forState:UIControlStateNormal];
        btn1.titleLabel.font=[UIFont systemFontOfSize:17.0];
        [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn1];
        
        UIButton *btn2=[[UIButton alloc] init];
        btn2.tag=2;
        btn2.frame=CGRectMake(_backView.frame.size.width-50, 0, 50, 40);
        [btn2 setTitle:@"确定" forState:UIControlStateNormal];
        btn2.titleLabel.font=[UIFont systemFontOfSize:17.0];
        [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn2];
        
        self.datePicker.frame=CGRectMake(0, 30, _selectView.frame.size.width, _selectView.frame.size.height-30);
        [_selectView addSubview:self.datePicker];
    }
    return _backView;
}

// 日期选择器
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor whiteColor];
        
        //[self p_getMidDate];当天中午12点
        
        NSDate *minimumDate = [NSDate date];
        // 默认日期
        _datePicker.date = minimumDate;
        
        // 最小时间
        [_datePicker setMinimumDate:minimumDate];
        
        // 最小时间
        NSDateComponents *maximumComp = [[NSDateComponents alloc]init];
        [maximumComp setMonth:minimumDate.month];
        [maximumComp setDay:minimumDate.day];
        [maximumComp setYear:minimumDate.year+1];
        NSCalendar *maximumCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *maximumDate = [maximumCal dateFromComponents:maximumComp];
        [_datePicker setMaximumDate:maximumDate];
        
        //        if (iPhone4) {
        //            _datePicker.height = 100;
        //        }
        //        else {
        //            _datePicker.height = 150;
        //        }
    }
    return _datePicker;
}


@end
