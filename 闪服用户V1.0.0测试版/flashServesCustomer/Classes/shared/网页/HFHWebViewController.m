//
//  HFHWebViewController.m
//  flashServesCustomer
//
//  Created by 002 on 16/5/6.
//  Copyright © 2016年 002. All rights reserved.
//

#import "HFHWebViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import <WebKit/WebKit.h>
#import "ABNetworkManager.h"
#import "UIImageView+Extention.h"
#import "UILabel+Extention.h"
#import "UIView+Extention.h"
#import "CustomToast.h"

#define IOS8x ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define WebViewNav_TintColor ([UIColor orangeColor])

@interface HFHWebViewController ()<UIActionSheetDelegate,WKNavigationDelegate>

@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;

// WKWebView 更快（占用内存可能只有 UIWebView 的1/3~1/4），没有缓存
@property (strong, nonatomic) WKWebView *wkWebView;

@property(nonatomic,strong) UIView *requestFailedView;  // 请求失败的view

@property(nonatomic,strong) UIButton *deleteButton;   // 删除按钮 - add by fhhe

@property(nonatomic,assign) BOOL isShownDeleteButton;   // 是否展示删除按钮

// 是否需要缓存 iOS9以上的版本才支持设置缓存方法（即版本>=iOS9设置isCaching = YES才会生效）
@property(nonatomic,assign) BOOL isCaching;

@end

@implementation HFHWebViewController

+ (void)showWithController:(UIViewController *)controller withUrlStr:(NSString *)urlStr withTitle:(NSString *)title hidesBottomBarWhenPushed:(BOOL)ishidden {
    // 默认设置有缓存
    [HFHWebViewController showWithController:controller withUrlStr:urlStr withTitle:title hidesBottomBarWhenPushed:ishidden isCaching:true];
}

+ (void)showWithController:(UIViewController *)controller withUrlStr:(NSString *)urlStr withTitle:(NSString *)title hidesBottomBarWhenPushed:(BOOL)ishidden isCaching:(BOOL)isCaching {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    } else {
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    }
    HFHWebViewController *webController = [HFHWebViewController new];
    
    webController.isCaching = isCaching;
    if (ishidden) {
        webController.hidesBottomBarWhenPushed = YES;
    }
    webController.homeUrl = [NSURL URLWithString:urlStr];
    webController.title = title;
    [controller.navigationController pushViewController:webController animated:YES];
    
}

+ (void)showWithController:(UIViewController *)controller withUrlStr:(NSString *)urlStr withTitle:(NSString *)title isShownDeleteButton:(BOOL)isShownDeleteButton isCaching:(BOOL)isCaching {
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HFHWebViewController *webController = [HFHWebViewController new];
    // 设置缓存
    webController.isCaching = isCaching;
    webController.homeUrl = [NSURL URLWithString:urlStr];
    webController.title = title;
    
    webController.isShownDeleteButton = isShownDeleteButton;
    
    [controller.navigationController pushViewController:webController animated:YES];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavigationBarItem:self.title leftButtonIcon:@"返回" rightButtonTitle:nil];
    ABLog(@"setNavigationBar:%@",self.navigationBar);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isShownDeleteButton) {
        [self reConfigNavigationBar];
    }
}

#pragma mark - 重新布局导航栏
- (void)reConfigNavigationBar {
    //    [self.leftButton removeTarget:self action:@selector(clickLeftNavButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:self.deleteButton];
    
    self.deleteButton.centerY = self.leftButton.centerY;
    self.deleteButton.x = self.leftButton.right;
    
    //    [self.leftButton addTarget:self action:@selector(backtoPersonViewController) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 导航栏返回按钮点击事件
- (void)clickLeftNavButton {
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
        if (self.navigationItem.leftBarButtonItems.count == 1) {
            [self configColseItem];
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configUI {
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 0)];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    // 网页
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    wkWebView.backgroundColor = [UIColor whiteColor];
    wkWebView.navigationDelegate = self;
    [self.view insertSubview:wkWebView belowSubview:progressView];
    
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    // 判断是否清楚缓存
    if (iOS9 && !self.isCaching) {
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                             for (WKWebsiteDataRecord *record  in records)
                             {
                                 //                             if ( [record.displayName containsString:@"baidu"]) //取消备注，可以针对某域名清除，否则是全清
                                 //                             {
                                 [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                           forDataRecords:@[record]
                                                                        completionHandler:^{
                                                                            NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                        }];
                                 //                             }
                             }
                         }];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
    [wkWebView loadRequest:request];
    self.wkWebView = wkWebView;
}

