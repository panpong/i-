//
//  ABCollectionConfig.h
//  KTSCollectionTest
//
//  Created by Liu Zhao on 16/3/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "UIDevice+KYSAddition.h"

#ifndef ABCollectionConfig_h
#define ABCollectionConfig_h

#define KYS_SCREEN_WIDTH (kiOS9Later?[UIScreen mainScreen].bounds:[UIScreen mainScreen].applicationFrame).size.width

#define KYS_WIDTH_RATE KYS_SCREEN_WIDTH/375.0

#define KYS_SPACE ((int)(12*KYS_WIDTH_RATE))

#endif /* ABCollectionConfig_h */
