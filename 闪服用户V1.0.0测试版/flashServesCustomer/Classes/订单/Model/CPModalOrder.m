//
//  CPModalOrder.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPModalOrder.h"

@implementation CPModalOrder

+ (instancetype)modalOrder:(NSDictionary *)dic {
    
    CPModalOrder *order = [[CPModalOrder alloc] init];
    order.type = dic[@"type"];
    order.orderID = dic[@"id"];
    order.deviceNum  =  dic[@"device_num"];
    order.duration =  dic[@"duration"];
    order.engineerId= dic[@"engineer_id"];
    order.flags = dic[@"flags"];
    order.operates = dic[@"operates"];
    order.price =  dic[@"price"];
    order.orderNnum = dic[@"serial_num"];
    order.serviceAddress = dic[@"service_address"];
    order.serviceTime = dic[@"service_at"];
    order.serviceName  = dic[@"service_name"];
    order.statusText = dic[@"status_text"];
    order.modify_services = dic[@"modify_services"];
    order.modify_servicetime = dic[@"modify_servicetime"];
    
    return order;
}




+ (NSArray *)arrayModalOrder:(NSArray *)array  {
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        
        CPModalOrder *modal = [CPModalOrder modalOrder:dic];
        [arrayM addObject:modal];
        
    }
    return arrayM;
  
}

- (BOOL)isUpgraded {
 
    if( [self.flags[@"upgrade"] integerValue] == 1 ) {
        
        return YES;
        
    }
    return NO;
    
    
    
}
- (BOOL)isCommentedAlready {
    
    if( [self.flags[@"comment"] integerValue] == 1 ) {
        
        return YES;
        
    }
    return NO;
    
}


- (BOOL)isModifyWatingOK {
    
    if( [self.flags[@"modify"] integerValue] == 1 ) {
        
        return YES;
        
    }
    return NO;
    
}

- (BOOL)isShowOpertionButton {
    
    int oeration = [self operationStatus];
    if (oeration  == operationUpdate) {
    
        return NO;
    }
    
    if (oeration == operationAlreadtComment) {
        
        return YES;
    }
    
    if (_operates.count== 0 && oeration != operationAlreadtComment) {
        
        return NO;
    }
  
    return YES;
    
}

// 发出订单改变通知： 一般会刷新订单列表和订单详情
- (void)postOrderListChangeNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderListChangeNotification" object:nil];
    
    
}

- (BOOL)isCancelState {
    
    if ([_statusText isEqualToString:@"已取消"]) {
        
        return YES;
    }
    
    return NO;
    
}

- (int)operationStatus {
    
    if (self.isCommentedAlready == YES) {
        
        return operationAlreadtComment;
    }
    
    if (self.operates.count == 0) {
        
        return OperationNone;
    }
    
    // 和operation 枚举对应
    NSDictionary *stringKey = @{@"cancel":@"0",
                                @"pay":@"1",
                                @"comment":@"2",
                                @"confirmService":@"3",
                                @"confirmModify":@"4",
                               
                                };
 
  
    return [stringKey [self.operates[0][@"name"]] integerValue];
    

}

- (NSString *)buttongOperationStringWith:(int)operation  {

    if (operation == OperationNone) {
        
        return @"没有操作";
    }
    
    NSArray *array = @[@"取消订单",@"去支付",@"去评价",@"确认完成",@"确认修改",@"已评价"];
    
    return array[operation];
    
}

- (BOOL)isHaveUpdateTime {
    

    if (self.modify_servicetime.length == 0) {
        
        return NO;
    }
    return YES;
}

- (BOOL)isHaveUpdateSever {
    
    if (self.modify_services.count == 0) {
        return NO;
    }
    return YES;
    
}

