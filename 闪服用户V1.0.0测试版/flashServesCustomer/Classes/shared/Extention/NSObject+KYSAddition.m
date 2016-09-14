//
//  NSObject+KYSAddition.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/3/18.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "NSObject+KYSAddition.h"

@implementation NSObject (KYSAddition)

+ (NSString *)transformBitsToStringWithBits:(unsigned long)bits{
    int i=0;
    double bit_size=bits;
    NSArray *bArray=@[@"B",@"KB",@"MB",@"GB",@"T"];
    while (bit_size) {
        double count =bit_size/1024.0;
        if (count<1) {
            if (!i) {
                return [NSString stringWithFormat:@"%ld%@",bits,bArray[i]];
            }
            return [NSString stringWithFormat:@"%.2f%@",bit_size,bArray[i]];
        }
        bit_size=count;
        i++;
    }
    return @"0B";
}

@end
