//
//  HFHTextView.h
//  flashServes
//
//  Created by 002 on 16/5/15.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFHTextView : UITextView

// 占位文字
@property (nonatomic, copy) NSString *placehoder;

// 输入限制
@property (nonatomic, assign)NSInteger maxLength;

// 占位文字坐标
@property (nonatomic, assign)CGPoint placeHoderPoint;


+ (instancetype)textViewWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder placeHoderPoint:(CGPoint)placeHoderPoint maxLength:(NSInteger)maxLength remainedWordsLabel:(UILabel *)remainWordsLabel;

@end
