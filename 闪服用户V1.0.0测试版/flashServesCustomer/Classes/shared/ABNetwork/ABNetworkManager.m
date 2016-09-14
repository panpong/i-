//
//  ABNetworkManager.m
//  netWork
//
//  Created by yjin on 15/4/24.
//  Copyright (c) 2015年 ptshan. All rights reserved.
//

#import "ABNetworkManager.h"
#import "ABMutableURLRequest.h"
#import "ABSetting.h"

#import "ABNetworkDelegate.h"
#import "ABNetworkManager.h"

@interface ABNetworkManager()


@property (nonatomic , strong)ABNetworkDelegate *netWorkDelegate;

@property (nonatomic, assign) NetworkStatus internetStatus;

@end

@implementation ABNetworkManager



static  ABNetworkManager *instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];

        
    });
    return instance;
}

+ (ABNetworkManager *)sharedNetworkManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [super manager] ;
        [instance activeAndVersion];
        instance.netWorkDelegate = [ABNetworkDelegate sharedNetworkDelegate];
        [instance listenNetworkState];
    });
    return instance;
}



- (void)listenNetworkState {
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
            case AFNetworkReachabilityStatusUnknown:

                ABLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                
                
                self.internetStatus = NotReachable;
                [[NSNotificationCenter defaultCenter] postNotificationName:disConnectionNetworkNotifation object:nil];
                ABLog(@"没有网络(断网)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
    
                ABLog(@"手机自带网络");
                [self postNetworkInPhoneNet:ReachableVia3G oldStatus:self.internetStatus];
                
//                [self postNovicationWith:ReachableVia3G];
                
                self.internetStatus = ReachableVia3G;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
           
                [self postNetworkInWifi:ReachableViaWiFi oldStatus:self.internetStatus];
                
//                [self postNovicationWith:ReachableViaWiFi];
                self.internetStatus = ReachableViaWiFi;
                ABLog(@"WIFI");
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}

- (void)postNetworkInWifi:(NetworkStatus)status oldStatus:(NetworkStatus)oldStatus{
    
    if ( ReachableViaWiFi == oldStatus) {
        
        return;
    }
    self.internetStatus = status;
    [[NSNotificationCenter defaultCenter] postNotificationName:connectingInWifiNetworkNotifation object:nil];;
    
    
    
}

- (void)postNetworkInPhoneNet:(NetworkStatus)status oldStatus:(NetworkStatus)oldStatus{
    
    if ( ReachableVia3G == oldStatus) {
        
        return;
    }
    
    self.internetStatus = status;
    [[NSNotificationCenter defaultCenter] postNotificationName:connectingIPhoneNetworkNotifation object:nil];;
    
}

//- (void)postNovicationWith:(NetworkStatus)status {
//    
//    if ( NotReachable == self.internetStatus) {
//        
//        self.internetStatus = status;
//        [[NSNotificationCenter defaultCenter] postNotificationName:connectingNetworkNotifation object:nil];;
//        
//    }
//    
//
//}


- (id)copyWithZone:(NSZone *)zone {
    return instance;
}

// 激活和版本检查
- (void)activeAndVersion{
    
    if ( KABNetworkDelegate.stringCID){
        [self version];
        return;
    }
    
    NSString *httpUri = @"app/v1.0.1/active";
   [self GETURI:httpUri parameters:nil success:^(id responseObject) {
        
       ABLog(@"active json%@",responseObject);
       
       [self.netWorkDelegate activeWithResponeObject:responseObject];
       
       [self version];
       
    } failure:^(NSError *error) {
        
        
    }];
    
}

// 版本检查
- (void)version
{
    
    [self GETURI:@"app/v1.0.1/version" parameters:nil success:^(id responseObject) {
        
        ABLog(@"version json %@",responseObject);
        
        [self.netWorkDelegate versionWithResponseObject:responseObject];
        
    } failure:^(NSError *error) {
        
        if (error){
            ABLog(@"version error%@",error);
        }
    }];
   
}

- (NSString *)serverUrl {
   
    return [ABNetworkDelegate serverURL];
}

- (NSString *)curVersion {
    
   return  [ABNetworkDelegate curVersion];
}


- (NSURLSessionTask *)GETURI:(NSString *)URI
                  parameters:(NSDictionary *)parameters
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure{
    
    ABLog(@"paramer %@",parameters);
    NSString *queryString = [self normalizedRequestParameters:parameters];
    ABLog(@"quertString %@",queryString);
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [self serverUrl], URI];
    ABLog(@"http URL %@",URL);
    NSMutableURLRequest *request = [ABMutableURLRequest requestGet:URL uri:URI queryString:queryString internetStatus:self.internetStatus];
    
    NSURLSessionTask *task =  [instance dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        ABLog(@"modal %@",responseObject);
        if (error){
            //ABLog(@"%@",error);
            failure(error);
            return ;
        }
        
        success(responseObject);
        
    }] ;
    
    // 为什么要 缓存task：
    [task resume];
    return task;
    

}


