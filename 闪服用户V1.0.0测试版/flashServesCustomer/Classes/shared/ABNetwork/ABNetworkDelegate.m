//
//  ABNetworkDelegate.m
//  netWork
//
//  Created by yjin on 15/4/29.
//  Copyright (c) 2015年 ptshan. All rights reserved.
//

#import "ABNetworkDelegate.h"
#import "ABNetworkConst.h"
#import "ABSetting.h"
#import "NSString+URLEncoding.h"
#import "AppDelegate.h"

//#import "ABToast.h"


@interface ABNetworkDelegate()<UIAlertViewDelegate>

// 表示服务器返回更新地址的URL
@property (nonatomic, strong)NSMutableDictionary *upDateDict;


@end

@implementation ABNetworkDelegate

static  ABNetworkDelegate *instance;
+ (ABNetworkDelegate *)sharedNetworkDelegate {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[ABNetworkDelegate alloc] init];
        
        instance.isShowADView = NO;
        
        instance.stringCID =  [[NSUserDefaults standardUserDefaults] objectForKey:kCidKey];
        
        instance.stringSecret = [[NSUserDefaults standardUserDefaults] objectForKey:KSecretKey];
        
        instance.stringSID = [[NSUserDefaults standardUserDefaults] objectForKey:KSessionIDKey];
        
        instance.stringUserID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIDKey];
        
        instance.stringUserName = [[NSUserDefaults standardUserDefaults] objectForKey:userNameKey];
        
         NSString *distance = [[NSUserDefaults standardUserDefaults] objectForKey:kStringMoreFitDistanceKey];
        if ( distance.length == 0 ) {
            
            instance.stringMoreFitDistance = @"100";
        }else {
            
            instance.stringMoreFitDistance  = distance;
        }
        
        instance.dictionaryForecedUpdate = nil;
    });
    
    
    return instance;
    
    
}

#pragma  mark set方法 

- (void)setStringMoreFitDistance:(NSString *)stringMoreFitDistance {
    
    //NSAssert(stringMoreFitDistance != nil, @"");
    _stringMoreFitDistance = stringMoreFitDistance;
    [[NSUserDefaults standardUserDefaults] setObject:_stringMoreFitDistance forKey:kStringMoreFitDistanceKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];;
    
}


- (void)setStringCID:(NSString *)stringCID {
    
    _stringCID = stringCID;
    [[NSUserDefaults standardUserDefaults] setObject:stringCID forKey:kCidKey];

    [[NSUserDefaults standardUserDefaults] synchronize];;
}


- (void)setStringSecret:(NSString *)stringSecret {
    
    _stringSecret = stringSecret;
    [[NSUserDefaults standardUserDefaults] setObject:_stringSecret forKey:KSecretKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];;
    
}

- (void)setStringUserID:(NSString *)stringUserID{
    
    _stringUserID = stringUserID;
    [[NSUserDefaults standardUserDefaults] setObject:_stringUserID forKey:KUserIDKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)setStringUserName:(NSString *)stringUserName {
    
    _stringUserName = stringUserName;
    
    if (stringUserName == nil) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:userNameKey];
        
        
    }else {
        
      [[NSUserDefaults standardUserDefaults] setObject:_stringUserName forKey:userNameKey];
    
    
    }
      [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)setStringSID:(NSString *)stringSID {
    
    _stringSID = stringSID;
    
    if (stringSID == nil) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KSessionIDKey];
        
    }else {
        
        [[NSUserDefaults standardUserDefaults] setObject:stringSID forKey:KSessionIDKey];
        
    }

   [[NSUserDefaults standardUserDefaults] synchronize];
}




// 激活处理
-(void)activeWithResponeObject:(id)responseObject {
    
    ABLog(@"function: %s",__FUNCTION__);
    
    if (!responseObject) {
        return;
    }
    if (checkNetworkResultObject(responseObject)) {
        
          NSDictionary *dic = (NSDictionary *)responseObject;
          NSString *cid = dic[kCidKey];
          NSString *code = dic[@"code"];
        
        self.stringCID = cid;
        self.stringSecret = code;
        
    }
}

// 版本更新跳转到URL
- (void)versionWithResponseObject:(id)responseObject{
    
         ABLog(@"function: %s",__FUNCTION__);

        if (checkNetworkResultObject(responseObject)) {
            
            self.stringMoreFitDistance = responseObject[@"distince"];
            // 显示友盟
            self.isShowADView =  [[responseObject objectForKey:@"showyoumeng"] integerValue];
            
            self.dictionaryForecedUpdate = nil;
            
            NSString *status = [responseObject objectForKey:@"status"];
            if ([status isEqualToString:@"N"]) { // 最新版本
                
            }
            else if ([status isEqualToString:@"O"]) { // 运行并提示

                [self tipUpdate:responseObject];
                
            }
            else if ([status isEqualToString:@"A"]) { // 运行不提示
            
                
            }
            else if ([status isEqualToString:@"E"]) { // 强制更新

                [self forcedUpdate:responseObject];
                self.dictionaryForecedUpdate = [NSDictionary dictionaryWithDictionary:responseObject];;
            }
            
        }
}

