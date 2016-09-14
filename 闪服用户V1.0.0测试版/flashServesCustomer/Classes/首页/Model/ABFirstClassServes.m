//
//  ABFirstClassServes.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABFirstClassServes.h"

@implementation ABFirstClassServes

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        self.dict = dict;
    }
    return self;
}

+ (instancetype)firstClassServesWithDict:(NSDictionary *)dict
{
    ABFirstClassServes *firstClassServes = [[ABFirstClassServes alloc] initWithDict:dict];    
    return firstClassServes;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([@"id" isEqualToString:key]) {
        self.servesid = value;
    }    
}

@end
