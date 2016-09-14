//
//  WeiXinPay.m
//  customIBus
//
//  Created by yjin on 15/6/12.
//  Copyright (c) 2015年 aibang. All rights reserved.
//

#import "WeiXinPay.h"

#import "CustomToast.h"

#define APP_ID          @"wxf069ae9cf19d7dce"               //APPID

//商户号，填写商户对应参数
#define MCH_ID          @"1341947401"


NSString *WXPayResultNotification = @"WXPayResultNotification" ;
NSString *WXPayResultNotificationKey = @"WXPayResultNotificationKey" ;
@implementation WeiXinPay

static WeiXinPay *instance;
+ (instancetype)sharedWeiXinPay {
    
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            instance = [[WeiXinPay alloc]init];
            [WXApi registerApp:APP_ID];
           
        });
        return instance;
 
    
}

// 微信支付结果回调
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    
    NSDictionary *userInfoDictionary = nil;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                userInfoDictionary = @{WXPayResultNotificationKey:@"WXPaySuccess"};
                [[NSNotificationCenter defaultCenter] postNotificationName:WXPayResultNotification object:nil userInfo:userInfoDictionary];
                
                break;
            case WXErrCodeUserCancel:
          
                userInfoDictionary = @{WXPayResultNotificationKey:@"WXErrCodeUserCancel"};
                [[NSNotificationCenter defaultCenter] postNotificationName:WXPayResultNotification object:nil userInfo:userInfoDictionary];
                
                break;
            default: // 支付失败
                
                userInfoDictionary = @{WXPayResultNotificationKey:@"WXPayFailure"};
                [[NSNotificationCenter defaultCenter] postNotificationName:WXPayResultNotification object:nil userInfo:userInfoDictionary];
                
                
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    

  
}

- (void)PayWithDictionary:(NSDictionary *)dictionModary {
    
    
    [WXApi registerApp:APP_ID];
    //调起微信支付
    PayReq* req  = [[PayReq alloc] init];
    req.nonceStr = dictionModary[@"nonceStr"];
    req.sign = dictionModary[@"sign"];
    req.timeStamp = (UInt32)[dictionModary[@"timeStamp"] integerValue];
    req.prepayId = dictionModary[@"prepay_id"];
    req.package = @"Sign=WXPay";
    req.partnerId = MCH_ID;
    req.openID = APP_ID;
    
    [WXApi sendReq:req];

    
}

- (void)handleURL:(NSURL *)url  {
    
    [WXApi handleOpenURL:url delegate:self];
}


@end
