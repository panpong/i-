//
//  CPModalOrder.h
//  flashServesCustomer
//
//  Created by yjin on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import <Foundation/Foundation.h>
#define updateTimeCellHeight 70
#define updateTimeOneSeverItemHeight 26

typedef NS_ENUM(NSInteger, Operation) {
    //以下是枚举成员
    operationCancel = 0,  // 取消
    operationPay = 1,  // 支付
    operationComment = 2, // 评价
    operationFinish = 3, // 确认完成
    operationUpdate = 4, // 确认修改
    operationAlreadtComment = 5, // 已评价
    operationAlreadCancel = 6, // 已经取消
    OperationNone = -1,
    
};

typedef NS_ENUM(NSInteger, UpdetateState) {
    //以下是枚举成员
    UpdetateStateOnlyTime = 0, // 只修改了时间状态
    UpdetateStateOnlySever = 1, // 只修改了服务
    UpdetateStateAll = 2, // 都修改了
    UpdetateStateNone = 3 // 没有修改
  
};


@interface CPModalOrder : NSObject

// 修改服务项
@property (nonatomic, strong)NSArray *modify_services;
// 修改的服务时间
@property (nonatomic, strong)NSString *modify_servicetime;

// 支付价格
@property (nonatomic, strong)NSString *cash;

// 客户类型：0-临时客户；1-长期协议客户
@property (nonatomic, strong)NSString *type;

// 订单ID
@property (nonatomic, strong)NSString *orderID;

// 设备台数
@property (nonatomic, strong)NSString *deviceNum;
// 下单时间
@property (nonatomic, strong)NSString *duration;

// 工程师
@property (nonatomic, strong)NSString *engineerId;
@property (nonatomic, strong)NSString *engineerName;
@property (nonatomic, strong)NSString *engineerTel;
// 工程师头像地址
@property (nonatomic, strong)NSString *engineerThumburl;

// 标记字典
@property (nonatomic, strong)NSDictionary *flags;

// 订单操作列表
@property (nonatomic, strong)NSArray *operates;

//服务总价格
@property (nonatomic, strong)NSString *price;

// 订单号
@property (nonatomic, strong)NSString *orderNnum;

// 服务地址
@property (nonatomic, strong)NSString *serviceAddress;

// 服务时间
@property (nonatomic, strong)NSString *serviceTime;

// 服务名称
@property (nonatomic, strong)NSString *serviceName;

// 状态描述
@property (nonatomic, strong)NSString *statusText;

// 联系人
@property (nonatomic, strong)NSString *contactName;
// 联系电话号码
@property (nonatomic, strong)NSString *contactTel;


// 品牌
@property (nonatomic, strong)NSString *deviceBrands;
// 部件
@property (nonatomic, strong)NSString *deviceComponents;
// 设备类型
@property (nonatomic, strong)NSString *deviceTypes;
// 系统类型
@property (nonatomic, strong)NSString *osTypes;

// 服务类型
@property (nonatomic, strong)NSString *serviceTypes;

// 故障类型
@property (nonatomic, strong)NSString *failureTypes;


// 故障情形简述
@property (nonatomic, strong)NSString *failureDesc;

// 故障拍张图片
@property (nonatomic, strong)NSString *failurePhotos;

@property (nonatomic, strong)NSArray *services;

// 下单时间
@property (nonatomic, strong)NSString *created_at;

//闪服工号
@property (nonatomic,strong)NSString *work_id;

// 是不是已经评价
- (BOOL)isCommentedAlready;
// 订单是否升级
- (BOOL)isUpgraded;
// 订单 修改了等待确认
- (BOOL)isModifyWatingOK;

// 是不是希纳斯操作按钮
- (BOOL)isShowOpertionButton;

// 修改View高度
- (float)updateViewHeight;

- (float)heightForCell;

+ (instancetype)modalOrder:(NSDictionary *)dic;

+ (NSArray *)arrayModalOrder:(NSArray *)array ;

// 发出订单改变通知： 一般会刷新订单列表和订单详情
- (void)postOrderListChangeNotification;
+ (void)postOrderListChangeNotification;

- (int)operationStatus;
- (NSString *)buttongOperationStringWith:(int)operation ;

// 修改状态 ： 有四种： 只修改时间： 没有修改： 修改了时间和服务： 只修改服务
- (int)stateUpdate ;

// 服务
+ (instancetype)modalDetailOrder:(NSDictionary *)dic;


// 是不是显示故障服务
- (BOOL)isShowFauileRowOne;
// 是不是显示故障原因
- (BOOL)isShowFauileWhy;

// tableView 是不是 显示故障Sesion
- (BOOL)isShowFauileSection;

+ (NSString *)stringTimeWithNoWeek:(NSString  *)time;
- (NSString *)stringTimeWithNoWeek:(NSString  *)time;
- (NSString *)stringTime:(NSString  *)time;
- (NSString *)stringHourceTime:(NSString *)timeS;
- (NSString *)stringTimeWithhengFormat:(NSString  *)time;
+ (NSString *)stringTimeWithhengNoWeekFormat:(NSString  *)time;

- (NSString *)stringOriginPrice;


- (BOOL)isOrderCancel;

// 是否升级
- (BOOL)isImageUpdate;



+ (NSString *)stringPriceWithDot:(BOOL)isHaveDot price:(NSString *)priceS;


@end
