//
//  ABBigMessageView.h
//  flashServes
//
//  Created by 002 on 16/6/2.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABBigMessageView : UIView

///  初始化messageView
///
///  @param frame   frame - 默认值和keyWindow相同
///  @param message 要展示的信息
///
///  @return
+ (instancetype)bigMessageViewWithFrame:(CGRect)frame message:(NSMutableAttributedString *)message;

// 相应事件 - 打底展示信息
- (void)show;
@end
