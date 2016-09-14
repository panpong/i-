//
//  NSString+encrypt.m
//  AB_RealTimeBus
//
//  Created by Liu Zhao on 15/1/9.
//  Copyright (c) 2015年 Liu Zhao. All rights reserved.
//

#import "NSString+encrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#import "DESUtility.h"

@implementation NSString (Encrypt)

- (NSString *)sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)base64
{
    NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString * output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}

- (NSString *)decodeBase64
{
    NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString * output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}

/* ios自带base64加密方法 */
- (NSString *)ios7EncodeBase64
{
    NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding];
    NSString *output = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return output;
}

/* ios自带base64解密方法 */
- (NSString *)ios7DecodeBase64
{
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *output = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
    return output;
}

- (NSString *)realTimeBusRc4Decrypt:(NSString *)aInput key:(NSString *)key
{
    key = [key md5]; // md5加密key
    
    NSString *output = [DESUtility decryptStr:aInput withKey:key];
    
    return output;
}

@end
