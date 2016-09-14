//
//  ABServerItem.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABFirstClassServes.h"

@interface ABServerItem : NSObject

@property (nonatomic, copy) NSString *serverItemId;   // 服务项id - 对应key是id
@property (nonatomic, copy) NSString *name; // 服务名称
@property (nonatomic, copy) NSString *introduction;    // 服务内容简介 - 对应key是description
@property (nonatomic, copy) NSString *duration; // 服务的时长（分钟）
@property (nonatomic, copy) NSString *price;    // 服务的价格（分）
@property (nonatomic, strong) NSArray *failure_types;   // 故障类型
@property (nonatomic, strong) NSArray *service_types;   // 服务类型
@property (nonatomic, strong) NSArray *device_types;    // 设备类型
@property (nonatomic, strong) NSArray *os_types;    // 系统类型
@property (nonatomic, strong) NSArray *device_brands;   // 品牌
@property (nonatomic, strong) NSArray *device_components;   // 部件
@property(nonatomic,strong) NSDictionary *dict; // 数据字典

@property(nonatomic,strong) ABFirstClassServes *firstClassServes;   // 所属的服务项



+ (instancetype)ServerItemWithDict:(NSDictionary *)dict;
@end
