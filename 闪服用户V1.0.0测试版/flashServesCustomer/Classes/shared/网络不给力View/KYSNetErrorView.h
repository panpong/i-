//
//  KYSNetErrorView.h
//  flashServes
//
//  Created by Liu Zhao on 16/4/12.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KYSNetErrorViewDelegate <NSObject>

- (void)tapAction;

@end


@interface KYSNetErrorView : UIView

@property(nonatomic,weak) id<KYSNetErrorViewDelegate> delegate;

- (void)showHint;

- (void)showHintWithStringImage:(NSString *)stringImage
                           text:(NSString *)text;

- (void)hideHint;

@end
