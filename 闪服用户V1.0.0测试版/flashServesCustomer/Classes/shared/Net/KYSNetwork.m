//
//  KYSNetwork.m
//  flashServes
//
//  Created by Liu Zhao on 16/3/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import "KYSNetwork.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustomToast.h"
#import "ABMutableURLRequest.h"
#import "ABNetworkDelegate.h"
#import "AFHTTPSessionManager.h"
#import "ABSetting.h"
#import "OpenUDID.h"
#import "ABMutableURLRequest.h"
#import "ABNetworkConst.h"

NSString *errmsgKey = @"errmsg";

@implementation KYSNetwork

+ (KYSNetwork *)sharedBusiness {
    static KYSNetwork *shared=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[KYSNetwork alloc] init];
    });
    return shared;
}

//上传图片
+ (void)postImageWithImage:(UIImage *)image
                   success:(SuccessBlock)sucess
              failureBlock:(FailureBlock)failure
                      view:(UIView *)view{
    if (!image) {
        ABLog(@"图片不存在");
        return;
    }
    NSString *url = @"common/image/v1.0.1/upload";
    NSDictionary *parameters=@{@"file":UIImageJPEGRepresentation(image, 0.5)};
    [KABNetworkManager POST:url parameters:parameters success:^(id responseObject) {
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        failure(nil);
    } failure:^(NSError *error) {
        failure(error);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
    }];
}

//用户的概要信息
+(void)getCustomerDescriptionWithParameters:(NSDictionary *)parameters
                                    success:(SuccessBlock)sucess
                               failureBlock:(FailureBlock)failure
                                       view:(UIView *)view{
    NSString *url = @"customer/info/v1.0.1/profile";
    [CustomToast showWatingInView:view];
    [KABNetworkManager GETURI:url parameters:parameters success:^(id responseObject) {
        [CustomToast hideWatingInView:view];
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        [CustomToast showToastWithInfo:responseObject[errmsgKey]];
        failure(nil);
    } failure:^(NSError *error) {
        [CustomToast hideWatingInView:view];
        failure(error);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }else{
            
        }
    }];
}

//修改绑定邮箱
+(void)updateEmailWithParameters:(NSDictionary *)parameters
                         success:(SuccessBlock)sucess
                    failureBlock:(FailureBlock)failure
                            view:(UIView *)view{
    NSString *url = @"customer/info/v1.0.1/updateEmail";
    [CustomToast showWatingInView:view];
    [KABNetworkManager GETURI:url parameters:parameters success:^(id responseObject) {
        [CustomToast hideWatingInView:view];
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        [CustomToast showToastWithInfo:responseObject[errmsgKey]];
        failure(responseObject);
    } failure:^(NSError *error) {
        [CustomToast hideWatingInView:view];
        failure(error);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
    }];
}

//修改密码
+(void)updatePasswordWithParameters:(NSDictionary *)parameters
                            success:(SuccessBlock)sucess
                       failureBlock:(FailureBlock)failure
                               view:(UIView *)view{
    NSString *url = @"customer/info/v1.0.1/updatePassword";
    [CustomToast showWatingInView:view];
    [KABNetworkManager POST:url parameters:parameters success:^(id responseObject) {
        [CustomToast hideWatingInView:view];
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        [CustomToast showToastWithInfo:responseObject[errmsgKey]];
        failure(nil);
    } failure:^(NSError *error) {
        [CustomToast hideWatingInView:view];
        failure(error);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
    }];
}

//修改用户基本信息
+(void)updateProfileWithParameters:(NSDictionary *)parameters
                            success:(SuccessBlock)sucess
                       failureBlock:(FailureBlock)failure
                               view:(UIView *)view{
    NSString *url = @"customer/info/v1.0.1/updateProfile";
    [CustomToast showWatingInView:view];
    [KABNetworkManager POST:url parameters:parameters success:^(id responseObject) {
        [CustomToast hideWatingInView:view];
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        [CustomToast showToastWithInfo:responseObject[errmsgKey]];
        failure(nil);
    } failure:^(NSError *error) {
        [CustomToast hideWatingInView:view];
        failure(error);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
    }];
}

