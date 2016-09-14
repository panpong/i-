//
//  ABRegisterView.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABRegisterView.h"
#import "HFHTextField.h"
#import "ABServesCallView.h"
#import "UIView+Extention.h"
#import "UIButton+Extention.h"
#import "ABNetworkManager.h"
#import "CustomToast.h"
#import "ABLoginViewController.h"
#import "CCWebViewController.h"
#import "HFHWebViewController.h"

#define PADDING_IDENTIFYINGCODEIMAGEVIEW_TOP 8 // 验证码图片距离输入框顶部距离
#define SIZE_WIDTH_IDENTIFYINGCODEIMAGEVIEW 70 // 验证码图片宽度
#define PADDING_REGISTERBUTTON_TOP 20 // ‘注册’按钮距离上一个控件的距离
#define PADDING_RIGISTERBUTTON_LEFT 15 // ‘注册’按钮距离‘屏幕’左边距离
#define TIME_MAX 59   // 倒计时上限
#define TIME_MIN 1   // 倒计时下限
#define SIZE_WIDTH_GETCODE 85   // ‘获取验证码’按钮宽度
#define PADDING_SERVESCALL_BOTTOM 19   // ‘客服视图’距离底部距离
#define PADDING_DESCLABEL_TOP 11   // ‘协议描述’距‘注册按钮’底部距离

@interface ABRegisterView()<UITextFieldDelegate>

{
    BOOL isIdentifyingCodeValidate; // 验证码是否已输入4位
}

@property(nonatomic,strong) HFHTextField *accountTextField; // 账号输入框
@property(nonatomic,strong) HFHTextField *passworkTextField;    // 密码输入框
@property(nonatomic,strong) HFHTextField *identifyingCodeTextField; // 验证码输入框
@property(nonatomic,strong) HFHTextField *invitingCodeTextFied; //邀请码输入框
@property(nonatomic,strong) UIButton *getCodeButton;    // 获取验证码按钮
@property(nonatomic,strong) UIButton *registerButton;   // 注册按钮
@property(nonatomic,strong) UIView *sep1;   // 分割线1
@property(nonatomic,strong) UIView *sep2;   // 分割线2
@property(nonatomic,strong) UIView *sep3;   // 分割线3
@property(nonatomic,strong) UIView *sep4;   // 分割线4
@property(nonatomic,strong) ABServesCallView *servesCallView;   // 客服视图
@property(nonatomic,strong) UIButton *passwordRightButton;  // 密码输入框的右视图按钮
@property(nonatomic,strong) UIButton *agreementButton;  // 用户协议按钮
@property(nonatomic,strong) UILabel *descLabel; // 协议描述标签

@end

@implementation ABRegisterView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //    NSLog(@"%@--%zd",textField,range.location);
        
    if (textField == self.accountTextField) {
        // 1. 当长度达到11(1xxyyyyzzzz)时，取消输入
        if (range.location >= 10){
            if (range.location == 10) {
                return true;
            } else {
                return false;
            }
        }
    }
    if (textField == self.invitingCodeTextFied) {
        if (range.location >= 7) {
            if (range.location == 7) {
                return true;
            }else {
                return false;
            }
        }
    }
    
    if (textField == self.identifyingCodeTextField) {
        if (range.location >= 3){
            if (range.location == 3) {
                isIdentifyingCodeValidate = YES;
                [self changeRegisterButtonState];
                return true;
            }
            isIdentifyingCodeValidate = YES;
            [self changeRegisterButtonState];
            return false;
        } else {
            isIdentifyingCodeValidate = NO;
        }
    }
    
    if (textField == self.passworkTextField) {
        if (range.location >= 15){
            if (range.location == 15) {
                [self changeRegisterButtonState];
                return true;
            }
            [self changeRegisterButtonState];
            return false;
        }
    }
    return true;
}

