//
//  CPBusiness.h
//  flashServesCustomer
//
//  Created by yjin on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABNetworkConst.h"
@interface CPBusiness : NSObject


+ (void)getOrderListParamer:(NSDictionary *)paramer success:(SuccessBlock)success   failure:(FailureBlock)failure;




@end
