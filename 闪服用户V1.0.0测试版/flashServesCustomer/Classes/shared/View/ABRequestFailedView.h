//
//  ABRequestFailedView.h
//  flashServesCustomer
//
//  Created by 002 on 16/5/12.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABRequestFailedView : UIView


/**
 返回一个指定大小和位置的请求失败页面
 大小是（宽高）是必须指定的，位置可以创建出对象后自己再设置
 
 @param frame  frame
 @param action 刷新时执行的方法
 @param object 执行刷新方法的对象
 
 @return 网络请求失败页面
 */
+ (instancetype)requestFailedViewWithFrame:(CGRect)frame action:(SEL)action object:(id)object;

@end
