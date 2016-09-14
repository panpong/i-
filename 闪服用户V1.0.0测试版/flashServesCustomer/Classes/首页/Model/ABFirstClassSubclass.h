//
//  ABFirstClassSubclass.h
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABFirstClassServes.h"

@interface ABFirstClassSubclass : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *thumb_url;
@property(nonatomic,strong) NSArray<ABFirstClassServes *> *service;

+ (instancetype)firstClassSubclassWithDict:(NSDictionary *)dict;

@end
