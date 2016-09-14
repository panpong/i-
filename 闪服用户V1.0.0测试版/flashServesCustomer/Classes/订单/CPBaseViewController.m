//
//  CPBaseViewController.m
//  flashServes
//
//  Created by yjin on 16/3/28.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPBaseViewController.h"
#import "AppDelegate.h"
#import "ABNetworkManager.h"
#import "UIView+Extention.h"
#import "CustomToast.h"
enum  {
    ViewTypeLoading = 0,
    ViewTypeError = 1
}ViewType;

@interface CPBaseViewController ()

@property (nonatomic, weak)UIView *loadingView;
@property (nonatomic, weak)UIView *errorView;
@property (nonatomic, strong)UITapGestureRecognizer *tap;

@end

@implementation CPBaseViewController

- (UITapGestureRecognizer *)tap {
    
    if (_tap == nil) {
        
        _tap =   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        
    }
    return _tap;
    
}


- (UIView *)errorView {
    
    if (_errorView == nil) {
        UIView *view = [[UIView alloc] init];
        _errorView = view;
 
        [_errorView addGestureRecognizer:self.tap];
        [_errorView setBackgroundColor:kColorBackground];
        
        UILabel *label = [[UILabel alloc] init];
        [label setText:@"网络不给力，请检查设置后再试"];
        [label setTextColor:kColorTextGrey];
        [label setFont:[UIFont systemFontOfSize:15]];
        [_errorView addSubview:label];
        [label sizeToFit];
     
        
        UIImageView *errnet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ios_点击刷新"]];
        [errnet sizeToFit];
        
        [_errorView addSubview:errnet];

        CGFloat x = ScreenWidth * 0.5;
        CGFloat y = (ScreenHeight - 64) * 0.3;
        
        errnet.centerX = x;
        errnet.centerY = y;

        label.centerX = x;
        label.y = CGRectGetMaxY(errnet.frame) + 45;

         [self.view addSubview:view];
    }
    return _errorView;
    
}

- (UIView *)loadingView {
    
    if (_loadingView == nil) {
        
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        _loadingView = view;
        [self.view addSubview:view];
    }
    return _loadingView;
}

- (void)removeView:(UIView *)view {
    
    [view removeFromSuperview];

    if (view == _errorView ) {
        
        [_errorView removeGestureRecognizer:self.tap];
        _errorView = nil;
    }else {
        _loadingView = nil;
    }
}

- (void)removeAllView {
    
    [self removeView:_errorView];
    [self removeView:_loadingView];
    
}

- (void)removeOtherView:(NSInteger)type {
    
    switch (type) {
            
        case ViewTypeLoading:
            
            [self removeView:_errorView];
            
            break;
            
        default:
            [self removeView:_loadingView];
            break;
    }
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    ABLog();
    if (isDisConnectedNetwork) {
        
        [self showErrorView];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showErrorView {
    
    if (_errorView == nil) {
        
        [self removeOtherView:ViewTypeError];
     
        self.errorView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
        [self.view bringSubviewToFront:_errorView];
    }

}

- (void)showLoadingView {
    
    if (_loadingView == nil) {
        [self removeOtherView:ViewTypeLoading];
             [CustomToast showWating];

        self.loadingView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
        
        [self.view bringSubviewToFront:_loadingView];
    }

}

- (void)removeLoadingView {
    [CustomToast hideWating];
    [self removeView:_loadingView];
}




- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    if (_loadingView ) {
        
        [self.view bringSubviewToFront:_loadingView];
    }
    
    if (_errorView) {
        
        [self.view bringSubviewToFront:_errorView];
    }
    
}

- (void)removeErrorView {
    
     [self removeView:_errorView];
}



- (void)tapClick {
    
   
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
