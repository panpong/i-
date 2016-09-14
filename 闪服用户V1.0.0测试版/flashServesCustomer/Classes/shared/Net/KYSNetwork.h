//
//  KYSNetwork.h
//  flashServes
//
//  Created by Liu Zhao on 16/3/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABNetworkManager.h"

extern NSString *errmsgKey;

@interface KYSNetwork : NSObject

+ (KYSNetwork *)sharedBusiness;

//上传图片
+ (void)postImageWithImage:(UIImage *)image
                   success:(SuccessBlock)sucess
              failureBlock:(FailureBlock)failure
                      view:(UIView *)view;

//用户的概要信息
+(void)getCustomerDescriptionWithParameters:(NSDictionary *)parameters
                                    success:(SuccessBlock)sucess
                               failureBlock:(FailureBlock)failure
                                       view:(UIView *)view;

//修改绑定邮箱
+(void)updateEmailWithParameters:(NSDictionary *)parameters
                         success:(SuccessBlock)sucess
                    failureBlock:(FailureBlock)failure
                            view:(UIView *)view;

//修改密码
+(void)updatePasswordWithParameters:(NSDictionary *)parameters
                            success:(SuccessBlock)sucess
                       failureBlock:(FailureBlock)failure
                               view:(UIView *)view;

//修改用户基本信息
+(void)updateProfileWithParameters:(NSDictionary *)parameters
                           success:(SuccessBlock)sucess
                      failureBlock:(FailureBlock)failure
                              view:(UIView *)view;

//提交评价信息
+(void)commitCommentWithParameters:(NSDictionary *)parameters
                           success:(SuccessBlock)sucess
                      failureBlock:(FailureBlock)failure
                              view:(UIView *)view;

//获取服务项
+(void)getServerItemWithParameters:(NSDictionary *)parameters
                           success:(SuccessBlock)sucess
                      failureBlock:(FailureBlock)failure
                              view:(UIView *)view;
//提交订单
+ (void)submitOrderWithParameters:(NSDictionary *)parameters
                          success:(SuccessBlock)sucess
                     failureBlock:(FailureBlock)failure
                             view:(UIView *)view;
//支付订单
+ (void)payOrderWithParameters:(NSDictionary *)parameters
                       success:(SuccessBlock)sucess
                  failureBlock:(FailureBlock)failure
                          view:(UIView *)view;

//获取服务包列表
+ (void)getPackageListWithParameters:(NSDictionary *)parameters
                             success:(SuccessBlock)sucess
                        failureBlock:(FailureBlock)failure
                                view:(UIView *)view;

//服务包下单
+ (void)summitPackagePalceOrderWithParameters:(NSDictionary *)parameters
                                      success:(SuccessBlock)sucess
                                 failureBlock:(FailureBlock)failure
                                         view:(UIView *)view;

//意见反馈
+ (void)sugggestWithParameters:(NSDictionary *)parameters
                       success:(SuccessBlock)sucess
                  failureBlock:(FailureBlock)failure
                          view:(UIView *)view;



@end