- (void)tipUpdate:(id)responseObject {
    
     ABLog(@"function: %s",__FUNCTION__);
    self.upDateDict = [responseObject objectForKey:@"newest"];
    NSString *updateMessage = [[responseObject objectForKey:@"newest"] objectForKey:@"description"];
    updateMessage = [updateMessage stringByReplacingOccurrencesOfString:@"|||" withString:@"\n"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[responseObject objectForKey:@"newest"] objectForKey:@"title"]
                                                        message:updateMessage
                                                       delegate:self
                                              cancelButtonTitle:@"以后再说"
                                              otherButtonTitles:@"立即更新", nil];
    
    alertView.tag = tUpdateTag;
    [alertView show];
    
}

// applicationDidBecomeActive
- (void)forcedUpdate:(id)responseObject {
     ABLog(@"function: %s",__FUNCTION__);
    
    if (responseObject == nil) {
        
        return;
    }
    
    self.upDateDict = [responseObject objectForKey:@"newest"];
    NSString *updateMessage = [[responseObject objectForKey:@"newest"] objectForKey:@"description"];
    updateMessage = [updateMessage stringByReplacingOccurrencesOfString:@"|||" withString:@"\n"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[responseObject objectForKey:@"newest"] objectForKey:@"title"]
                                                        message:updateMessage
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"立即更新", nil];
    
    alertView.tag = tForceUpdateTag;
    [alertView show];

    
    
}

// 返回当前版本
static NSString *version;

+ (NSString *)curVersion{
    
    if (version == nil){
        
      return [[NSBundle mainBundle] objectForInfoDictionaryKey:KCurVersionKey];
        
    }
    return version;
}


// 返回服务器地址
+ (NSString *)serverURL {
    
    if ([ABSetting getInstance].isDebugServer == KDebug) {
        return KDebug_URL  ;
    }
    else if ([ABSetting getInstance].isDebugServer == KWillRelease) {
        return KWillRelease_URL;
    }
    return KRelease_URL;
}

// 返回服务器Html5页面地址
+ (NSString *)serverHtml5URL {
    
    if ([ABSetting getInstance].isDebugServer == KDebug) {
        return KDebug_Html5URL  ;
    }
    else if ([ABSetting getInstance].isDebugServer == KWillRelease) {
        return KWillRelease_URL;
    }
    return KRelease_URL;
}





+ (NSString *)normalizedRequestParameters:(NSDictionary *)aParameters {
    
    ABLog(@"normalizedRequestParameters:%@",aParameters);
    
    NSMutableArray *parametersArray = [NSMutableArray array];
    for (NSString *key in aParameters) {
        NSString *value = [aParameters valueForKey:key];
        [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",
                                    key,
                                    [value isKindOfClass:[NSString class]]?[value URLEncodedString]:value]];
    }
    return [parametersArray componentsJoinedByString:@"&"];
}


#pragma mark -----UIAlertViewDelegate-----
// 强制更新
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    NSString *upDateDictKey = @"url";
    
    if (alertView.tag == tUpdateTag) { // 升级
        if (buttonIndex == 1) {

            if ([[self.upDateDict objectForKey:upDateDictKey] length]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.upDateDict objectForKey:upDateDictKey]]];
             }
            
            else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesURL]];
            }
        }
    }
    else if (alertView.tag == tForceUpdateTag) { // 强制更新
        
        if (buttonIndex == 0) {
            

            if ([[self.upDateDict objectForKey:upDateDictKey] length]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.upDateDict objectForKey:upDateDictKey]]];
            }
            else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesURL]];
            }
            
            
        }
    }
}

+ (void)loginOutHandle {
    // 切换到登录界面
    KABNetworkDelegate.stringUserID = nil;
    KABNetworkDelegate.stringSID = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:ABSwitchRootViewControllerNotification object:@"loginOutHandle"];
}

+ (BOOL)isLogined {
    
    if (KABNetworkDelegate.stringUserID && ![@"" isEqualToString:KABNetworkDelegate.stringUserID]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isLongTermUser {
        NSString *userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    if ([@"1" isEqualToString:userType]) {
        return YES;
    } else {
        return NO;
    }
}

@end
