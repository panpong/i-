//
//  CPButtonWithHightColor.h
//  flashServes
//
//  Created by yjin on 16/5/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    //以下是枚举成员 TestA = 0,
    BackGroundColorBlue = 0,
    BackGroundColorDark = 1,
}BackGroundColor;

@interface CPButtonWithHightColor : UIButton

@property (nonatomic, assign)BackGroundColor typeBackGroundColor;


@end