- (void)configBackItem {
    
    // 导航栏的返回按钮
    UIImage *backImage = [UIImage imageNamed:@"cc_webview_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 22)];
    [backBtn setTintColor:WebViewNav_TintColor];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = colseItem;
}

- (void)configMenuItem {
    
    // 导航栏的菜单按钮
    UIImage *menuImage = [UIImage imageNamed:@"cc_webview_menu"];
    menuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    [menuBtn setTintColor:WebViewNav_TintColor];
    [menuBtn setImage:menuImage forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItem = menuItem;
}

- (void)configColseItem {
    
    // 导航栏的关闭按钮
    UIButton *colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [colseBtn setTitleColor:WebViewNav_TintColor forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(colseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [colseBtn sizeToFit];
    
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:colseBtn];
    NSMutableArray *newArr = [NSMutableArray arrayWithObjects:self.navigationItem.leftBarButtonItem,colseItem, nil];
    self.navigationItem.leftBarButtonItems = newArr;
}

#pragma mark - 普通按钮事件

// 返回按钮点击
- (void)backBtnPressed:(id)sender {
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
        if (self.navigationItem.leftBarButtonItems.count == 1) {
            [self configColseItem];
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 菜单按钮点击
- (void)menuBtnPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"safari打开",@"复制链接",@"分享",@"刷新", nil];
    [actionSheet showInView:self.view];
}

// 关闭按钮点击
- (void)colseBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 菜单按钮事件

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSString *urlStr = _homeUrl.absoluteString;
    urlStr = self.wkWebView.URL.absoluteString;
    
    if (buttonIndex == 0) {
        // safari打开
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if (buttonIndex == 1) {
        
        // 复制链接
        if (urlStr.length > 0) {
            [[UIPasteboard generalPasteboard] setString:urlStr];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已复制链接到黏贴板" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
        }
    }else if (buttonIndex == 2) {
        
        // 分享
        //[self.wkWebView evaluateJavaScript:@"这里写js代码" completionHandler:^(id reponse, NSError * error) {
        //NSLog(@"返回的结果%@",reponse);
        //}];
        NSLog(@"这里自己写，分享url：%@",urlStr);
    }else if (buttonIndex == 3) {
        // 刷新
        [self.wkWebView reload];
    }
}

#pragma mark - WKWebViewDelegate
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    // 针对h5页面中的拨打电话做处理
    if ([webView.URL.absoluteString containsString:@"makecall="]) {
        NSRange range = [webView.URL.absoluteString rangeOfString:@"makecall="];
        //            NSLog(@"str======%@",str);
        NSString *str = [NSString stringWithFormat:@"telprompt://%@",[webView.URL.absoluteString substringFromIndex:range.location + range.length]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        return;
    }
    [CustomToast showWatingInView:self.view];
    if (self.requestFailedView.superview) {
        [self.requestFailedView removeFromSuperview];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [CustomToast hideWatingInView:self.view];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [CustomToast hideWatingInView:self.view];
    if (isDisConnectedNetwork && self.requestFailedView.superview == nil) {
        [self.view addSubview:self.requestFailedView];
    }
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    // 针对h5页面中的拨打电话做处理
    if ([webView.URL.absoluteString containsString:@"makecall="]) {
        decisionHandler(WKNavigationResponsePolicyCancel);
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

#pragma mark - 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

// 记得取消监听
- (void)dealloc {
    if (IOS8x) {
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

#pragma mark - 重新请求
- (void)sendRequsetAgain {
    NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
    [self.wkWebView loadRequest:request];
}

#pragma mark - 返回上一级界面
- (void)backupLastView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 返回个人中心界面
- (void)backtoPersonViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UIView *)requestFailedView {
    if (!_requestFailedView) {
        _requestFailedView = [[UIView alloc] init];
        _requestFailedView.backgroundColor = kColorBackground;
        _requestFailedView.frame = CGRectMake(0, SIZE_HEIGHT_NAVIGATIONBAR, ScreenWidth, ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR);
        UIImageView *refreshImageView = [UIImageView imageName:@"ios_点击刷新"];
        UILabel *descLabel = [UILabel labelWithTitle:@"网络不给力，请检查设置后再试" fontSize:15 color:kColorTextGrey];
        [_requestFailedView addSubview:refreshImageView];
        [_requestFailedView addSubview:descLabel];
        refreshImageView.center = CGPointMake(ScreenWidth / 2, _requestFailedView.height / 2 - 50);
        refreshImageView.y = (ScreenHeight - 64) * 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        // 再次发送请求
        [tap addTarget:self action:@selector(sendRequsetAgain)];
        refreshImageView.userInteractionEnabled = YES;
        [_requestFailedView addGestureRecognizer:tap];
        
        descLabel.center = refreshImageView.center;
        descLabel.y = refreshImageView.bottom + 45;
        
    }
    return _requestFailedView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"top-×"] forState:UIControlStateNormal];
        _deleteButton.width = 44;
        _deleteButton.height = 44;
        [_deleteButton addTarget:self action:@selector(backupLastView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
