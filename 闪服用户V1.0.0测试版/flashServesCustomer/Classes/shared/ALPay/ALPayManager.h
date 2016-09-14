//
//  ALPayManager.h
//  ALPay
//
//  Created by yjin on 15/5/20.
//  Copyright (c) 2015年 pchen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

// 商品价格,价格最低到 分，分之后会做截断处理
@property (nonatomic, assign) float price;

// 商品标题
@property (nonatomic, copy) NSString *subject;

// 商品描述
@property (nonatomic, copy) NSString *body;

// 商品ID
@property (nonatomic, copy) NSString *orderId;

@end


@interface ALPayManager : NSObject


+ (void)buyWithProduct:(Product *)product completeBlock:(void(^)(int isSucess))complete;


// 这方法在 appDeleget 中调用， 支付宝跳转到 自己应用时，会调用这个方法
+ (void)handleCallBackWithURL:(NSURL *)url  standbyCallback:(void(^)(NSDictionary * resultDic))block;


@end
