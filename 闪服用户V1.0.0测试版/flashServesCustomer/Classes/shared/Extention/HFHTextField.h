//
//  HFHTextField.h
//  HFHTextField
//
//  Created by 002 on 15/12/26.
//  Copyright © 2015年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFHTextField : UITextField

@property(nonatomic,assign) NSInteger placeHolderPadding;   // placeHolder距离左边的间距
@property(nonatomic,strong) UIColor *placeHolderColor;  // placeHolder的颜色
@property(nonatomic,assign) NSInteger placeHolderFontSize;  // placeHolder字体大小
@property(nonatomic,assign) NSInteger limitLength;    // 输入字数限制

+ (instancetype)textFieldWithPlaceHolder:(NSString *)placeHolder placeHolderSize:(CGFloat)fontSize placeHolderPadding:(NSInteger)padding leftViewImageName:(NSString *)imageName;

@end
