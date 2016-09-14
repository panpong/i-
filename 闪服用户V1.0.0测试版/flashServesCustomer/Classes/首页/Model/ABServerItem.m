





//
//  ABServerItem.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServerItem.h"

@implementation ABServerItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.dict = dict;
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)ServerItemWithDict:(NSDictionary *)dict {
    ABServerItem *serverItem = [[ABServerItem alloc] initWithDict:dict];
    return serverItem;
}

// 针对id、description这2个key做特殊处理
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([@"description" isEqualToString:key]) {
        self.introduction = value;
    }
    if ([@"id" isEqualToString:key]) {
        self.serverItemId = value;
    }
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"\n id:%@\n name:%@,\n description:%@,\n duration:%@,\n price:%@,\n failure_types:%@,\n service_types:%@, \n device_types:%@,\n os_types:%@, \n device_brands:%@, \n device_components:%@",self.serverItemId,self.name,self.introduction,self.duration,self.price,self.failure_types,self.service_types,self.device_types,self.os_types,self.device_brands,self.device_components];
}

@end
