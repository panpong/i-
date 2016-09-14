//
//  ABLocation.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABLocation : NSObject<NSCoding>

@property (nonatomic, copy) NSString *locationId;   // 记录id
@property (nonatomic, copy) NSString *name; // 地点名称
@property (nonatomic, copy) NSString *address;  // 详细地址
@property (nonatomic, copy) NSString *no;  // 门牌号
@property (nonatomic, copy) NSString *longitude;    // 经度
@property (nonatomic, copy) NSString *latitude; // 纬度
@property (nonatomic, copy) NSString *city; // 城市（不带‘市’字）

+ (instancetype)locationWithDict:(NSDictionary *)dict;

@end
