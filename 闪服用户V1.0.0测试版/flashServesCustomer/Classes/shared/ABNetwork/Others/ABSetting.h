//
//  ABSetting.h
//  aiguang
//
//  Created by mac on 11-10-24.
//  Copyright 2011年 aibang.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//TODO:             测试key 1infzasuei0hxckia21nihx
#define wPlusKey @"27853b8f8e90ff4bf0b55bdb7046d463"

@interface ABSetting : NSObject

@property(nonatomic, readonly) BOOL isDebug;

@property(nonatomic, readonly) NSInteger isDebugServer;

@property(nonatomic, readonly) BOOL isTestRun;

@property(nonatomic, readonly) NSString *product;  // 产品

@property(nonatomic, readonly) NSString *productId;  // 产品ID

@property(nonatomic, readonly) NSString *version;  // 版本

@property(nonatomic, readonly) NSString *versionId;  // 版本ID,数字

@property(nonatomic, readonly) NSString *source;

@property(nonatomic, readonly) NSString *platForm;  // 平台

@property(nonatomic, readonly) NSString *pName;  // 产品标识

@property(nonatomic, readonly) NSString *custom;

@property(nonatomic, readonly) NSString *CID;

@property(nonatomic, readonly) NSString *searchCity;

+ (ABSetting*)getInstance;

+ (NSString *)dataFilePath;

@end