#pragma mark - UI设置
- (void)setupUI {
    self.backgroundColor = KGrayGroundColor;
    // 1. 添加控件
    [self addSubview:self.accountTextField];
    [self addSubview:self.passworkTextField];
    [self addSubview:self.passwordRightButton];
    [self addSubview:self.identifyingCodeTextField];
    [self addSubview:self.registerButton];
    [self addSubview:self.getCodeButton];
    [self addSubview:self.servesCallView];
    [self addSubview:self.descLabel];
    [self addSubview:self.agreementButton];
    [self addSubview:self.invitingCodeTextFied];
    
    // 2. 布局
    // 2.1 账号TextField
    self.accountTextField.width = ScreenWidth - PADDING_30PX * 2;
    self.accountTextField.height = SIZE_HEIGHT_TEXTFILED;
    self.accountTextField.y = 0;
    self.accountTextField.centerX = ScreenWidth / 2;
    
    // 2.2输入验证码框
    self.identifyingCodeTextField.width = ScreenWidth - PADDING_30PX * 2 - 100;
    self.identifyingCodeTextField.height = SIZE_HEIGHT_TEXTFILED;
    self.identifyingCodeTextField.y = self.accountTextField.bottom;
    self.identifyingCodeTextField.x = PADDING_30PX;
    
    // 2.3 密码TextField
    self.passworkTextField.width = ScreenWidth - PADDING_30PX * 6;
    self.passworkTextField.height = SIZE_HEIGHT_TEXTFILED;
    self.passworkTextField.y = self.identifyingCodeTextField.bottom;
    self.passworkTextField.x = PADDING_30PX;
    
    // 2.3.1 显示密码按钮
    self.passwordRightButton.height = SIZE_HEIGHT_TEXTFILED;    // 扩大点击范围
    self.passwordRightButton.width = SIZE_HEIGHT_TEXTFILED;
    self.passwordRightButton.centerY = self.passworkTextField.centerY;
    self.passwordRightButton.right = ScreenWidth - PADDING_30PX;
    
    // 2.3.2 邀请码输入框
    self.invitingCodeTextFied.width = ScreenWidth - PADDING_30PX * 6;
    self.invitingCodeTextFied.height = SIZE_HEIGHT_TEXTFILED;
    self.invitingCodeTextFied.y = self.passworkTextField.bottom;
    self.invitingCodeTextFied.x = PADDING_30PX;
    
    // 2.4 注册按钮
    self.registerButton.width = ScreenWidth - 2 * PADDING_RIGISTERBUTTON_LEFT;
    self.registerButton.height = SIZE_HEIGHT_TEXTFILED;
    self.registerButton.y = self.invitingCodeTextFied.bottom + PADDING_REGISTERBUTTON_TOP;
    self.registerButton.centerX = ScreenWidth / 2;
    
    // 2.5 分割线
    [self addSubview:self.sep1];
    self.sep1.bottom = self.accountTextField.bottom;
    self.sep1.centerX = ScreenWidth / 2;
    
    [self addSubview:self.sep2];
    self.sep2.bottom = self.identifyingCodeTextField.bottom;
    self.sep2.centerX = ScreenWidth / 2;
    
    [self addSubview:self.sep3];
    self.sep3.bottom = self.passworkTextField.bottom;
    self.sep3.centerX = ScreenWidth / 2;
    
    [self addSubview:self.sep4];
    self.sep4.bottom = self.invitingCodeTextFied.bottom;
    self.sep4.centerX = ScreenWidth / 2;
    
    // 2.6 获取验证码按钮
    self.getCodeButton.width = SIZE_WIDTH_GETCODE;
    self.getCodeButton.height = SIZE_HEIGHT_TEXTFILED - 2 * 8;
    self.getCodeButton.y = self.identifyingCodeTextField.y + 8;
    self.getCodeButton.x = ScreenWidth - self.getCodeButton.width - PADDING_30PX;
    
    // 2.7 客服视图
    self.servesCallView.y = self.height - PADDING_SERVESCALL_BOTTOM - self.servesCallView.height + 6;    // +6是因为servesCallView里面的子视图距离顶部有6的距离
    self.servesCallView.centerX = ScreenWidth / 2;
    
    // 2.8 文字描述
    self.descLabel.y = self.registerButton.bottom + PADDING_DESCLABEL_TOP;
    self.descLabel.centerX = ScreenWidth / 2 - self.agreementButton.width / 2;
    
    self.agreementButton.x = self.descLabel.right + 2;
    self.agreementButton.centerY = self.descLabel.centerY;
}

