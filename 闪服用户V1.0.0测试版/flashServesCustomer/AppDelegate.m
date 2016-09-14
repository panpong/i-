//
//  AppDelegate.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/15.
//  Copyright © 2016年 002. All rights reserved.
//

#import "AppDelegate.h"
#import "ABNetworkManager.h"
#import "ABTabBarController.h"
#import "ABLoginViewController.h"
#import "ABServesAdressViewController.h"
#import <BaiduMapKit/BaiduMapAPI_Base/BMKMapManager.h>
#import "ABApplyBillViewController.h"
#import "ABNewFeatureViewController.h"
#import "WeiXinPay.h"
#import "ALPayManager.h"
#define BAIDU_MAP_AK @"cnU9TML2oIeMFEYcYAGGky04K6fVLzep"    // 百度地图访AK
#import "ABNotifacation.h"
#import "UMMobClick/MobClick.h"
#import "ABNetworkDelegate.h"
#define UMAPPKEY @"576b524d67e58efb690011f4"
#import "CustomToast.h"
// TODO:更换为appStore上的地址
#define APPStoreURL @"https://itunes.apple.com/us/app/id1131138973?mt=8&ign-mpt=uo%3D4"

#import "KYSNetwork.h"
@interface AppDelegate ()

{
    BMKMapManager* _mapManager;
    ABTabBarController *_tabBarController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 友盟配置 - （此APPKey是甲方的账号注册的）
    UMConfigInstance.appKey = UMAPPKEY;
    UMConfigInstance.channelId = APPStoreURL;
    UMConfigInstance.ePolicy = REALTIME;
    [MobClick startWithConfigure:UMConfigInstance];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [ABNetworkManager sharedNetworkManager];
    
    [[ABNotifacation sharedNotifacation] receiveRomoteNotificationWhenApplicationClosedWithOptions:launchOptions];
    
     [WeiXinPay sharedWeiXinPay];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:ScreenBounds];
    self.window = window;
    
    [self.window makeKeyAndVisible];

    self.window.rootViewController = [self defaultRootViewController];
    
    // 初始化百度地图管理对象
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BAIDU_MAP_AK  generalDelegate:nil];
    if (!ret) {
        NSLog(@"_mapManager start failed!");
    } else {
        NSLog(@"_mapManager start success!");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootViewController:) name:ABSwitchRootViewControllerNotification object:nil];
    

    
    return YES;
}

- (void)changeRootViewController:(NSNotification *)notify {
    if ([@"ABHomeViewController" isEqualToString:notify.object]) {
        ABTabBarController *vc = [[ABTabBarController alloc] init];
        vc.selectedIndex = 0;
        self.window.rootViewController = vc;
        return;
    } else if ([@"ABOrderViewController" isEqualToString:notify.object]) {
        ABTabBarController *vc = [[ABTabBarController alloc] init];
        vc.selectedIndex = 1;
        self.window.rootViewController = vc;
        return;
    } else if ([@"ABProfileViewController" isEqualToString:notify.object]) {
        ABTabBarController *vc = [[ABTabBarController alloc] init];
        vc.selectedIndex = 2;
        self.window.rootViewController = vc;
        return;
    }
    else if([@"loginOutHandle" isEqualToString:notify.object]) {  // 注销
        [self loginOutHandle];
        return;
    }
}

- (UIViewController *)defaultRootViewController {
    
    // 1. 判断是否登录
    //    if (YES) {
    //        return (self.isNewVersion ? [[ABNewFeatureViewController alloc] initWithCollectionViewLayout:[[NewFeatureViewLayout alloc] init]] : [[WelcomeViewController alloc] init]);
    //    }
    
    if (!self.isNewVersion) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        _tabBarController = [[ABTabBarController alloc] init];
        return _tabBarController;
    }
    
    // 引导图名称数组(适配不同屏幕引导图)
    NSArray *images = nil;
    if (iPhone4) {
        images = @[@"引导页1-640x960",@"引导页2-640x960",@"引导页3-640x960"];
    }
    if (iPhone5) {
        images = @[@"引导页1-640x1136",@"引导页2-640x1136",@"引导页3-640x1136"];
    }
    if (iPhone6) {
        images = @[@"引导页1-750x1334",@"引导页2-750x1334",@"引导页3-750x1334"];
    }
    if (iPhone6Plus) {
        images = @[@"引导页1-1242x2208",@"引导页2-1242x2208",@"引导页3-1242x2208"];
    }
    ABNewFeatureViewController *newNV = [[ABNewFeatureViewController alloc] initWithImages:images];
    [newNV setJumpButton:@"ios-i导游引导图-跳过button" multipliedByBottom:0.95];
    [newNV setStartExperienceButton:@"new_feature_finish_button" rightMargin:10 topMargin:15];
