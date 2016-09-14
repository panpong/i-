//
//  ABNotifacation.m
//  ABNotification
//
//  Created by yjin on 15/5/30.
//  Copyright (c) 2015年 pchen. All rights reserved.
//

#import "ABNotifacation.h"
#import <UIKit/UIKit.h>
#import "CustomToast.h"
#import "ABNetworkDelegate.h"

#import "AppDelegate.h"

#import "CPOrderDetailViewController.h"
#import "ABNetworkDelegate.h"
#import "ABNetworkManager.h"

@interface ABNotifacation ()<UIAlertViewDelegate>


@property (nonatomic, strong)NSString *stringDevieToken;

@property (nonatomic, strong)NSURLSessionTask *sessionTask;

@end

@implementation ABNotifacation


static ABNotifacation* instance;
+ (ABNotifacation *)sharedNotifacation{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
         instance = [[ABNotifacation alloc] init];
         UIApplication *application = [UIApplication sharedApplication];
        if ([UIDevice currentDevice].systemVersion.doubleValue < 8.0) {
            // 不是iOS8
            UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
            // 当用户第一次启动程序时就获取deviceToke
            // 该方法在iOS8以及过期了
            // 只要调用该方法, 系统就会自动发送UDID和当前程序的Bunle ID到苹果的APNs服务器
            [application registerForRemoteNotificationTypes:type];
        }else
        {
            // iOS8
            UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
            // 注册通知类型
            [application registerUserNotificationSettings:settings];
            
            // 申请试用通知
            [application registerForRemoteNotifications];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(loginSuccee:) name:NOTIFICATION_LOGINSUCCESS object:nil];
        
//         NOTIFICATION_LOGINOUT
//         [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(loginOutHandle:) name:NOTIFICATION_LOGINOUT object:nil];
        
        instance.isShowNoficationButton = NO;
      
    });
    
    return  instance;
    
}


- (void)upDateDeviceToken {
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"] isEqualToString:_stringDevieToken] || _stringDevieToken.length == 0) {
        
        return;
    };
    
    if( [ABNetworkDelegate isLogined] == NO || _stringDevieToken.length == 0) {
        return;
    }
    
    [KABNetworkManager POST:@"customer/info/v1.0.1/updatePushid" parameters:@{@"pushid":_stringDevieToken} success:^(id responseObject) {
        
        ABLog(@"responseObject:%@",responseObject);
        if (checkNetworkResultObject(responseObject)) {
            
            [[NSUserDefaults standardUserDefaults] setValue:_stringDevieToken forKey:@"deviceToken"];
            [[NSUserDefaults  standardUserDefaults] synchronize];
            
        }
        
    } failure:^(id object) {
        ABLog(@"failture:%@",object);
        
    }];
    
}
//
//
- (void)getDeviceToken:(NSData *)DeviceToken {
    
    // 线判断是不是登陆：
    
    NSString *strignToke = [DeviceToken description];
    strignToke =  [strignToke stringByReplacingOccurrencesOfString:@" " withString:@""];
    strignToke = [strignToke stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strignToke = [strignToke stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    _stringDevieToken = strignToke;
    
    [self upDateDeviceToken];
  
    
}
//
//
- (NSMutableDictionary *)dictionWithString:(NSString *)strign {
    
    NSArray *array = [strign componentsSeparatedByString:@":"];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    for (NSString *stringValue in array) {
        
        NSArray *array = [stringValue componentsSeparatedByString:@"|"];
        [userDic setValue:array[1] forKey:array[0]];
        
    }
    return userDic;
    
}
//
//
//
- (BOOL )showRedDotWith:(NSDictionary *)userDic {
    
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateActive ) { // 在app 中 进行推送，生成红点
        
        if([userDic[@"action"] isEqualToString:@"remind"] || [userDic[@"action"] isEqualToString:@"setout"]|| [userDic[@"action"] isEqualToString:@"recover"]) { // 进入抢单
            
          
        }
        
            return NO;

    }
    return YES;
    
}
//
- (void)receiveRomoteNotificationWhenApplicationOpeningWithNotification:(NSDictionary *)userInfo {
    
    
    ABLog(@"apnsUserInfo:|%@",userInfo);
    NSString *stringData = userInfo[@"aps"][@"data"];
    NSDictionary *userDic = [self dictionWithString:stringData];

    BOOL isContinue =  [self showRedDotWith:userDic] ;
    if (isContinue == NO) {
        
        return;
    }
     // 在后台中进行推送
    [self popToListWithDic:userDic];
}
//
//
- (void)popToListWithDic:(NSDictionary *)userDic {
    
    if(  [ABNetworkDelegate isLogined] == NO ) {
        
        
        ABLog(@"notifaction:没有登陆");
        return;
    }

    if([userDic[@"action"] isEqualToString:@"remind"] || [userDic[@"action"] isEqualToString:@"setout"]|| [userDic[@"action"] isEqualToString:@"recover"] ||
        [userDic[@"action"] isEqualToString:@"neworder"]) { // 进入抢单
        
        [self popToListisAccept:YES orderID:userDic[@"order_id"]];
        
    }
  
}
//
- (void)popToListisAccept:(BOOL)isAccept orderID:(NSString *)oederID {
    
    if(  [ABNetworkDelegate isLogined] == NO ) {
        
        return;
    }
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    if( [delegate.window.rootViewController isKindOfClass:[UITabBarController class]] ) {
        
        UITabBarController *tabVC = (UITabBarController *)delegate.window.rootViewController;
        
        [tabVC setSelectedIndex:2];
        
        UINavigationController *nav = tabVC.childViewControllers[2];
        [nav popToRootViewControllerAnimated:NO];
        

        CPOrderDetailViewController *detatilVC = [[CPOrderDetailViewController alloc] init];

        detatilVC.orderID = oederID;

        detatilVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:detatilVC animated:YES];
        
        
    };
    

}
//
//
- (void)receiveRomoteNotificationWhenApplicationClosedWithOptions:(NSDictionary *)launchOptions; {
    
    // 拿到数据
      NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo == nil) {
    
        return;
    }
    NSString *stringData = userInfo[@"aps"][@"data"];
    ABLog(@"notification %@",userInfo);
    NSDictionary *userDic = [self dictionWithString:stringData];
    [self popToListWithDic:userDic];
}

