//
//  KYSTextView.h
//  flashServes
//
//  Created by Liu Zhao on 16/3/17.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYSTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placehoder;

@property (nonatomic, assign)CGFloat maxLength;

@property (nonatomic, assign)CGPoint placeHoderPoint;

@end
