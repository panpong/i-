//
//  ABLoginViewController.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/15.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABLoginViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "UIView+Extention.h"
#import "HFHTextField.h"
#import "UIImageView+Extention.h"
#import <SDWebImageManager.h>
#import "ABNetworkManager.h"
#import "CustomToast.h"
#import "UIButton+Extention.h"
#import "ABRegisterViewController.h"
#import "ABServesCallView.h"
#import "ABRetrievePasswordViewController.h"

#define SIZE_LOGO 100    // ‘logoView’的宽高
#define PADDING_LOGOVIEW_TOP 45 // ‘logoView’距离顶部距离
#define PADDING_IDENTIFYINGCODEIMAGEVIEW_TOP 8 // 验证码图片距离输入框顶部距离
#define SIZE_WIDTH_IDENTIFYINGCODEIMAGEVIEW 70 // 验证码图片宽度
#define PADDING_LOGINBUTTON_TOP 20 // 登录按钮距离上一个控件的距离
#define PADDING_RIGISTERBUTTON_TOP 16 // ‘立即注册’按钮距离‘登录’按钮上间距
#define PADDING_RIGISTERBUTTON_LEFT 22 // ‘立即注册’按钮距离‘屏幕’左边距离
#define PADDING_SERVESCALL_BOTTOM 19   // ‘客服视图’距离底部距离
#define PADDING_TOP_accountTextField 35 // accountTextField顶部间距

@interface ABLoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,ABRegisterViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;   // scrollView
@property(nonatomic,strong) UIImageView *logoImageView; // logo
@property(nonatomic,strong) HFHTextField *accountTextField; // 账号输入框
@property(nonatomic,strong) HFHTextField *passworkTextField;    // 密码输入框
@property(nonatomic,strong) HFHTextField *identifyingCodeTextField; // 验证码输入框
@property(nonatomic,strong) UIButton *identifyingCodeButton;  // 验证码图片
@property(nonatomic,strong) UIButton *loginButton;  // 登录按钮
@property(nonatomic,assign) CGFloat contentOffsetY; // 键盘弹出后scrollView需要滚动的值
@property(nonatomic,strong) UIView *sep1;   // 分割线1
@property(nonatomic,strong) UIView *sep2;   // 分割线2
@property(nonatomic,strong) UIView *sep3;   // 分割线3
@property(nonatomic,strong) UIButton *registerButton;   // 注册按钮
@property(nonatomic,strong) UIButton *forgotPasswordButton; // 忘记密码按钮
@property(nonatomic,strong) ABServesCallView *servesCallView;   // 客服视图
@property(nonatomic,strong) UIButton *passwordRightButton;  // 密码输入框的右视图按钮
@property (nonatomic, copy) NSString *desinationControllerStr; // 目标控制器的名称
@property (nonatomic, strong) UIViewController *desinationController; // 目标控制器
@property(nonatomic,assign) NSUInteger selectedIndex;   // 返回后的tabbar的索引
@property(nonatomic,assign) BOOL isAutoLogin;   // 是否自动登录

@end

@implementation ABLoginViewController

#pragma mark - 构造方法
- (instancetype)initWithDesinationController:(NSString *)desinationControllerStr  {
    self = [super init];
    self.desinationControllerStr = desinationControllerStr;
    return self;
}

- (instancetype)initWithDesinationController:(NSString *)desinationControllerStr selectedIndex:(NSUInteger)index {
    self = [super init];
    self.desinationControllerStr = desinationControllerStr;
    self.selectedIndex = index;
    return self;
}

+ (instancetype)loginViewControllerWithDesinationController:(NSString *)desinationControllerStr {
    ABLoginViewController *loginViewController = [[ABLoginViewController alloc] initWithDesinationController:desinationControllerStr];
    return loginViewController;
}

+ (instancetype)loginViewControllerWithDesinationController:(NSString *)desinationControllerStr selectedIndex:(NSUInteger)index {
    ABLoginViewController *loginViewController = [[ABLoginViewController alloc] initWithDesinationController:desinationControllerStr selectedIndex:index];
    return loginViewController;
}

