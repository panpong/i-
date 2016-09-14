//
//  NSDictionary+Log.m
//  04-视频播放
//
//  Created by male on 15/9/24.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

// 本地化测试的方法. 只需要将这个分类添加到项目中,不需要导入任何文件,以后的打印就可以直接打印自己想要的语言了.
-(NSString *)descriptionWithLocale:(id)locale
{
    // 需要在里面,打印字典的单个属性.就会将汉字显示出来了.
    
    NSMutableString *strM = [NSMutableString stringWithFormat:@"{"];
    
    // 遍历数组/字典中的每一个属性,然后打印
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //
        [strM appendFormat:@"\n\"%@\":\"%@\",",key,obj];
        
    }];
    
    [strM appendFormat:@" }"];
    
    return strM;
}
@end

@implementation NSArray (Log)

// 本地化测试的方法. 只需要将这个分类添加到项目中,不需要导入任何文件,以后的打印就可以直接打印自己想要的语言了.
-(NSString *)descriptionWithLocale:(id)locale
{
    // 需要在里面,打印字典的单个属性.就会将汉字显示出来了.
    
    NSMutableString *strM = [NSMutableString stringWithFormat:@"{"];
    
    // 遍历数组/字典中的每一个属性,然后打印
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
           [strM appendFormat:@"\n\"%@\",",obj];
    }];

    [strM appendFormat:@"%@ }",strM];

    return strM;
}
@end

