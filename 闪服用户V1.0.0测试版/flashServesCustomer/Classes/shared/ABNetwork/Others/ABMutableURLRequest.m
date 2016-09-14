//
//  ABMutableURLRequest.m
//  aiguang
//
//  Created by mac on 11-10-25.
//  Copyright 2011年 aibang.com. All rights reserved.
//

#import "ABMutableURLRequest.h"
#import "ABSetting.h"
#import "OpenUDID.h"
#import "NSString+Encrypt.h"
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>

#import "ABNetworkConst.h"
#import "ABNetworkDelegate.h"
@implementation ABMutableURLRequest

+ (void)setupHttpHeader:(NSMutableURLRequest *)request uri:(NSString *)uri internetStatus:(NetworkStatus)status;
{
    UIDevice *device = [UIDevice currentDevice];
    
    NSString *cid = KABNetworkDelegate.stringCID;
    if (cid == nil || (KABNetworkDelegate.stringSecret == nil))  {
        cid = [ABSetting getInstance].CID;
    }

    NSString *openUDID =  [OpenUDID value];;
    
    NSString *sessionID = (NSString *)KABNetworkDelegate.stringSID;
    
    NSString *userID = (NSString *)KABNetworkDelegate.stringUserID;
    
    NSString *adId = [self timeItem];

    NSDate *dateNow = [NSDate date];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[dateNow timeIntervalSince1970]];
    
    NSString *machineInfo = [NSString stringWithFormat:@"Apple; %@; %@; %@; %@",device.systemName, device.model, device.systemVersion, NSStringFromCGSize([UIScreen mainScreen].currentMode.size)];
    
    NSString *secret = KABNetworkDelegate.stringSecret;
    if (!secret || [cid isEqualToString:[ABSetting getInstance].CID]) {
        secret = [ABSetting getInstance].pName;
    }
    
    
    NSString *platform = [ABSetting getInstance].platForm;

    NSString *httpUri = uri;
    
    NSString *token = [NSString stringWithFormat:@"%@%@%@%@/%@",secret, platform, cid, timeSp, httpUri];
    
    NSString *encodeToken = [[token sha1] md5];
    
    NSString *network = nil;
    
    if (status == ReachableViaWiFi) {
        network = @"Wifi";
    }
    else if (status == ReachableVia2G) {
        network = @"2G";
    }
    else if (status == ReachableVia3G) {
        network = @"3G";
    }
    else if (status == ReachableVia4G) {
        network = @"4G";
    }
    
    [request setValue:[ABSetting getInstance].productId forHTTPHeaderField:@"PID"];  //1、爱帮附近 2、爱帮公交 3、爱帮移动通 4、爱帮夜生活 5、北京实时公交 6、爱帮实时公交
    [request setValue:[ABSetting getInstance].versionId forHTTPHeaderField:@"VID"];
    [request setValue:platform forHTTPHeaderField:@"PLATFORM"];
    [request setValue:[ABSetting getInstance].source forHTTPHeaderField:@"PKG_SOURCE"];
    [request setValue:[ABSetting getInstance].source forHTTPHeaderField:@"SOURCE"];
    [request setValue:adId forHTTPHeaderField:@"IMSI"];
    [request setValue:openUDID forHTTPHeaderField:@"IMEI"];
    [request setValue:cid forHTTPHeaderField:@"CID"];
    [request setValue:userID forHTTPHeaderField:@"UID"];
    [request setValue:sessionID forHTTPHeaderField:@"SID"];
    [request setValue:machineInfo forHTTPHeaderField:@"UA"];
    [request setValue:network forHTTPHeaderField:@"NETWORK"];
    [request setValue:timeSp forHTTPHeaderField:@"TIME"];
    [request setValue:encodeToken forHTTPHeaderField:@"ABTOKEN"];
//    [request setValue:[ABSetting getInstance].version forHTTPHeaderField:@"VERSION"];
    [request setValue:[ABSetting getInstance].custom forHTTPHeaderField:@"CUSTOM"];
    [request setValue:@"json" forHTTPHeaderField:@"CTYPE"];
    
   
 
    ABLog(@"request  json%@",[request allHTTPHeaderFields]);
}



+ (NSString *)timeItem {
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"openUDID"] length] == 0) {
        
        NSString *time = [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]];
        
        [[NSUserDefaults standardUserDefaults]  setValue:time forKey:@"openUDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return time;
    }
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"openUDID"];
    
}




+ (NSMutableURLRequest *)requestGet:(NSString *)aUrl uri:(NSString *)uri queryString:(NSString *)aQueryString internetStatus:(NetworkStatus) status{
	NSMutableString *url = [[NSMutableString alloc] initWithString:aUrl];

	if (aQueryString.length > 0) {
		[url appendFormat:@"?%@", aQueryString];
	}
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"GET"];
	[request setTimeoutInterval:netWorkOutTime]; //timeout
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    [ABMutableURLRequest setupHttpHeader:request uri:uri internetStatus:status];

    ABLog(@"http request url: %@", url);

    return request;
}

+ (NSMutableURLRequest *)requestPost:(NSString *)aUrl uri:(NSString *)uri queryString:(NSData *)data internetStatus:(NetworkStatus) status{
	ABLog(@"htttp   aUrl:%@",aUrl);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:aUrl]];
	[request setHTTPMethod:@"POST"];
	[request setTimeoutInterval:20.0f];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:data];
//    multipart/form-data;boundary=0194784892923
    [ABMutableURLRequest setupHttpHeader:request uri:uri internetStatus:status];;
	

	return request;
}






@end