+ (instancetype)loginViewControllerWithDesinationViewController:(UIViewController *)desinationViewController {
    ABLoginViewController *loginViewController = [[ABLoginViewController alloc] init];
    loginViewController.desinationController = desinationViewController;
    return loginViewController;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KGrayGroundColor;
    
    // 1. 设置导航栏
    [self setNavigationBarItem:@"登录" leftButtonIcon:@"返回"];
    [self.leftButton removeTarget:self action:@selector(clickLeftNavButton) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(backToUpView) forControlEvents:UIControlEventTouchUpInside];
    // 设置界面
    [self setupUI];
    
    // 点击当前VIEW退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    [self.view addGestureRecognizer:tap];
    
    // 手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
        
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置导航栏字体白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // 添加监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isAutoLogin) {
        [self login];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.identifyingCodeTextField) {
        if (range.location >= 3){
            if (range.location == 3) {
                return true;
            }
            return false;
        }
    }
    
    if (textField == self.passworkTextField) {
        if (range.location >= 15){
            if (range.location == 15) {
                return true;
            }
            return false;
        }
    }
    return true;
}

#pragma mark - ABRegisterViewDelegate
- (void)autoLoginRegisterView:(ABRegisterView *)registerView dictionary:(NSDictionary *)dict {
    self.accountTextField.text = dict[@"account"];
    self.passworkTextField.text = dict[@"password"];
    self.isAutoLogin = YES;
}

/// 监听键盘删除按钮 - 当点击删除的时候，如果是空格，删除到空格前一个数字
- (void)deleteSpace:(NSInteger)index {
    
    // 取得 文本框 最后一个字符
    unichar lastChar = [self.accountTextField.text characterAtIndex:index];
    // 转换为 NSString 类型
    NSString *lastString = [NSString stringWithFormat:@"%c",lastChar];
    if([@" " isEqualToString:lastString]) {
        self.accountTextField.text = [self.accountTextField.text substringToIndex:index];
    }
}

#pragma mark - 登录按钮状态
- (void)changeLoginButtonState {
    // ‘验证码输入框’是否隐藏
    if (!self.identifyingCodeTextField.hidden) {
        // 未隐藏 - 账号、密码、验证码都有内容，注册按钮可用
        if (self.accountTextField.text.length > 0 && self.passworkTextField.text.length > 0 && self.identifyingCodeTextField.text.length > 0) {
            self.loginButton.enabled = YES;
            self.loginButton.userInteractionEnabled = YES;
            self.loginButton.backgroundColor = KColorBlue;
        } else {
            self.loginButton.enabled = NO;
            self.loginButton.backgroundColor = KDisableColor;
        }
    } else {// 隐藏 - 账号、密码都有内容，注册按钮可用
        if (self.accountTextField.text.length > 0 && self.passworkTextField.text.length > 0) {
            self.loginButton.enabled = YES;
            self.loginButton.userInteractionEnabled = YES;
            self.loginButton.backgroundColor = KColorBlue;
        } else {
            self.loginButton.enabled = NO;
            self.loginButton.backgroundColor = KDisableColor;
        }
    }
}

