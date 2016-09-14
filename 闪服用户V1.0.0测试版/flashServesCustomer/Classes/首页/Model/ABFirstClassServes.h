//
//  ABFirstClassServes.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ABFirstClassSubclass;

@interface ABFirstClassServes : NSObject

@property (nonatomic, copy) NSString *servesid;   // 服务项id
@property (nonatomic, copy) NSString *name; // 服务项名
@property (nonatomic, copy) NSString *thumb_url;    // 服务项缩微图地址
@property (nonatomic, copy) NSString *price;    // 服务价格（分）
@property(nonatomic,strong) NSDictionary *dict; // 数据字典


+ (instancetype)firstClassServesWithDict:(NSDictionary *)dict;

@end

