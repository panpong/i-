//
//  CPBusiness.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPBusiness.h"
#import "ABNetworkManager.h"
@implementation CPBusiness

+ (void)getOrderListParamer:(NSDictionary *)paramer success:(SuccessBlock)success   failure:(FailureBlock)failure {
    
    [KABNetworkManager GETURI:@"customer/order/v1.0.1/list" parameters:paramer success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(id object) {
       
        failure(object);
        
    }];
 
}




@end