#pragma mark - UI设置
- (void)setupUI {
    
    // 1. 添加控件
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.logoImageView];
    [self.scrollView addSubview:self.accountTextField];
    [self.scrollView addSubview:self.passworkTextField];
    [self.scrollView addSubview:self.passwordRightButton];
    [self.scrollView addSubview:self.identifyingCodeTextField];
    [self.scrollView addSubview:self.identifyingCodeButton];
    [self.scrollView addSubview:self.loginButton];
    [self.scrollView addSubview:self.registerButton];
    [self.scrollView addSubview:self.forgotPasswordButton];
    [self.scrollView addSubview:self.servesCallView];
    
    // 2. 布局
    // 2.1 logoView
    self.logoImageView.width = SIZE_LOGO;
    self.logoImageView.height = SIZE_LOGO;
    self.logoImageView.y = PADDING_LOGOVIEW_TOP;
    self.logoImageView.centerX = self.view.centerX;
    
    // 2.2 账号TextField
    self.accountTextField.width = ScreenWidth - PADDING_30PX * 2;
    self.accountTextField.height = SIZE_HEIGHT_TEXTFILED;
    self.accountTextField.y = self.logoImageView.bottom + PADDING_TOP_accountTextField;
    self.accountTextField.centerX = self.view.centerX;
    
    // 2.3 密码TextField
    self.passworkTextField.width = ScreenWidth - PADDING_30PX * 6;
    self.passworkTextField.height = SIZE_HEIGHT_TEXTFILED;
    self.passworkTextField.y = self.accountTextField.bottom;
    self.passworkTextField.x = PADDING_30PX;
    
    // 2.3.1 显示密码按钮
    self.passwordRightButton.height = SIZE_HEIGHT_TEXTFILED;    // 扩大点击范围
    self.passwordRightButton.width = SIZE_HEIGHT_TEXTFILED;     // 扩大点击范围
    self.passwordRightButton.centerY = self.passworkTextField.centerY;
    self.passwordRightButton.right = ScreenWidth - PADDING_30PX;
    
    // 2.4输入验证码框
    self.identifyingCodeTextField.width = ScreenWidth - PADDING_30PX * 2 - 100;
    self.identifyingCodeTextField.height = SIZE_HEIGHT_TEXTFILED;
    self.identifyingCodeTextField.y = self.passworkTextField.bottom;
    self.identifyingCodeTextField.x = PADDING_30PX;
    
    // 2.5 分割线
    [self.scrollView addSubview:self.sep1];
    self.sep1.bottom = self.accountTextField.bottom;
    self.sep1.centerX = self.view.centerX;
    
    [self.scrollView addSubview:self.sep2];
    self.sep2.bottom = self.passworkTextField.bottom;
    self.sep2.centerX = self.view.centerX;
    
    [self.scrollView addSubview:self.sep3];
    self.sep3.bottom = self.identifyingCodeTextField.bottom;
    self.sep3.centerX = self.view.centerX;
    
    // 2.6 验证码图片
    self.identifyingCodeButton.x = ScreenWidth - PADDING_30PX - self.identifyingCodeButton.width;
    self.identifyingCodeButton.y = self.identifyingCodeTextField.y + PADDING_IDENTIFYINGCODEIMAGEVIEW_TOP;
    
    // 2.7 登录按钮
    
    self.loginButton.width = ScreenWidth - 2 * PADDING_30PX;
    self.loginButton.height = HEIGHT_LOGIN_AND_RIGISTER_BUTTON_IPHONE6;
    self.loginButton.x = PADDING_30PX;
    self.loginButton.y = self.passworkTextField.bottom + PADDING_LOGINBUTTON_TOP;
    
    // 2.8 立即注册、忘记密码  - 效果图是文字距离按钮的间距，而文字后面的视图比文字高度高，修正值为6
    self.registerButton.y = self.loginButton.bottom + PADDING_RIGISTERBUTTON_TOP - 6;
    self.registerButton.x = PADDING_RIGISTERBUTTON_LEFT;
    
    self.forgotPasswordButton.y = self.loginButton.bottom + PADDING_RIGISTERBUTTON_TOP - 6;
    self.forgotPasswordButton.x = ScreenWidth - PADDING_RIGISTERBUTTON_LEFT - self.forgotPasswordButton.width;
    
    // 2.9 客服视图
    self.servesCallView.y = self.scrollView.height - PADDING_SERVESCALL_BOTTOM - self.servesCallView.height + 6;    // +6是因为servesCallView里面的子视图距离顶部有6的距离
    self.servesCallView.centerX = self.view.centerX;
    
}

#pragma mark - 键盘监听
- (void)keyboardWasShown:(NSNotification*)aNotification {
    // 获取当前界面的第一响应对象
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    // 键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    ABLog(@"keyboardWasShown:%@",NSStringFromCGRect(keyBoardFrame));
    
    // 1. 转换坐标 - 当前响应的textField -> Window
    CGRect newFrameFirstResponder = [firstResponder.superview convertRect:firstResponder.frame toView:[[UIApplication sharedApplication] keyWindow]];
    
    // 如果键盘盖过了当前输入框,滚动scrollView
    if (newFrameFirstResponder.origin.y + newFrameFirstResponder.size.height > keyBoardFrame.origin.y) {
        CGFloat offsetY = newFrameFirstResponder.origin.y + newFrameFirstResponder.size.height - keyBoardFrame.origin.y;
        CGFloat contentOffsetY = self.scrollView.contentOffset.y + offsetY;
        self.contentOffsetY = contentOffsetY;
        [self.scrollView setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.scrollView.contentOffset.y < contentOffsetY) {
                ABLog(@"2");
                [self.scrollView setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
                ABLog(@"keyboardWasShown:self.scrollView.contentOffset:%@",NSStringFromCGPoint(self.scrollView.contentOffset));
            }
        });
    }
}

