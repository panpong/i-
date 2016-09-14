
//
//  ABLocation.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABLocation.h"

#define locationIdKey @"locationId"
#define nameKey @"name"
#define adressKey @"adress"
#define noKey @"no"
#define longitudeKey @"longitude"
#define latitudeKey @"latitude"
#define cityKey @"city"

@implementation ABLocation

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)locationWithDict:(NSDictionary *)dict {
    ABLocation *location = [[ABLocation alloc] initWithDict:dict];
    return location;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([@"id" isEqualToString:key]) {
        self.locationId = value;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_locationId forKey:locationIdKey];
    [aCoder encodeObject:_name forKey:nameKey];
    [aCoder encodeObject:_address forKey:adressKey];
    [aCoder encodeObject:_no forKey:noKey];
    [aCoder encodeObject:_longitude forKey:longitudeKey];
    [aCoder encodeObject:_latitude forKey:latitudeKey];
    [aCoder encodeObject:_city forKey:cityKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    _locationId = [aDecoder decodeObjectForKey:locationIdKey];
    _name = [aDecoder decodeObjectForKey:nameKey];
    _address = [aDecoder decodeObjectForKey:adressKey];
    _no = [aDecoder decodeObjectForKey:noKey];
    _longitude = [aDecoder decodeObjectForKey:longitudeKey];
    _latitude = [aDecoder decodeObjectForKey:latitudeKey];
    _city = [aDecoder decodeObjectForKey:cityKey];
    
    return self;
}

@end
