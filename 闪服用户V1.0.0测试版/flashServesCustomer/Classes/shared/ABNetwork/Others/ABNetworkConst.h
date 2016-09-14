//
//  ABNetworkConst.h
//  netWork
//
//  Created by yjin on 15/4/24.
//  Copyright (c) 2015年 ptshan. All rights reserved.


#import <UIKit/UIKit.h>
extern NSString *disConnectionNetworkNotifation ;

extern NSString * const connectingInWifiNetworkNotifation ;

extern NSString * const connectingIPhoneNetworkNotifation;
//extern NSString * const userNameKey;

extern NSString * const  kStringMoreFitDistanceKey ;
extern NSString * const  userLogOutNotification;

extern NSString * const  KDebug_URL  ;

extern NSString * const  KDebug_Html5URL;   // html5页面URL

extern NSString * const  KWillRelease_URL  ;

extern NSString * const  KRelease_URL  ;

extern NSString * const  KCurVersionKey  ;

extern NSString * const  iTunesURL ;

extern  NSString * const  kCidKey ;

extern NSString *  const errcode ;

extern NSString * const KSessionIDKey;

extern NSString * const KUserIDKey;

extern NSString * const KSecretKey ;

// 从无网络到有网的通知
extern NSString * const connectingNetworkNotifation;

typedef enum {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN,
    ReachableVia4G,
    ReachableVia2G,
    ReachableVia3G
} NetworkStatus;


typedef void(^SuccessBlock)(id responseObject);

typedef void(^FailureBlock) (id object);

#define KABNetworkDelegate [ABNetworkDelegate sharedNetworkDelegate]
#define KABNetworkManager  [ABNetworkManager sharedNetworkManager]


#define KWillRelease 1
#define KDebug 2
#define KRease 0

// 检查网络返回 数据是不是有误
#define checkNetworkResultObject(dic) [[dic objectForKey:errcode] integerValue] == 200

#define kErrmsg @"errmsg"
// 检查当前有没有网络
#define isConnectingNetwork   [ABNetworkManager sharedNetworkManager].internetStatus != NotReachable
#define  isDisConnectedNetwork [ABNetworkManager sharedNetworkManager].internetStatus == NotReachable

// 从无网到有网的宏接受通知
#define receiveConnectingNotifation(target, selectorName)   [[NSNotificationCenter defaultCenter] addObserver:target selector:@selector(selectorName) name:connectingNetworkNotifation object:nil]


#define netWorkOutTime 10.0f


