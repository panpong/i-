//
//  ALPayManager.m
//  ALPay
//
//  Created by yjin on 15/5/20.
//  Copyright (c) 2015年 pchen. All rights reserved.
//

#import "ALPayManager.h"
#import "Order.h"
#import <UIKit/UIKit.h>

#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
//#import "MainViewController.h"
#import "ABSetting.h"
#import "ABNetworkConst.h"
//// 通知订单服务器地址
//#define notifyURLString @"http://60.28.211.186:8503/alipay/notify"

// 这是模拟线上的
//#define notifyURLString @"http://dev.aibang.com:8503/alipay/notify"

// 这是线上的接口
// #define notifyURLString @"http://bc.aibang.com/alipay/notify"


#define isPaySuccess(resultDic) [resultDic[@"resultStatus"] isEqualToString:@"9000"]

@implementation Product



@end

@implementation ALPayManager

// http://client.itshanfu.com/
// 回调URL
+ (NSString *)stringNotifyURLString {
    
    if ([ABSetting getInstance].isDebugServer == KDebug) {
        
        return @"http://client.itshanfu.com/pay/alipay/v1.0.1/notify";
//        return @"http://client.itshanfu.com/pay/alipay/v1.0.1/notify"  ;
    }
    else if ([ABSetting getInstance].isDebugServer == KWillRelease) {
        return @"http://client.itshanfu.com/pay/alipay/v1.0.1/notify";
    }
    return @"http://client.itshanfu.com/pay/alipay/v1.0.1/notify";
   
}


+ (void)buyWithProduct:(Product *)product completeBlock:(void(^)(int isSucess))complete{
    
    // 1  success -1 faiule 0 dengyu meiyouxiaog
    
    [self show];
    
    // 商家的ID号
    NSString *partner = @"2088221732795428";
    // 商家的支付宝账号
    NSString *seller = @"zhifubao@itshanfu.com";
    
    NSString *privateKey =   @"MIICXgIBAAKBgQDiJ29haFVWtlGLNmrKIQvHVHqsRQDgUuaI+31cS7yfbH6d0heOPjUQp0lcuIpCotEnaWuB5Dyg926zMGWVuPbnKycztWsV4aeQYViMYmh5CIvCI6/a9OFA5jRFwE57tzeSMGLtEpWQXK4TU1frJSHPD0e7gxZLmM3Cc47FBpRrJwIDAQABAoGAHDTq8W0/55bJyOE6pIdGns/slPvuRgxQ8JjdY9uWZRP1Ht4LThR4LeGPht8Fb5Y7G/1MCWFcJn918SeCJBBzytlLHZ51RFl1BWrb1F8NbU/AhdcXV2rHG3Tjl6bq7qlJd9VbLKni3PI5mdlCflVLpIN8a/ilKI3NSho+NSeuv0ECQQD4s7gsD2zBVKkUvKbG53L4ouXvgvuz97YQB9o67t2pSpQIADRsX5H0px3u9w64X6MMrkOmJeQEZCket32Xala3AkEA6MpVFyRTimOZseroNel96eTNLtBnLGnRHbxIHWBx41P/IldCCwJ6xUcI2G9n3OFvH1IkFUcOusBq7ns4d5+fEQJBAOKTCMTLQK9ZK7kCrYYkMfAmqAhuclVg5XLxVHXATB0BHp+zYA8jeltDLNgaKET8jBTvZh4mAvelMHkVfcvGSz0CQQCKLZemfeyMp6RSZIJjhe40iJh2YkPrq//xq5IOxfG0I2a9BphwGo+vTAPnHPHEvZeNOt+qNZx7o72VQ1T4RKpRAkEA7+aunlvh+74MCaQPFfBJ9+6rfQn1HJeMUryt7553vXgQcRy3gIaDj7PDCzyp3ENMLQtcBXMpnPJH5tKZYMiZAw==";
    
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.tradeNO = product.orderId;
    
    order.notifyURL =  [self stringNotifyURLString]; //回调URL
    order.partner = partner;
    order.seller = seller;
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"com.aibang.flashServesCustomer";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSLog(@"ALpayFormNormal reslut = %@",resultDic);
            if ([resultDic[@"resultStatus"] integerValue] == 9000) { //
                
                complete(1);
                return ;
            }
            
            if ([resultDic[@"resultStatus"] integerValue] == 6001) {
                
                complete(0);
                return;
            }
            
            complete(-1);
            
        }];
        
    }
    
}


+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    srand((unsigned int)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+ (void)handleCallBackWithURL:(NSURL *)url standbyCallback:(void(^)(NSDictionary * resultDic))block {
    
    if ([url.host isEqualToString:@"safepay"]) {
        
//        [[AlipaySDK defaultService] processAuth_V2Result:url
//                                         standbyCallback:^(NSDictionary *resultDic) {
//                                             
//                                           NSLog(@"result = %@",resultDic);
//                                             NSString *resultStr = resultDic[@"result"];
//                                             
//                                            
//                                             block(resultDic);
//                                         }];
//        
//    }
        // 从支付宝钱包中 返回会掉
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
               NSLog(@"result = %@",resultDic);

            
               block(resultDic);
            
        }];
    
      }
}


+ (void)show {
    
//    NSArray *arrayWindow = [UIApplication sharedApplication].windows;
//    
//    for (UIWindow *window in arrayWindow) {
//        if ([window.rootViewController isKindOfClass:[MainViewController class]]) {
//            
//            window.windowLevel = 500;
//        }
//    }
    
}

@end