// 设置scrllView滚回回原处
-(void)keyboardWillBeHidden:(NSNotification*)aNotification {
    ABLog(@"keyboardWillBeHidden:self.scrollView.contentOffset:%@",NSStringFromCGPoint(self.scrollView.contentOffset));
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

#pragma mark - 隐藏键盘
- (void)keyboardHide {
    
    // 获取当前界面的第一响应对象
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    // 取消注册
    [firstResponder resignFirstResponder];
}

#pragma mark - 获取验证码图片
- (void)getCodeImage {
    
    [KABNetworkManager POST:@"common/captcha/v1.0.1/getImage" parameters:nil success:^(id responseObject) {
        if ([@"200" isEqualToString:responseObject[@"errcode"]]) {
             NSURL *url = [[NSURL alloc] initWithString:responseObject[@"imageurl"]];
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                ABLog(@"下载进度%lf",(CGFloat)receivedSize / expectedSize);
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [self.identifyingCodeButton setBackgroundImage:image forState:UIControlStateNormal];
            }];
        }
    } failure:^(id object) {
        ABLog(@"object:%@",object);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        } else {
            [CustomToast showDialog:@"获取验证码失败，请点击重试" time:1.5];
        }
        
    }];
}

#pragma mark - 自动登录
-(void)autoLogin:(NSNotification*)aNotification {
    ABLog(@"自动登录");
    
    NSDictionary *dict = aNotification.object;
    if (dict) {
        if (dict[@"account"] && dict[@"password"]) {
            self.accountTextField.text = dict[@"account"];
            self.passworkTextField.text = dict[@"password"];
            
            [self login];
        }
    }
}

#pragma mark - 登录事件
- (void)login {
    
    // 接口url
    NSString *urlStr = @"customer/v1.0.1/login";
    
    // 1. 获取参数
    NSString *account = self.accountTextField.text;
    NSString *identifyingCode = self.identifyingCodeTextField.text;
    NSDictionary *dict = nil;
    
    // 判断是否需要传入验证码
    if (!self.identifyingCodeTextField.hidden) {
        dict = [NSDictionary dictionaryWithObjects:@[account,self.passworkTextField.text,identifyingCode] forKeys:@[@"account", @"password",@"code"]];
    } else {
        dict = [NSDictionary dictionaryWithObjects:@[account,self.passworkTextField.text] forKeys:@[@"account", @"password"]];
    }
    
    // 请求接口
    __weak __typeof(self)weakSelf = self;
    [CustomToast showWatingInView:self.view];
    [KABNetworkManager POST:urlStr parameters:dict success:^(id responseObject) {
        [CustomToast hideWatingInView:self.view];
        NSString *uid = responseObject[@"uid"]; // uid
        NSString *sessionID = responseObject[@"sessionid"]; // sessionid
        
        // 密码输入三次错误，需要显示验证码、清除密码输入框
        if ([@"50000" isEqualToString:responseObject[@"errcode"]]) {
            [CustomToast showDialog:responseObject[@"errmsg"] time:1.5];
            // 清空密码输入栏
            weakSelf.passworkTextField.text = @"";
            if (weakSelf.identifyingCodeTextField.hidden == NO) {
                [self getCodeImage];
                weakSelf.identifyingCodeTextField.text = @"";
            }
            [self changeLoginButtonState];
            return ;
        } else if ([@"40005" isEqualToString:responseObject[@"errcode"]]) {
            [CustomToast showDialog:responseObject[@"errmsg"] time:1.5];
            
            // 请求验证码图片
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getCodeImage];
                weakSelf.identifyingCodeTextField.hidden = NO;
                weakSelf.identifyingCodeButton.hidden = NO;
                weakSelf.identifyingCodeTextField.text = @"";
                [weakSelf updateUI];
                [self changeLoginButtonState];
                return ;
            });
        } else if([@"200" isEqualToString:responseObject[@"errcode"]]) { // 登录成功
            // 用户手机号
            NSString *mobile = responseObject[@"mobile"];
            // 客户类型：0-临时客户；1-长期协议客户
            NSString *userType = responseObject[@"type"];
            
            // uid保存到用户偏好设置中,用于判断是否登录成功
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] setObject:userType forKey:@"userType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 保存 uid 和 sessionID
            KABNetworkDelegate.stringUserID = uid;
            KABNetworkDelegate.stringSID = sessionID;
            // 隐藏验证码输入栏
            weakSelf.identifyingCodeTextField.hidden = YES;
            weakSelf.identifyingCodeButton.hidden = YES;
            
            // 获取用户上次订单的快照
            [KABNetworkManager getLastSnapshot];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINSUCCESS object:nil];
            
            // 则跳转到登录之前的界面
            [self.navigationController popViewControllerAnimated:YES];
            [CustomToast showDialog:@"登录成功" time:1.5];
            
        } else {
            [CustomToast showDialog:responseObject[@"errmsg"] time:1.5];
        }
        [weakSelf updateUI];
    } failure:^(id object) {
        [CustomToast hideWatingInView:self.view];
        ABLog(@"%@",object);
        // 网络不可用或者请求超时都显示网络异常
        [CustomToast showNetworkError];
        return ;
    }];
}