//    [newNV setStartButtonAnimateShown:YES];
    return newNV;
    
}

// 注销方法
- (void)loginOutHandle {
    
    KABNetworkDelegate.stringUserID = nil;
    KABNetworkDelegate.stringSID = nil;
    
    // 清除用户历史地址
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastSnapshot"];
    
    // 退出后返回到 ’我的‘界面’
    _tabBarController.selectedIndex = 0;
    ABLog(@"tabBarController2:%@",_tabBarController);
}


#pragma mark - 新特性（引导图）
// 是否新版本
- (BOOL)isNewVersion {
    
    // 1. 当前版本
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];;
    CGFloat version = [currentVersion doubleValue];
    
    // 2. 之前版本 - 保存在用户偏好设置中，不存在的则返回0
    NSString *sandboxVersionKey = @"sandboxVersionKey";
    CGFloat sandboxVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:sandboxVersionKey];
    
    // 3. 保存当前版本
    [[NSUserDefaults standardUserDefaults] setDouble:version forKey:sandboxVersionKey];

    
    return version > sandboxVersion;
//        return YES;   // 测试引导图使用
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
//    [self performSelector:@selector(dealSessionIsExpired) withObject:self afterDelay:3];
    
    [self dealSessionIsExpired];
}

- (UINavigationController *)currentNavigaiton {
    
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabViewConroller =  (UITabBarController *)self.window.rootViewController;
        return  tabViewConroller.selectedViewController;
        
    }
    
    return nil;
    
}

- (void)dealSessionIsExpired {
    
    if ([ABNetworkDelegate  isLogined] == NO) {
        
        return;
    }
    
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        [KYSNetwork getCustomerDescriptionWithParameters:nil success:^(id responseObject) {
            
            if (isSessionExpirated(responseObject)) {
            
                [ABNetworkDelegate loginOutHandle];
                
                ABLoginViewController *loginVC=[ABLoginViewController loginViewControllerWithDesinationController:@"ABProfileViewController"];
                loginVC.hidesBottomBarWhenPushed=YES;
                
                [[self currentNavigaiton] pushViewController:loginVC animated:YES];

                 [CustomToast showToastWithInfo:@"登陆信息已过期，请重新登陆"];
            }
         
        } failureBlock:^(id object) {
            
        } view:nil];

        
    }
 
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [KABNetworkDelegate forcedUpdate:KABNetworkDelegate.dictionaryForecedUpdate];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[ABNotifacation sharedNotifacation] getDeviceToken:deviceToken];
    
}


// ios7以后用这个处理后台任务接收到得远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [[ABNotifacation sharedNotifacation] receiveRomoteNotificationWhenApplicationOpeningWithNotification:userInfo];
    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *status = nil;
    NSLog(@"notification failue:%@",status);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    

    [[WeiXinPay sharedWeiXinPay] handleURL:url];
    
    [ALPayManager handleCallBackWithURL:url standbyCallback:^(NSDictionary * resultDic) {
        
        
    }];
    
    return  YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    [[WeiXinPay sharedWeiXinPay] handleURL:url];
    
    [ALPayManager handleCallBackWithURL:url standbyCallback:^(NSDictionary * resultDic) {
        
        
        
    }];
    
    return YES;
    
}


- (void)dealloc {
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ABSwitchRootViewControllerNotification object:nil];
}

@end