//提交评价信息
+(void)commitCommentWithParameters:(NSDictionary *)parameters
                           success:(SuccessBlock)sucess
                      failureBlock:(FailureBlock)failure
                              view:(UIView *)view{
    NSString *url = @"customer/order/v1.0.1/comment";
    [CustomToast showWatingInView:view];
    [KABNetworkManager POST:url parameters:parameters success:^(id responseObject) {
        [CustomToast hideWatingInView:view];
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        [CustomToast showToastWithInfo:responseObject[errmsgKey]];
        failure(nil);
    } failure:^(NSError *error) {
        [CustomToast hideWatingInView:view];
        failure(error);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
    }];
}

//获取服务项
+(void)getServerItemWithParameters:(NSDictionary *)parameters
                           success:(SuccessBlock)sucess
                      failureBlock:(FailureBlock)failure
                              view:(UIView *)view{
    NSString *url = @"service/v1.0.1/detail";
    [CustomToast showWatingInView:view];
    [KABNetworkManager GETURI:url parameters:parameters success:^(id responseObject) {
        [CustomToast hideWatingInView:view];
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        [CustomToast showToastWithInfo:responseObject[errmsgKey]];
        failure(nil);
    } failure:^(NSError *error) {
        [CustomToast hideWatingInView:view];
        failure(error);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
    }];
}


//提交订单
+ (void)submitOrderWithParameters:(NSDictionary *)parameters
                          success:(SuccessBlock)sucess
                     failureBlock:(FailureBlock)failure
                             view:(UIView *)view{
    NSString *url = @"service/order/v1.0.1/submit";
    [CustomToast showWatingInView:view];
    [KABNetworkManager POST:url parameters:parameters success:^(id responseObject) {
        [CustomToast hideWatingInView:view];
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        [CustomToast showToastWithInfo:responseObject[errmsgKey]];
        failure(responseObject);
    } failure:^(NSError *error) {
        [CustomToast hideWatingInView:view];
        failure(error);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
    }];
}

//支付订单
+ (void)payOrderWithParameters:(NSDictionary *)parameters
                          success:(SuccessBlock)sucess
                     failureBlock:(FailureBlock)failure
                             view:(UIView *)view{
    NSString *url = @"customer/order/v1.0.1/pay";

    [KABNetworkManager POST:url parameters:parameters success:^(id responseObject) {
       
        sucess(responseObject);
    } failure:^(NSError *error) {
       
        failure(error);
        
    }];
}

//获取服务包列表
+ (void)getPackageListWithParameters:(NSDictionary *)parameters
                             success:(SuccessBlock)sucess
                        failureBlock:(FailureBlock)failure
                                view:(UIView *)view{
    NSString *url = @"customer/packages/v1.0.1/list";
    [CustomToast showWatingInView:view];
    [KABNetworkManager POST:url parameters:parameters success:^(id responseObject) {
        [CustomToast hideWatingInView:view];
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        [CustomToast showToastWithInfo:responseObject[errmsgKey]];
        failure(nil);
    } failure:^(NSError *error) {
        [CustomToast hideWatingInView:view];
        failure(error);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
    }];
}

//服务包下单
+ (void)summitPackagePalceOrderWithParameters:(NSDictionary *)parameters
                                      success:(SuccessBlock)sucess
                                 failureBlock:(FailureBlock)failure
                                         view:(UIView *)view{
    NSString *url = @"customer/packages/v1.0.1/submit";
    [CustomToast showWatingInView:view];
    [KABNetworkManager POST:url parameters:parameters success:^(id responseObject) {
        [CustomToast hideWatingInView:view];
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        [CustomToast showToastWithInfo:responseObject[errmsgKey]];
        failure(nil);
    } failure:^(NSError *error) {
        [CustomToast hideWatingInView:view];
        failure(error);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
    }];
}

//意见反馈
+ (void)sugggestWithParameters:(NSDictionary *)parameters
                       success:(SuccessBlock)sucess
                  failureBlock:(FailureBlock)failure
                          view:(UIView *)view{
    NSString *url = @"app/v1.0.1/suggest";
    dispatch_async(dispatch_get_main_queue(), ^{
        [CustomToast showWatingInView:view];
    });
    [KABNetworkManager GETURI:url parameters:parameters success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CustomToast hideWatingInView:view];
        });
        if (checkNetworkResultObject(responseObject)) {
            sucess(responseObject);
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [CustomToast showToastWithInfo:responseObject[errmsgKey]];
        });
        failure(nil);
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CustomToast hideWatingInView:view];
        });
        failure(error);
        if (isDisConnectedNetwork) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CustomToast showNetworkError];
            });
        }
    }];
}



@end