- (float)updateViewHeight {
    
    if([self isCancelState]) {
        
        return 0;
    }
    
    if ([self stateUpdate] == UpdetateStateOnlyTime) {
        
        return updateTimeCellHeight + 15;
        
    }else if ([self stateUpdate] == UpdetateStateOnlySever) {
        
        return 106 + updateTimeOneSeverItemHeight * _modify_services.count + 15;
        
        
    }else if ([self stateUpdate] == UpdetateStateAll) {
        
        
//        return updateTimeCellHeight +15 + 106 + updateTimeOneSeverItemHeight * _modify_services.count + 6;
        return  175 + updateTimeOneSeverItemHeight * _modify_services.count ;
        
    }
    
    return 0;
}

- (int)stateUpdate  {
    
    if ([self isHaveUpdateSever] && [self isHaveUpdateTime] ) {
        
        return UpdetateStateAll;
        
    }else if ([self isHaveUpdateSever]== NO && [self isHaveUpdateTime] == YES ) {// 只有时间
        
        return UpdetateStateOnlyTime;
        
    }else if([self isHaveUpdateSever] == YES && [self isHaveUpdateTime] == NO ){
        
        return UpdetateStateOnlySever;
    }
    
    return UpdetateStateNone;
}

- (float)heightForCell {
    
    if([self isShowOpertionButton] == NO) { // 不显示按钮
        
        if ( [self.type integerValue] != 0) { // 是服务包订单
            
            if([self isModifyWatingOK] == YES) { // 有确认修改时就显示
                return 182- 58 + [self updateViewHeight];
            }
            return 182 - 58;
        }
       
    }
    if([self isModifyWatingOK] == YES) { // 有确认修改时就显示
        return 182 + [self updateViewHeight];
    }
    
    return 182;
    
}


+ (instancetype)modalDetailOrder:(NSDictionary *)dic {
    
    
    CPModalOrder *order = [[CPModalOrder alloc] init];
    order.flags = dic[@"flags"];
    order.operates = dic[@"operates"];
    order.services = dic[@"services"];
    dic = dic[@"order"];
    
    
    order.orderID = dic[@"id"];
    order.deviceNum  =  dic[@"device_num"];
    order.duration =  dic[@"duration"];
    order.engineerId= dic[@"engineer_id"];
    order.price =  dic[@"price"];
    order.orderNnum = dic[@"serial_num"];
    order.serviceAddress = dic[@"service_address"];
    order.serviceTime = dic[@"service_at"];
    order.serviceName  = dic[@"service_name"];
    order.statusText = dic[@"status_text"];
    
    order.contactName = dic[@"contact_name"];
    order.contactTel= dic[@"contact_tel"];
    order.engineerName= dic[@"engineer_name"];
    order.engineerTel= dic[@"engineer_tel"];
    order.engineerThumburl= dic[@"engineer_thumburl"];
    order.failureDesc= dic[@"failure_desc"];
    order.failurePhotos= dic[@"failure_photos"];
    order.failureTypes= dic[@"failure_types"];
    order.deviceBrands= dic[@"device_brands"];
    order.deviceComponents= dic[@"device_components"];
    order.deviceTypes= dic[@"device_types"];
    order.osTypes = dic[@"os_types"];
    order.serviceTypes = dic[@"service_types"];
    order.cash = dic[@"cash"];
    order.created_at = dic[@"created_at"];
    order.work_id = dic[@"work_id"];
    // 要更给
    order.modify_services = dic[@"modify_services"];
    order.modify_servicetime = dic[@"modify_servicetime"];

    return order;
};




- (BOOL)isShowFauileSection {
    
    if ([self isShowFauileWhy] == NO && [self isShowFauileRowOne] == NO) {
        
        return NO;
    }
    return YES;
    
}

// 是不是显示故障原因
- (BOOL)isShowFauileWhy {
    
    if (self.failureDesc.length == 0 && self.failurePhotos.length == 0) {
        
        return NO;
    }
    return YES;
    
}