- (NSURLSessionTask *)POST:(NSString *)URI parameters:(NSDictionary *)parameters  success:(SuccessBlock)success   failure:(FailureBlock)failure{
    
   
    NSString *queryString = [self normalizedRequestParameters:parameters];
    
    ABLog(@"quertString    %@",queryString);
        
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [self serverUrl], URI];
    
    NSMutableURLRequest *request = [ABMutableURLRequest requestPost:URL uri:URI queryString:[queryString dataUsingEncoding:NSUTF8StringEncoding] internetStatus:self.internetStatus];
    
    NSURLSessionTask *task = [instance dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

        if (error){
            ABLog(@"%@",error);
            failure(error);
            return ;
        }
        
        success(responseObject);
        
    }];
 
    [task resume];
    return task;
}

- (NSString *)normalizedRequestParameters:(NSDictionary *)aParameters {
    
    if (aParameters == nil)
    {
        return nil;
    }
   return  [ABNetworkDelegate normalizedRequestParameters:aParameters];
    
}

- (void)updaleImage:(UIImage *)image success:(SuccessBlock)success   failure:(FailureBlock)failure{

    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [ABNetworkDelegate  serverURL], @"common/image/v1.0.1/upload"];

    
    [KABNetworkManager POST:URL uri:@"common/image/v1.0.1/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

//        UIImage *newImage = [self imageCompressForSize:image.si targetSize:<#(CGSize)#>]
//        
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if (data.length > 1024*1024) {
            
            CGFloat quatily = (1024 * 1024) / (float)data.length;
            quatily = quatily > 0.5? quatily : 0.5;
            data =  UIImageJPEGRepresentation(image, quatily);
            ABLog(@"quatily %f datalength %dKB",quatily,(data.length / 1024) );
        }
  
        
        [formData appendPartWithFileData:data  name:@"file" fileName:@"123.jpg" mimeType:@"image/jpeg"];


    } success:^(NSURLSessionDataTask *task, id responseObject) {

        
        ABLog(@"updaImage %@",responseObject);
         success(responseObject);


    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        failure(error);
    
    }];

}

// 等比例压缩
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}




- (void)updaleImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality success:(SuccessBlock)success   failure:(FailureBlock)failure {
    
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [ABNetworkDelegate  serverURL], @"common/image/v1.0.1/upload"];
    
    
    [KABNetworkManager POST:URL uri:@"common/image/v1.0.1/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *data = UIImageJPEGRepresentation(image, compressionQuality);
        ABLog(@"updaleImage:图片：%@上传图片data大小:%zdkb",image,data.length / 1024);
        
        [formData appendPartWithFileData:data  name:@"file" fileName:@"123.jpg" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

- (void)uploadDataWithURI:(NSString *)URI
                     name:(NSString*)name
                     data:(NSData *)data
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure{
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [self serverUrl], URI];
    [KABNetworkManager POST:URL uri:URI parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data  name:name fileName:@"" mimeType:@"application/json"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)getLastSnapshot {
    NSString *urlStr = @"customer/order/v1.0.1/lastSnapshot";
    
    [KABNetworkManager POST:urlStr parameters:nil success:^(id responseObject) {
        if ([@"200" isEqualToString:responseObject[@"errcode"]]) {
            NSDictionary *dictLocation = responseObject[@"company_location"];
            NSDictionary *lastSnapshotDict = [NSDictionary dictionaryWithObjects:@[responseObject[@"company_contact"],responseObject[@"company_tel"],responseObject[@"company_title"],dictLocation] forKeys:@[@"company_contact",@"company_tel",@"company_title",@"company_location"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:lastSnapshotDict forKey:@"lastSnapshot"];
        }
    } failure:^(id object) {
        ABLog(@"加载用户上一次下单失败了");
    }];
}


@end
