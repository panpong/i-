//
//  CPChoicePhoto.h
//  flashServes
//
//  Created by yjin on 16/3/17.
//  Copyright © 2016年 002. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CPChoicePhoto : NSObject

@property (nonatomic,assign)BOOL isOriginImage;

- (void)showPhotoChoicesWith:(void(^)(UIImage *choiceImage))choiceImage ;

@end
