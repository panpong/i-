//
//  WeiXinPay.h
//  customIBus
//
//  Created by yjin on 15/6/12.
//  Copyright (c) 2015年 aibang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
#import "WXApi.h"


extern NSString *WXPayResultNotification;
extern NSString *WXPayResultNotificationKey;

@interface WeiXinPay : NSObject <WXApiDelegate>

// 在appdeleate 中先调用
+ (instancetype)sharedWeiXinPay;


- (void)PayWithDictionary:(NSDictionary *)dictionModary;


//  在这两个代理方法中 分别实现： 不用判断URL；
// - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)
//
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
- (void)handleURL:(NSURL *)url ;



@end



