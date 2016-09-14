//
//  ABNotifacation.h
//  ABNotification
//
//  Created by yjin on 15/5/30.
//  Copyright (c) 2015年 pchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABNotifacation : NSObject

+ (ABNotifacation *)sharedNotifacation;

// yes 表示关掉通知， NO 表示打开通知
@property (nonatomic, assign)BOOL closeNofication;

// 显示抢单红色点
@property (nonatomic, assign)BOOL isShowRedDotGrab;

// 显示接单红色点
@property (nonatomic, assign)BOOL isShowRedDotAccept;

// 显示通知按钮
@property (nonatomic, assign)BOOL isShowNoficationButton;


/**
 *  - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
 *  @param DeviceToken
 */
- (void)getDeviceToken:(NSData *)DeviceToken;



/*
 ios7以前苹果支持多任务, iOS7以前的多任务是假的多任务
 而iOS7开始苹果才真正的推出了多任务
 */
// 接收到远程服务器推送过来的内容就会调用
// 注意: 只有应用程序是打开状态(前台/后台), 才会调用该方法
/// 如果应用程序是关闭状态会调用didFinishLaunchingWithOptions
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

//接收到远程服务器推送过来的内容就会调用


// ios7以后用这个处理后台任务接收到得远程通知
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler

- (void)receiveRomoteNotificationWhenApplicationOpeningWithNotification:(NSDictionary *)userInfo;

// 程序从 关闭状态下 收到推送
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
- (void)receiveRomoteNotificationWhenApplicationClosedWithOptions:(NSDictionary *)launchOptions;


// (void (^)())block
- (void)setCloseNofication:(BOOL)closeNofication;


- (void)loginOutWith:(void(^)())block ;



@end
