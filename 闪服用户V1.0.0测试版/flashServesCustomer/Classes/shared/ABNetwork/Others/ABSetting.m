//
//  ABSetting.m
//  aiguang
//
//  Created by mac on 11-10-24.
//  Copyright 2011年 aibang.com. All rights reserved.
//

#import "ABSetting.h"

@implementation ABSetting

@synthesize isDebug, isDebugServer, isTestRun, versionId, version, source, productId, platForm, custom, pName, CID, searchCity;

//void ABLog(NSString * format,...){
//    if ([ABSetting getInstance].isDebug) {
//    va_list  args;
//    va_start(args, format);
//    ABLogv(format,args);
//    va_end(args);
//    }
//}
- (id)init
{
    self = [super init];
    if (self) {
        //debug control, load from config file.
        NSString *fileUrl = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SystemSetting.plist"];
        NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:fileUrl];
        
        NSInteger debugLevel = [[config objectForKey:@"DebugLevel"] intValue];
        
        isDebug = (debugLevel % 2) > 0;
        
        isDebugServer = debugLevel;

        version = [config objectForKey:@"Version"];
        
        versionId = [config objectForKey:@"VersionId"];

        source = [config objectForKey:@"Source"];
        
        productId = [config objectForKey:@"ProductID"];
        
        platForm = [config objectForKey:@"PlatForm"];
        
        pName = [config objectForKey:@"PName"];
        
        custom = [config objectForKey:@"Custom"];
        
        CID = [config objectForKey:@"CID"];
        
        searchCity = [config objectForKey:@"SearchCity"];
    }
    
    return self;
}

+ (ABSetting *)getInstance {
// p
    static ABSetting* setting = nil;
    if (setting == nil) {
        setting = [[ABSetting alloc] init];
    }
    
    return setting;
}

- (NSString *)product {
    return @"aiguang";
}

#pragma mark userInfo Path

+ (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"UserInfo"];
}

@end