#pragma mark - 注册事件
- (void)registerButtonClick {
    
    if (![self isMobile:self.accountTextField.text]) {
        [CustomToast showDialog:@"请输入正确的手机号" time:1.5];
        return;
    }
    if (![self isPassword:self.passworkTextField.text]) {
        [CustomToast showDialog:@"密码为6-16字符，包括英文、数字、符号组合" time:1.5];
        return;
    }
    NSString *urlStr = @"customer/v1.0.1/register";
    
    // 接口参数
    NSString *phone = self.accountTextField.text;
    NSString *password = self.passworkTextField.text;
    NSString *code = self.identifyingCodeTextField.text;
    NSString *invitingCode = self.invitingCodeTextFied.text;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[phone,password,code,invitingCode] forKeys:@[@"phone",@"password",@"code",@"promo_code"]];
    
    if (self.superview) {
        [CustomToast showWatingInView:self.superview];
    } else {
        [CustomToast showWatingInView:self];
    }
    
    [KABNetworkManager POST:urlStr parameters:dict success:^(id responseObject) {
        if (self.superview) {
            [CustomToast hideWatingInView:self.superview];
        } else {
            [CustomToast hideWatingInView:self];
        }
        if([@"200" isEqualToString:responseObject[@"errcode"]]){
            
            if ([self.registerViewDelegate respondsToSelector:@selector(autoLoginRegisterView:dictionary:)]) {
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[_accountTextField.text,_passworkTextField.text] forKeys:@[@"account",@"password"]];                
                [self.registerViewDelegate autoLoginRegisterView:self dictionary:dict];
            }
            
            [self.viewController.navigationController popViewControllerAnimated:YES];
            [CustomToast showDialog:@"注册成功" time:1.5];
            return;
        } else if([@"40005" isEqualToString:responseObject[@"errcode"]]) {
            [CustomToast showDialog:responseObject[@"errmsg"] time:1.5];
            // 清空验证码输入栏
            self.identifyingCodeTextField.text = @"";
            [self changeRegisterButtonState];
        } else { // 其他错误信息则正常显示
            [CustomToast showDialog:responseObject[@"errmsg"] time:1.5];
        }
    } failure:^(id object) {
        if (self.superview) {
            [CustomToast hideWatingInView:self.superview];
        } else {
            [CustomToast hideWatingInView:self];
        }
        ABLog(@"%@",object);
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        } else {
            [CustomToast showDialog:@"注册失败" time:1.5];
        }
        return ;
    }];
}

#pragma mark - 验证码点击事件
- (void)getCodeButtonDidClick {
    // 先判断手机号码是否为空或者合法
    if ([@"" isEqualToString:self.accountTextField.text]) {
        [CustomToast showDialog:@"请输入手机号" time:1.5];
        return;
    }else if (![self isMobile:self.accountTextField.text]) {
        [CustomToast showDialog:@"请输入正确的手机号" time:1.5];
        return;
    } else {
        // 参数处理 - 号码去空格
        NSString *phoneNum = [self.accountTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:phoneNum forKey:@"phone"];
        // 调用接口获取验证码
        NSString *url = @"customer/captcha/v1.0.1/sendSms";
        
        if (self.superview) {
            [CustomToast showWatingInView:self.superview];
        } else {
            [CustomToast showWatingInView:self];
        }
        [KABNetworkManager POST:url parameters:dict success:^(id responseObject) {
            if (self.superview) {
                [CustomToast hideWatingInView:self.superview];
            } else {
                [CustomToast hideWatingInView:self];
            }
            
            if ([@"200" isEqualToString:responseObject[@"errcode"]]) {
                [CustomToast showDialog:@"验证码已发送，请查收" time:1.5];
                
                // 验证码发送后显示倒计时
                [self countDown];
                // 背景色置灰色
                [self.getCodeButton.layer setBorderColor:CPColor(200, 200, 200).CGColor];
                [self.getCodeButton setTitleColor:CPColor(200, 200, 200) forState:UIControlStateNormal];
                [self.getCodeButton setBackgroundColor:CPColor(248, 248, 248)];
            } else if([@"50000" isEqualToString:responseObject[@"errcode"]]){
                [CustomToast showDialog:responseObject[@"errmsg"] time:1.5];
                return ;
            }            
        } failure:^(id object) {
            if (self.superview) {
                [CustomToast hideWatingInView:self.superview];
            } else {
                [CustomToast hideWatingInView:self];
            }
            ABLog(@"%@",object);
            if (isDisConnectedNetwork) {
                [CustomToast showNetworkError];
            } else {
                [CustomToast showDialog:@"验证码发送失败" time:1.5];
            }
            return ;
        }];
    }
}

