//
//  CustomToast.m
//  customIBus
//
//  Created by aibang on 15/5/18.
//  Copyright (c) 2015年 aibang. All rights reserved.
//

#import "CustomToast.h"
#import "ABToast.h"
#import "MBProgressHUD.h"

@implementation CustomToast


+ (void)showDialog:(NSString *)string {
    

    [CustomToast showToastWithInfo:string];
    
}

+ (void)showDialog:(NSString *)string time:(CGFloat)seconds {
    
   UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    [ABToast showDialog:string initView:window WithTime:seconds];
    
}


+ (void)showToastWithInfo:(NSString *)info{
    [ABToast showDialog:info];
}

+ (void)showNetworkError {
    [self showToastWithInfo:@"网络不给力，请检查设置后再试"];
}

static bool isShowing = NO;
+ (void)showWating {

    if (isShowing == YES) {
        return;
    }
    isShowing = YES;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    [self showWatingInView:window];
    
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
//    int screenHeight=ScreenWidth;
//    int heihgt=150;
//    if (screenHeight<=480) {
//        heihgt=40;
//    }else if (screenHeight<=568){
//        heihgt=60;
//    }else{
//        heihgt=80;
//    }
//    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, heihgt, heihgt)];
//    imageView.backgroundColor=[UIColor clearColor];
//    UIImage *image1=[UIImage imageNamed:@"+1"];
//    UIImage *image2=[UIImage imageNamed:@"+2"];
//    UIImage *image3=[UIImage imageNamed:@"+3"];
//    UIImage *image4=[UIImage imageNamed:@"+4"];
//  
//    if (image1&&image2&&image3&&image4) {
//        imageView.animationImages=@[image1,image2,image3,image4];
//    }
//    imageView.animationDuration=0.5;
//    imageView.animationRepeatCount=0;
//    [imageView startAnimating];
//    hud.customView=imageView;
//    hud.mode=MBProgressHUDModeCustomView;
//    hud.opacity=0;
//    [window addSubview:hud];
//    [hud show:YES];
}

+ (void)showWatingInView:(UIView *)view {
    [self showWatingInView:view duration:0 str:nil];
}

+ (void)showWatingInView:(UIView *)view duration:(CGFloat) duration{
    [self showWatingInView:view duration:duration str:nil];
}

+ (void)showWatingInView:(UIView *)view str:(NSString *)str{
    [self showWatingInView:view duration:0 str:str];
}

+ (void)showWatingInView:(UIView *)view duration:(CGFloat)duration str:(NSString *)str
{
    if (view == nil) {
        //ABLog(@"view == nil 不显示提示框");
        return;
    }
//    if (isShowing == YES) {
//        NSLog(@"ww=========wwwwwwwwwwww========oooo");
//        return;
//    }
    isShowing = YES;
    
    if ([view viewWithTag:10021]) {
        return;
    }
    
    //[MBProgressHUD showHUDAddedTo:view animated:YES];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
//    //int screenHeight = CGRectGetHeight([ UIScreen mainScreen ].applicationFrame);
//    int screenHeight=ScreenWidth;
//    int heihgt=150;
//    if (screenHeight<=480) {
//        heihgt=40;
//    }else if (screenHeight<=568){
//        heihgt=60;
//    }else{
//        heihgt=80;
//    }
//    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, heihgt, heihgt)];
//    imageView.backgroundColor=[UIColor clearColor];
//    
//    UIImage *image1=[UIImage imageNamed:@"+1"];
//    UIImage *image2=[UIImage imageNamed:@"+2"];
//    UIImage *image3=[UIImage imageNamed:@"+3"];
//    UIImage *image4=[UIImage imageNamed:@"+4"];
//    if (image1&&image2&&image3&&image4) {
//        imageView.animationImages=@[image1,image2,image3,image4];
//    }
//    imageView.animationDuration=0.5;
//    imageView.animationRepeatCount=0;
//    [imageView startAnimating];
//    
//    if (str.length) {
//        UIView *bView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, heihgt+10+20)];
//        bView.backgroundColor=[UIColor clearColor];
//
//        imageView.center=CGPointMake(ScreenWidth/2, heihgt/2);
//        [bView addSubview:imageView];
//        
//        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, heihgt+10, ScreenWidth, 20)];
//        label.backgroundColor=[UIColor clearColor];
//        label.font=[UIFont systemFontOfSize:15.0];
//        label.textAlignment=NSTextAlignmentCenter;
//        label.textColor=[UIColor darkGrayColor];
//        label.text=str;
//        [bView addSubview:label];
//        
//        hud.customView=bView;
//    }else{
//        hud.customView=imageView;
//    }
//    hud.mode=MBProgressHUDModeCustomView;
    hud.mode=MBProgressHUDModeIndeterminate;
    //hud.opacity=0;
    hud.tag=10021;
    [view addSubview:hud];
    [hud show:YES];
    //传入时间大于0,会在此时间后隐藏
    if (duration) {
        [hud hide:YES afterDelay:duration];
    }
}

+ (void)showToastWithString:(NSString *)string InView:(UIView *)view {
    
    if (view == nil) {
        return;
    }
    
    if (isShowing == YES) {
        return;
    }
    isShowing = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = string;
    
    
}

+ (void)showWatingWithString:(NSString *)string {
    
     UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    [self showToastWithString:string InView:window];
    
}

+ (void)hideWating {
    
    if (isShowing == NO) {
        
        return ;
    }
    isShowing = NO;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    [MBProgressHUD  hideHUDForView:window animated:NO];
}

+ (void)hideWatingInView:(UIView *)view {
    if (view == nil) {
        return;
    }
    isShowing = NO;
    [MBProgressHUD  hideHUDForView:view animated:NO];
}



@end
