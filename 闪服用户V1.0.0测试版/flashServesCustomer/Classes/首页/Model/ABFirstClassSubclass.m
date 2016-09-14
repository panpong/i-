//
//  ABFirstClassSubclass.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABFirstClassSubclass.h"

@implementation ABFirstClassSubclass

+ (instancetype)firstClassSubclassWithDict:(NSDictionary *)dict
{
    ABFirstClassSubclass *firstClassSubclass = [[ABFirstClassSubclass alloc] init];
    [firstClassSubclass setValuesForKeysWithDictionary:dict];
    return firstClassSubclass;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
