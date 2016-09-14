//
//  ABCommonAdressViewController.h
//  flashServes
//
//  Created by 002 on 16/3/23.
//  Copyright © 2016年 002. All rights reserved.
//  '常用住址'控制器

#import <UIKit/UIKit.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKSuggestionSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearchOption.h>

@class ABCommonAdressViewController;

@protocol chosedCommonAdressDelegate <NSObject>

@optional
/**
 代理方法 - 选中地址后的处理
 
 @param poiDetailResult poi检索的结果对象（包含坐标等信息）
 */
- (void)chosedCommonAdress:(BMKPoiInfo *)poiDetailResult;
- (void)chosedCommonAdress:(BMKPoiInfo *)poiDetailResult locationID:(NSString *)locationID;

@end

@interface ABCommonAdressViewController : UIViewController

@property(nonatomic,weak) id<chosedCommonAdressDelegate> delegate;
@property(nonatomic,strong) BMKCitySearchOption *searchOption;
@property(nonatomic,strong) NSString *locationID;   // 传入的locationID

- (instancetype)initWithSearchOption:(BMKCitySearchOption *)searchOption;
+ (instancetype)commonAdressViewController:(BMKCitySearchOption *)searchOption;

@end
