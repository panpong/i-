//
//  NSString+encrypt.h
//  AB_RealTimeBus
//
//  Created by Liu Zhao on 15/1/9.
//  Copyright (c) 2015年 Liu Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

- (NSString *)md5;

- (NSString *)sha1;

- (NSString *)base64;

- (NSString *)decodeBase64;

- (NSString *)ios7EncodeBase64;

- (NSString *)ios7DecodeBase64;

@end
