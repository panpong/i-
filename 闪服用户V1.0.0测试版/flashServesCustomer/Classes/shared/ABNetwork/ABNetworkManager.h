//
//  ABNetworkManager.h
//  netWork
//
//  Created by yjin on 15/4/24.
//  Copyright (c) 2015年 ptshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "ABNetworkConst.h"
#import "ABNetworkDelegate.h"

#define  KNetStatus [ABNetworkManager sharedNetworkManager].internetStatus

@interface ABNetworkManager : AFHTTPSessionManager


// 当前网络状态
@property (nonatomic, readonly) NetworkStatus internetStatus;

// 单例的 创建方法
+ (ABNetworkManager *)sharedNetworkManager;

/**
 *  get 访问方法
 *
 *  @param URI        URI 是 baseURL 之后 的 部分URL
 *  @param parameters 字典参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (NSURLSessionTask * )GETURI:(NSString *)URI parameters:(NSDictionary *)parameters  success:(SuccessBlock)success   failure:(FailureBlock)failure;


/**
 *  Post 访问方法
 *
 *  @param URI        URI 是 baseURL 之后 的 部分URL
 *  @param parameters 字典参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (NSURLSessionTask *)POST:(NSString *)URI parameters:(NSDictionary *)parameters  success:(SuccessBlock)success   failure:(FailureBlock)failure;

- (void)updaleImage:(UIImage *)image success:(SuccessBlock)success   failure:(FailureBlock)failure;

- (void)updaleImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality success:(SuccessBlock)success   failure:(FailureBlock)failure;

- (void)uploadDataWithURI:(NSString *)URI
                     name:(NSString*)name
                     data:(NSData *)data
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure;

- (NSString *)curVersion;

// 获取用户上一次下单信息
- (void)getLastSnapshot;

#pragma mark 下期改善

@end
