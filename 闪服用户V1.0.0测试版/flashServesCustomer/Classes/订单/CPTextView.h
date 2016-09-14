
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KMaxLength 500
@interface CPTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placehoder;

@property (nonatomic , weak)UILabel *labelTint;
@property (nonatomic, weak)UIImageView *imageViewIcon;



@end
