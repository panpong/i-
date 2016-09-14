//
//  ABHistoryLocations.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/28.
//  Copyright © 2016年 002. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABLocation.h"

@interface ABHistoryLocations : NSObject

@property(nonatomic,strong) NSMutableArray<ABLocation *> *locations;

+ (instancetype)sharedHistoryLocations;

/**
 提交订单城后后服务地址保存到本地
 
 @param location 地址对象
 */
- (void)saveLocation:(ABLocation *)location;

/**
 获取服务地址的历史记录
 
 @return
 */
- (NSMutableArray<ABLocation *> *)getHistoryLocations;

/**
 删除某一条历史记录
 
 @param location 历史记录对象
 */
- (void)deleteLocation:(NSUInteger)index;


@end
