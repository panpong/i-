//
//  CPTextLineCell.h
//  flashServes
//
//  Created by yjin on 16/4/25.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CPLineCellTypeHintText = 0, // 左边提示显示灰色 右边黑色
    
    CPLineCellTypeHintTextLeftRight = 1,  // 左边提示显示灰色 右边黑色
    CPLineCellTypeConmentTextLeftRight = 2  ,  // 提示文字 和内容都显示黑色
    CPLineCellTypeConmentTextAddress = 3 // 特点是左边文字灰色显示 ， 右边文字黑色显示地址（高度随着地址长度而变化）
} CPLineCellType;

@interface CPTextLineCell : UIView

- (void)setLineHint:(NSString *)hint content:(NSString *)content type:(CPLineCellType )type;

- (CGFloat)heightContentLayout;



@end