#pragma mark - 更新密码
- (void)updateUI {
    __weak __typeof(self)weakSelf = self;
    if (weakSelf.identifyingCodeTextField.hidden) {
        
        weakSelf.loginButton.y = self.passworkTextField.bottom + PADDING_LOGINBUTTON_TOP;
        weakSelf.sep3.hidden = YES;
        [weakSelf changeLoginButtonState];
    } else {
        
        self.loginButton.y = self.identifyingCodeTextField.bottom + PADDING_LOGINBUTTON_TOP;
        self.sep3.hidden = NO;
        [weakSelf changeLoginButtonState];
    }
    
    // 更新位置 - ‘立即注册’、‘忘记密码’按钮
    weakSelf.registerButton.y = self.loginButton.bottom + PADDING_RIGISTERBUTTON_TOP;
    weakSelf.registerButton.x = PADDING_RIGISTERBUTTON_LEFT;
    
    weakSelf.forgotPasswordButton.y = self.loginButton.bottom + PADDING_RIGISTERBUTTON_TOP;
    weakSelf.forgotPasswordButton.x = ScreenWidth - PADDING_RIGISTERBUTTON_LEFT - self.forgotPasswordButton.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 跳转注册
- (void)jumoToRegisterVC {
    ABRegisterViewController *vc = [[ABRegisterViewController alloc] init];
    vc.registerView.registerViewDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 找回密码
- (void)retrievePassword {
    ABRetrievePasswordViewController *vc = [[ABRetrievePasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 密码显示样式改变
- (void)changePassWordShowStyle {
    _passworkTextField.secureTextEntry = !_passworkTextField.secureTextEntry;
    NSString* text = _passworkTextField.text;
    _passworkTextField.text = @" ";
    _passworkTextField.text = text;
    if (_passworkTextField.secureTextEntry) {
        [self.passwordRightButton setImage:[UIImage imageNamed:@"注册-隐藏密码"] forState:UIControlStateNormal];
    } else {
        [self.passwordRightButton setImage:[UIImage imageNamed:@"注册-显示密码"] forState:UIControlStateNormal];
    }
}

#pragma mark - 导航栏返回
- (void)backToUpView {
    if ([@"ABOrderViewController" isEqualToString:self.desinationControllerStr]) {
        self.tabBarController.selectedIndex = self.selectedIndex;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
}


#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, ScreenWidth, ScreenHeight - self.navigationBar.height)];
    }
    return _scrollView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"闪服-用户logo180x180"];
        _logoImageView.layer.cornerRadius = 5;
        _logoImageView.clipsToBounds = YES;
        _logoImageView.backgroundColor = KColorBlue;
    }
    return _logoImageView;
}

- (HFHTextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入您的手机号或邮箱" placeHolderSize:PADDING_30PX placeHolderPadding:PADDING_30PX * 2 leftViewImageName:@"注册-phone"];
        [_accountTextField setValue:KColorTextPlaceHold forKeyPath:@"_placeholderLabel.textColor"];
        _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountTextField.delegate = self;
        [_accountTextField addTarget:self action:@selector(changeLoginButtonState) forControlEvents:UIControlEventEditingChanged];
    }
    return _accountTextField;
}

- (HFHTextField *)passworkTextField {
    if (!_passworkTextField) {        
        _passworkTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入您的密码" placeHolderSize:PADDING_30PX placeHolderPadding:PADDING_30PX * 2 leftViewImageName:@"注册-lock"];
        [_passworkTextField setValue:KColorTextPlaceHold forKeyPath:@"_placeholderLabel.textColor"];
        _passworkTextField.secureTextEntry = YES;   // 默认为非明文
        _passworkTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passworkTextField.delegate = self;
        [_passworkTextField addTarget:self action:@selector(changeLoginButtonState) forControlEvents:UIControlEventEditingChanged];
    }
    return _passworkTextField;
}

- (UIButton *)passwordRightButton {
    if (!_passwordRightButton) {
        _passwordRightButton = [UIButton buttonWithTitle:nil color:nil fontSize:0 imageName:@"注册-隐藏密码"];
        [_passwordRightButton addTarget:self action:@selector(changePassWordShowStyle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordRightButton;
}

- (HFHTextField *)identifyingCodeTextField {
    if (!_identifyingCodeTextField) {
        _identifyingCodeTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入验证码" placeHolderSize:PADDING_30PX placeHolderPadding:PADDING_30PX leftViewImageName:nil];
        [_identifyingCodeTextField setValue:KColorTextPlaceHold forKeyPath:@"_placeholderLabel.textColor"];
        _identifyingCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _identifyingCodeTextField.delegate = self;
        _identifyingCodeTextField.hidden = YES;        
        [_identifyingCodeTextField addTarget:self action:@selector(changeLoginButtonState) forControlEvents:UIControlEventEditingChanged];
    }
    return _identifyingCodeTextField;
}

- (UIButton *)identifyingCodeButton {
    if (!_identifyingCodeButton) {
        _identifyingCodeButton = [[UIButton alloc] init];
        _identifyingCodeButton.height = SIZE_HEIGHT_TEXTFILED - 2 * PADDING_IDENTIFYINGCODEIMAGEVIEW_TOP;
        _identifyingCodeButton.width = SIZE_WIDTH_IDENTIFYINGCODEIMAGEVIEW;
        _identifyingCodeButton.hidden = YES;
        [_identifyingCodeButton addTarget:self action:@selector(getCodeImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _identifyingCodeButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithTitle:@"登录" color:KWhiteColor fontSize:FONT_SIZE_BASCICBUTTON imageName:nil];
        _loginButton.backgroundColor = KDisableColor;
        [_loginButton.layer setCornerRadius:5];
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.enabled = NO;
    }
    return _loginButton;
}

- (UIView *)sep1 {
    if (!_sep1) {
        _sep1 = [[UIView alloc] init];
        _sep1.backgroundColor = KColorSep;
        _sep1.width = ScreenWidth - 2 * PADDING_30PX;
        _sep1.height = 1;
    }
    return _sep1;
}

- (UIView *)sep2 {
    if (!_sep2) {
        _sep2 = [[UIView alloc] init];
        _sep2.backgroundColor = KColorSep;
        _sep2.width = ScreenWidth - 2 * PADDING_30PX;
        _sep2.height = 1;
    }
    return _sep2;
}

- (UIView *)sep3 {
    if (!_sep3) {
        _sep3 = [[UIView alloc] init];
        _sep3.backgroundColor = KColorSep;
        _sep3.width = ScreenWidth - 2 * PADDING_30PX;
        _sep3.height = 1;
        _sep3.hidden = YES;
    }
    return _sep3;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithTitle:@"立即注册" color:KColorBlue fontSize:PADDING_28PX imageName:nil];
        [_registerButton addTarget:self action:@selector(jumoToRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)forgotPasswordButton {
    if (!_forgotPasswordButton) {
        _forgotPasswordButton = [UIButton buttonWithTitle:@"忘记密码？" color:KColorBlue fontSize:PADDING_28PX imageName:nil];
        [_forgotPasswordButton addTarget:self action:@selector(retrievePassword) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPasswordButton;
}

- (ABServesCallView *)servesCallView {
    if (!_servesCallView) {
        _servesCallView = [[ABServesCallView alloc] init];
    }
    return _servesCallView;
}

@end