#pragma mark - 正则判断手机号码合法性
- (BOOL)isMobile:(NSString *)mobileNumbel {
    
    NSString *mobileNum = [mobileNumbel stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    /**
     以13、14、15、17、18等我国正常手机号起始位开头的11位数字
     */
    NSString * MOBIL = @"^[1][34578][0-9]{9}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    
    if ([regextestmobile evaluateWithObject:mobileNum]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 倒计时
- (void)countDown {
    __block int timeout = TIME_MAX; // 倒计时时间:59~1秒
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout < TIME_MIN){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeButton setBackgroundColor:[UIColor whiteColor]];
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeButton.layer setBorderColor:KColorBlue.CGColor];
                [self.getCodeButton setTitleColor:KColorBlue forState:UIControlStateNormal];
                [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getCodeButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.getCodeButton setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.getCodeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 密码合法性
- (BOOL)isPassword:(NSString *)passWord {
    
    /**
     6-16字符，包括英文、数字、下划线组合，区分大小写
     */
    NSString *PASSWORD = @"^[A-Za-z0-9!@#$%^&*()_-]{6,16}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORD];
    
    if ([regextestmobile evaluateWithObject:passWord]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 验证码输入监听
- (void)identifyingCodeChanged:(HFHTextField *)field {
    NSInteger count = field.text.length;
    ABLog(@"count:%zd",count);
    switch (count) {
        case 4:
            isIdentifyingCodeValidate = YES;
            break;
        default:
            isIdentifyingCodeValidate = NO;
            [self changeRegisterButtonState];
            break;
    }
}

#pragma mark - 密码显示样式改变
- (void)changePasswordShowStyle {
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

#pragma mark - 改变注册按钮状态
- (void)changeRegisterButtonState {
    BOOL hasMobile = self.accountTextField.text && ![@"" isEqualToString:self.accountTextField.text];
    BOOL hasPsssword = self.passworkTextField.text && ![@"" isEqualToString:self.passworkTextField.text];
    BOOL hasIdentifyingCode = self.identifyingCodeTextField.text && ![@"" isEqualToString:self.identifyingCodeTextField.text];
    
    if (hasMobile && hasPsssword && hasIdentifyingCode) {
        self.registerButton.enabled = YES;
        self.registerButton.userInteractionEnabled = YES;
        self.registerButton.backgroundColor = KColorBlue;
    } else {
        self.registerButton.enabled = NO;
        self.registerButton.backgroundColor = KDisableColor;
    }
}

#pragma mark - 跳转用户协议
- (void)jumpToAgreementVC {
    
   
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[ABNetworkDelegate serverHtml5URL],@"/files/userAgreement.html"];
    
    self.viewController.navigationController.navigationBar.hidden = YES;
//    [CCWebViewController showWithContro:self.viewController withUrlStr:urlStr withTitle:@"用户协议"];
    
//    self.navigationController.navigationBar.hidden = YES;
    [HFHWebViewController showWithController:self.viewController withUrlStr:urlStr withTitle:@"用户协议" hidesBottomBarWhenPushed:YES];
    
}

#pragma mark - 懒加载
- (HFHTextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入手机号" placeHolderSize:PADDING_30PX placeHolderPadding:PADDING_30PX * 2 leftViewImageName:@"注册-phone"];
        [_accountTextField setValue:KColorTextPlaceHold forKeyPath:@"_placeholderLabel.textColor"];
        _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_accountTextField addTarget:self action:@selector(changeRegisterButtonState) forControlEvents:UIControlEventEditingChanged];
        _accountTextField.keyboardType = UIKeyboardTypeNumberPad;
        _accountTextField.delegate = self;
    }
    return _accountTextField;
}

- (HFHTextField *)identifyingCodeTextField {
    if (!_identifyingCodeTextField) {
        _identifyingCodeTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入验证码" placeHolderSize:PADDING_30PX placeHolderPadding:0 leftViewImageName:nil];
        [_identifyingCodeTextField setValue:KColorTextPlaceHold forKeyPath:@"_placeholderLabel.textColor"];
        _identifyingCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _identifyingCodeTextField.delegate = self;
        _identifyingCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_identifyingCodeTextField addTarget:self action:@selector(identifyingCodeChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _identifyingCodeTextField;
}

- (HFHTextField *)passworkTextField {
    if (!_passworkTextField) {
        _passworkTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入6-16字符" placeHolderSize:PADDING_30PX placeHolderPadding:PADDING_30PX * 2 leftViewImageName:@"注册-lock"];
        [_passworkTextField setValue:KColorTextPlaceHold forKeyPath:@"_placeholderLabel.textColor"];
        _passworkTextField.secureTextEntry = YES;   // 默认‘非明文’
        _passworkTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passworkTextField.delegate = self;
        [_passworkTextField addTarget:self action:@selector(changeRegisterButtonState) forControlEvents:UIControlEventEditingChanged];
    }
    return _passworkTextField;
}


- (HFHTextField *)invitingCodeTextFied
{
    if (!_invitingCodeTextFied) {
        _invitingCodeTextFied = [HFHTextField textFieldWithPlaceHolder:@"请输入邀请码（选填）" placeHolderSize:PADDING_30PX placeHolderPadding:0 leftViewImageName:nil];
        [_invitingCodeTextFied setValue:KColorTextPlaceHold forKeyPath:@"_placeholderLabel.textColor"];
        _invitingCodeTextFied.clearButtonMode = UITextFieldViewModeWhileEditing;
        _invitingCodeTextFied.delegate = self;
//        _invitingCodeTextFied.keyboardType = UIKeyboardTypeNumberPad;
//        [_invitingCodeTextFied addTarget:self action:@selector(identifyingCodeChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _invitingCodeTextFied;
}

- (UIButton *)passwordRightButton {
    if (!_passwordRightButton) {
        _passwordRightButton = [UIButton buttonWithTitle:nil color:nil fontSize:0 imageName:@"注册-隐藏密码"];
        [_passwordRightButton addTarget:self action:@selector(changePasswordShowStyle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordRightButton;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithTitle:@"注册" color:KWhiteColor fontSize:FONT_SIZE_BASCICBUTTON imageName:nil];
        _registerButton.backgroundColor = KDisableColor;
        [_registerButton.layer setCornerRadius:5];
        [_registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.enabled = NO;
        
    }
    return _registerButton;
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
    }
    return _sep3;
}
- (UIView *)sep4 {
    if (!_sep4) {
        _sep4 = [[UIView alloc] init];
        _sep4.backgroundColor = KColorSep;
        _sep4.width = ScreenWidth - 2 * PADDING_30PX;
        _sep4.height = 1;
    }
    return _sep4;
}

- (UIButton *)getCodeButton {
    if (!_getCodeButton) {
        _getCodeButton = [UIButton buttonWithTitle:@"获取验证码" color:KColorBlue fontSize:13 backImageName:nil];
        [_getCodeButton.layer setCornerRadius:3];
        _getCodeButton.layer.borderWidth = 1;  // 必须设置‘边框宽度’ 才能显示出 ‘边框颜色’
        _getCodeButton.layer.borderColor = KColorBlue.CGColor;   // 边框颜色
        [_getCodeButton addTarget:self action:@selector(getCodeButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_getCodeButton sizeToFit];
    }
    return _getCodeButton;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:PADDING_28PX];
        _descLabel.text = @"点击注册即表示您同意";
        _descLabel.textColor = kColorTextGrey;
        [_descLabel sizeToFit];
    }
    return _descLabel;
}

- (UIButton *)agreementButton {
    if (!_agreementButton) {
        _agreementButton = [[UIButton alloc] init];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"用户协议"];
        NSRange strRange = {0,[attrStr length]};
        [attrStr addAttributes:@{NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName : KColorBlue,NSFontAttributeName : [UIFont systemFontOfSize:PADDING_28PX]} range:strRange];
        [_agreementButton setAttributedTitle:attrStr forState:UIControlStateNormal];
        [_agreementButton sizeToFit];
        [_agreementButton addTarget:self action:@selector(jumpToAgreementVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreementButton;
}

- (ABServesCallView *)servesCallView {
    if (!_servesCallView) {
        _servesCallView = [[ABServesCallView alloc] init];
    }
    return _servesCallView;
}


@end