//- (void)setIsShowRedDotGrab:(BOOL)isShowRedDotGrab {
//    
//    _isShowRedDotAccept = isShowRedDotGrab;
//    // -1 表示隐藏，
//    NSString *key = isShowRedDotGrab == YES ? @"-2" :@"-1";
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLabel1NubmerNotification" object:nil userInfo:@{@"number":key}];
//    
//    
//    [self setApplicationBageNumber];
//    
//}
//
//- (void)setApplicationBageNumber {
//    
//    int num = self.isShowRedDotAccept + self.isShowRedDotGrab;
//    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
//    
//}
//
//- (void)setIsShowRedDotAccept:(BOOL)isShowRedDotAccept {
//    
//    _isShowRedDotAccept = isShowRedDotAccept;
//    NSString *key = isShowRedDotAccept == YES ? @"-2" :@"-1";
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLabel2NubmerNotification" object:nil userInfo:@{@"number":key}];
//    
//    [self setApplicationBageNumber];
//    
//}
//
- (void)loginSuccee:(NSNotification *)notification {
    
    [self upDateDeviceToken];
   
}

//- (void)loginOutHandle:(NSNotification *)notification {
//    
//    
//    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"deviceToken"];
//    [[NSUserDefaults  standardUserDefaults] synchronize];
//  
//}

- (void)loginOutWith:(void(^)())block  {
    
    [KABNetworkManager POST:@"customer/info/v1.0.1/updatePushid" parameters:@{@"pushid":@"1"} success:^(id responseObject) { // @"1" 是 为了替换本地的token 随便写的
        
        if (checkNetworkResultObject(responseObject)) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"deviceToken"];
            [[NSUserDefaults  standardUserDefaults] synchronize];
            if (block != nil) {
               block();
            }
            return ;
        }
        if (isSessionExpirated(responseObject)) {
            if (block != nil) {
                block();
            }
            return;
        }
        
        [CustomToast showDialog:responseObject[kErrmsg]];
    } failure:^(id object) {
        
        [CustomToast showNetworkError];
    }];
    
}




@end
