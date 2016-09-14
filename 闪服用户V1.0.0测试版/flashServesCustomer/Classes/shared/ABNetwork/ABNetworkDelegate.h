//
//  ABNetworkDelegate.h
//  netWork
//
//  Created by yjin on 15/4/29.
//  Copyright (c) 2015年 ptshan. All rights reserved.
//
#import <Foundation/Foundation.h>


extern NSString * userNameKey;
typedef enum {
    tUpdateTag = 100,
    tForceUpdateTag,
}AlertViewTag;

@interface ABNetworkDelegate : NSObject

@property (nonatomic, assign)BOOL isShowADView;

@property (nonatomic, copy) NSString *stringMoreFitDistance;
@property (nonatomic, copy) NSString *stringCID;
@property (nonatomic, copy) NSString *stringSID;
@property (nonatomic, copy) NSString *stringSecret;
@property (nonatomic, copy) NSString *stringUserID;
@property (nonatomic, copy) NSString *stringUserName; // 表示用户的手机号；

@property (nonatomic, strong) NSDictionary *dictionaryForecedUpdate;

+ (ABNetworkDelegate *)sharedNetworkDelegate;

/**
 *  版本监测处理方法
 *
 *  @param responseObject 服务器返回的版本jsonObject
 */
- (void)versionWithResponseObject:(id)responseObject;


+ (NSString *)curVersion;


+ (NSString *)serverURL;

// 返回服务器Html5页面地址
+ (NSString *)serverHtml5URL;


+ (NSString *)normalizedRequestParameters:(NSDictionary *)aParameters;


-(void)activeWithResponeObject:(id)responseObject;

// 用户注销登陆处理
+ (void)loginOutHandle;

// 判断是否登录
+ (BOOL)isLogined;

// 判断是否为长期协议用户 - YES代表是
- (BOOL)isLongTermUser;

// applicationDidBecomeActive
- (void)forcedUpdate:(id)responseObject;

@end
