//
//  ABHistoryLocations.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/28.
//  Copyright © 2016年 002. All rights reserved.
//  '管理服务地址的历史记录'

#import "ABHistoryLocations.h"

#define HistoryLocationsKey @"HistoryLocationsKey"

@implementation ABHistoryLocations

static ABHistoryLocations *_instance;
+ (instancetype)sharedHistoryLocations {
    static dispatch_once_t audio;
    NSLog(@"audio=%ld,地址：%p",audio,&audio);
    dispatch_once(&audio, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t audio;
    NSLog(@"audio=%ld,地址：%p",audio,&audio);
    dispatch_once(&audio, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (NSMutableArray<ABLocation *> *)getHistoryLocations {
    NSArray *locations = [NSArray array];
    locations = [[NSUserDefaults standardUserDefaults] objectForKey:HistoryLocationsKey];
    if (locations && locations.count > 0) {
        _locations = [NSMutableArray array];
        for (NSData *data in locations) {
            ABLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [_locations addObject:location];
        }
        return _locations;
    } else {
        return nil;
    }
}

- (NSArray *)getHistoryLocationsData {
    NSArray *locations = [[NSUserDefaults standardUserDefaults] objectForKey:HistoryLocationsKey];
    return locations;
}

- (void)saveLocation:(ABLocation *)location {
    NSArray *locations = [[NSUserDefaults standardUserDefaults] objectForKey:HistoryLocationsKey];
    if (location == nil) {
        return;
    } else if(locations.count > 0) {   // 有历史记录判断是否重复
        for (int i = 0; i < [self getHistoryLocations].count; ++i) {
            ABLocation *historyLocation = [self getHistoryLocations][i];
            // 判断地址是否重复
            BOOL isRepeateName = [historyLocation.name isEqualToString:location.name];
            BOOL isRepeateAdress = [historyLocation.address isEqualToString:location.address];
            BOOL isRepeateNo = [historyLocation.no isEqualToString:location.no];
            BOOL isRepeateCity = [historyLocation.city isEqualToString:location.city];
            
            BOOL isRepeate = isRepeateName && isRepeateAdress && isRepeateNo && isRepeateCity;
            
            // 重复就退出函数不保存
            if (isRepeate) {
                // 移动到第一位
                NSMutableArray *locationsArrayM = [NSMutableArray arrayWithArray:[self getHistoryLocationsData]];
                if (0 != i) {
                    NSData *data = [self getHistoryLocationsData][i];
                    [locationsArrayM removeObjectAtIndex:i];
                    [locationsArrayM insertObject:data atIndex:0];
                }
//                [locationsArrayM exchangeObjectAtIndex:0 withObjectAtIndex:i];
                // 必须转为不可变才能存入
                NSArray *array = [NSArray arrayWithArray:locationsArrayM];
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:HistoryLocationsKey];
                return;
            }
        }

        // 遍历完毕后都没有重复则保存
            NSMutableArray *locationsArrayM = [NSMutableArray arrayWithArray:[self getHistoryLocationsData]];
            // 将ABLocation类型变为NSData类型
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:location];
            [locationsArrayM insertObject:data atIndex:0];
            // 必须转为不可变才能存入
            NSArray *array = [NSArray arrayWithArray:locationsArrayM];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:HistoryLocationsKey];
        
            return;
    } else {    // 如果没有历史记录直接添加
        NSMutableArray *locationsArrayM = [NSMutableArray array];
        // 将ABLocation类型变为NSData类型
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:location];
        [locationsArrayM addObject:data];
        // 必须转为不可变才能存入
        NSArray *array = [NSArray arrayWithArray:locationsArrayM];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:HistoryLocationsKey];
        return;
    }
}

- (void)deleteLocation:(NSUInteger)index {
    NSArray *locations = [NSArray array];
    locations = [[NSUserDefaults standardUserDefaults] objectForKey:HistoryLocationsKey];
    if (locations.count > 0) {
        NSMutableArray *locationsArrayM = [NSMutableArray arrayWithArray:locations];
        [locationsArrayM removeObjectAtIndex:index];
        // 必须转为不可变才能存入
        NSArray *array = [NSArray arrayWithArray:locationsArrayM];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:HistoryLocationsKey];
    }
    else {
        return;
    }
}

@end