// 是不是显示故障服务
- (BOOL)isShowFauileRowOne {
    
    if (_deviceBrands.length == 0 && _deviceComponents.length == 0 && _deviceTypes.length == 0 && _osTypes.length == 0 && _serviceTypes.length == 0 && _failureTypes.length == 0) {
        
        
        return NO;
    }
    return YES;
    
   // 故障类型、服务类型、设备类型、系统类型、部件
}

- (NSString *)stringTimeWithNoWeek:(NSString  *)time {
    
    
    return [CPModalOrder stringTimeWithNoWeek:time];

    
    
}
+ (NSString *)stringTimeWithNoWeek:(NSString  *)time {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:    [time integerValue]];
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = [comps weekday];
    int year=[comps year];
    int month = [comps month];
    int day = [comps day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    return [NSString stringWithFormat:@"%d年%d月%d日 %@",year,month,day,currentDateStr];
    
    
}


+ (NSString *)stringTimeWithhengNoWeekFormat:(NSString  *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:    [time integerValue]];
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = [comps weekday];
    int year=[comps year];
    int month = [comps month];
    int day = [comps day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    return [NSString stringWithFormat:@"%d-%d-%d %@",year,month,day ,currentDateStr];
    
    
}

- (NSString *)stringTime:(NSString  *)time {
    
 
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:    [time integerValue]];
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = [comps weekday];
    int year=[comps year];
    int month = [comps month];
    int day = [comps day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];

    return [NSString stringWithFormat:@"%d年%d月%d日 %@ %@",year,month,day,[arrWeek objectAtIndex:week-1] ,currentDateStr];
    
}

- (NSString *)stringTimeWithhengFormat:(NSString  *)time {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:    [time integerValue]];
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = [comps weekday];
    int year=[comps year];
    int month = [comps month];
    int day = [comps day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    return [NSString stringWithFormat:@"%d-%d-%d %@ %@",year,month,day,[arrWeek objectAtIndex:week-1] ,currentDateStr];
    
}


// 是否升级
- (BOOL)isImageUpdate {
    
    if ([self.flags[@"upgrade"] integerValue]) {
        return YES;
    }
    return NO;
    
}

- (NSString *)stringHourceTime:(NSString *)timeS {
    
    long long int time = [timeS longLongValue] * 60;
    if (time < 3600) {
        
        long long int  cout = time / 60;
        if (cout  <= 0) {
            cout++;
        }
        
        NSString *stringTime = [NSString stringWithFormat:@"%lld分钟",cout];
        return stringTime;
    }else {
        
        long long int  hour = time / 3600;
        long long int  second = time % 3600;
        
        long long int  cout = second / 60;
        
        if (cout == 0) {
            
            NSString *stringTime = [NSString stringWithFormat:@"%lld小时",hour];
            return stringTime;
            
        }

        NSString *stringTime = [NSString stringWithFormat:@"%lld小时%lld分钟",hour,cout];
        return stringTime;
        
    }
    
}


- (NSString *)price {

    float price =  (float)[_price integerValue] / 100;
    return  [NSString stringWithFormat:@"%0.2f",price];
    
}

- (NSString *)stringOriginPrice {
    
    
    return _price;
    
}


+ (NSString *)stringPriceWithDot:(BOOL)isHaveDot price:(NSString *)priceS{
    
    if (priceS.length == 0) {
        
        return @"";
    }
    
    if (isHaveDot == YES) {
        
        float price =  (float)[priceS integerValue] / 100;
        return  [NSString stringWithFormat:@"%0.2f",price];
        
    }else {
        
        float price =  (float)[priceS integerValue] / 100;
        return  [NSString stringWithFormat:@"%0.0f",price];
        
    }
    
    
}

- (BOOL)isOrderCancel {
    
    if ([self.statusText isEqualToString:@"已取消"]) {
        
        
        return YES;
    }
    return NO;
    
    
}

+ (void)postOrderListChangeNotification {
    
       [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderListChangeNotification" object:nil];
}
//    return order;

//}





@end
