//
//  ABDoorViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABDoorViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABResultViewController.h"
#import "ABDoorTableViewController.h"
#import "NSDate+KYSAddition.h"
#import "NSString+KYSAddition.h"
#import "NSDictionary+KYSAddition.h"
#import "KYSNetwork.h"
#import "CustomToast.h"
#import "ABHistoryLocations.h"
#import "ABLocation.h"
#import "ABNetworkManager.h"

@interface ABDoorViewController ()<ABDoorTableViewControllerDelegate>


@property(nonatomic,strong)ABDoorTableViewController *areaViewController;

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *selectView;
@property (nonatomic,strong) UIDatePicker *datePicker;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnWidth;

@property (nonatomic,strong) NSString *dateStr;
@property (nonatomic,strong) NSString *timeStr;

@property (nonatomic,strong) ABLocation *location;

@end

@implementation ABDoorViewController

+ (ABDoorViewController *)getDoorViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"ServerItem&Door" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ABDoorViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //_isUpdate?@"修改资料":@"我的资料"
    [self setNavigationBarItem:@"上门信息" leftButtonIcon:@"返回" rightButtonTitle:nil];
    
    [self p_refreshOrder];
    
    ABLog(@"%@",NSStringFromCGRect(self.view.frame));
    //加入子ViewController
    _areaViewController=[ABDoorTableViewController getDoorTableViewController];
    _areaViewController.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 -49);
    _areaViewController.delegate=self;
    [self addChildViewController:_areaViewController];
    [self.view addSubview:_areaViewController.view];
}

#pragma mark - Action

- (IBAction)nextBtnAction:(id)sender {
    //提交订单
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
            ABLog(@"%@",_dateStr);
            //切换为时间选择
            self.datePicker.datePickerMode=UIDatePickerModeTime;
        }else{
            //选择时间，点击确定
            _timeStr=[self.datePicker.date stringWithFormat:DOOR_TIME];
            ABLog(@"%@",_timeStr);
            [UIView animateWithDuration:0.5 animations:^{
                self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
            } completion:^(BOOL finished) {
                NSString *dateTimeStr=[NSString stringWithFormat:@"%@ %@",_dateStr,_timeStr];
                NSDate *dateTime=[NSDate dateWithString:dateTimeStr format:DOOR_DATE_TIME];
                ABLog(@"%@",[dateTime stringWithFormat:DOOR_DATE_TIME]);
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
    ABLog(@"%@",[dateTime stringWithFormat:DOOR_DATE_TIME]);
}

#pragma mark - private
//刷新订单
- (void)p_refreshOrder{
    //刷新总价
    _moneyLabel.text=[NSString stringWithFormat:@"%d元",[self.orderDataDic[@"price"] intValue]/100*[self.orderDataDic[@"device_num"] intValue]];
    _moneyWidth.constant=[_moneyLabel.text widthForFont:_moneyLabel.font]+10;
    
    //刷新服务时间
    NSInteger minute=[self.orderDataDic[@"duration"] integerValue]*[self.orderDataDic[@"device_num"] intValue];
    NSInteger m=minute%60;
    NSInteger h=minute/60;
    NSString *minu=[NSString stringWithFormat:@"%@分钟",@(m)];
    NSString *hour=[NSString stringWithFormat:@"%@小时",@(h)];
    NSString *time=[NSString stringWithFormat:@"%@%@",h?hour:@"",((!m&&!h)||m)?minu:@""];
    _timeLabel.text=[NSString stringWithFormat:@"(约%@)",time];
    _timeWidth.constant=[_timeLabel.text widthForFont:_timeLabel.font]+10;
    [_moneyLabel layoutIfNeeded];
    
    ABLog(@"%@",NSStringFromCGRect(_scrollView.frame));
    
    ABLog(@"%f",_timeLabel.frame.origin.x+_timeWidth.constant);
    
    _scrollView.contentSize=CGSizeMake(_timeLabel.frame.origin.x+_timeWidth.constant, 49);
    

}

- (void)p_summitOrder{
    
    if (![self p_checkOrderLocationDic]) {
        return;
    }
    
    if (![self p_checkOrderDataDic]) {
        return;
    }
    
    NSDictionary *dataDic=[self p_createOrderDataDic];
    NSDictionary *locationDic=[self p_createOrderLocationDic];
    NSDictionary *orderDic=@{@"data":[dataDic jsonStringEncoded],
                             @"location":[locationDic jsonStringEncoded]};
    ABLog(@"提交的数据：%@",orderDic);
    __weak typeof(self) wSelf=self;
    [KYSNetwork submitOrderWithParameters:orderDic success:^(id responseObject) {
        ABLog(@"订单提交成功");
        ABLog(@"%@",responseObject);
        
        //刷新历史地址
        [KABNetworkManager getLastSnapshot];
        
        ABResultViewController *resultVC=[ABResultViewController getResultViewController:KResultViewControllerTypeGeneralOrderSuccess];
        resultVC.orderID=responseObject[@"id"];
        [wSelf.navigationController pushViewController:resultVC animated:YES];
    } failureBlock:^(id object) {
        ABLog(@"订单提交失败");
        ABLog(@"%@",object);
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
    
    NSDictionary *dic=@{@"service_at":[NSString stringWithFormat:@"%f",service_at],
                        @"contact_name":self.areaViewController.contactsTextField.text,
                        @"contact_tel":self.areaViewController.mobileTextField.text,
                        @"failure_desc":des.length?des:@"",
                        @"failure_photos":photoIds};//故障描述图片
    [_orderDataDic addEntriesFromDictionary:dic];
    ABLog(@"%@",_orderDataDic);
    return _orderDataDic;
}

- (NSDictionary *)p_createOrderLocationDic{
    NSDictionary *dic=@{@"name":self.areaViewController.location.name,
                        @"address":self.areaViewController.location.address,
                        @"no":self.areaViewController.location.no,//门牌号
                        @"longitude":self.areaViewController.location.longitude,
                        @"latitude":self.areaViewController.location.latitude,
                        @"city":self.areaViewController.location.city};//故障描述图片
    
    ABLog(@"112233445566: %@",dic);
    
    return dic;
}

- (BOOL)p_checkOrderDataDic{
    if (!self.areaViewController.serverTimeTextField.text.length) {
        [CustomToast showToastWithInfo:@"请选择服务时间"];
        return NO;
    }
    if (!self.areaViewController.contactsTextField.text.length) {
        [CustomToast showToastWithInfo:@"请输入联系人"];
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
    if (!self.areaViewController.location||!self.areaViewController.location.no.length) {
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

#pragma mark - data
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

//当天中午12点
- (NSDate *)p_getMidDate{
    NSDate *currentDate = [NSDate date];
    ABLog(@"当前时间戳：%f",currentDate.timeIntervalSince1970);
    NSString *dateStr=[NSString stringWithFormat:@"%d-%d-%d 00:00",currentDate.year,currentDate.month,currentDate.day];
    NSDate *dayDate=[NSDate dateWithString:dateStr format:@"yyyy-MM-dd HH:mm"];
    ABLog(@"当天0点时间戳:%f",dayDate.timeIntervalSince1970);
    return [NSDate dateWithTimeIntervalSince1970:dayDate.timeIntervalSince1970+12*60*60];
}





@end
