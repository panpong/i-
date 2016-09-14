//
//  ABMutableURLRequest.h
//  aiguang
//
//  Created by mac on 11-10-25.
//  Copyright 2011年 aibang.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABNetworkConst.h"
@interface ABMutableURLRequest : NSObject

//Return a request for http get method
+ (NSMutableURLRequest *)requestGet:(NSString *)aUrl uri:(NSString *)uri queryString:(NSString *)aQueryString internetStatus:(NetworkStatus) status ;

//Return a request for http post method
+ (NSMutableURLRequest *)requestPost:(NSString *)aUrl uri:(NSString *)uri queryString:(NSData *)data internetStatus:(NetworkStatus) status;

+ (void)setupHttpHeader:(NSMutableURLRequest *)request uri:(NSString *)uri internetStatus:(NetworkStatus)status;


@end
