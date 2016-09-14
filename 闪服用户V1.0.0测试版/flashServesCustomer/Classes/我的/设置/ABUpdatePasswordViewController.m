//
//  ABUpdatePasswordViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABUpdatePasswordViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "KYSNetwork.h"
#import "CustomToast.h"

@interface ABUpdatePasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *xinPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkXinPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end

@implementation ABUpdatePasswordViewController

+ (ABUpdatePasswordViewController *)getUpdatePasswordViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Me" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ABUpdatePasswordViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBarItem:@"修改密码" leftButtonIcon:@"返回" rightButtonTitle:nil];
    
    _bottomBtn.layer.cornerRadius=3.0;
    _bottomBtn.layer.masksToBounds=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapGesture{
    [_oldPasswordTextField resignFirstResponder];
    [_xinPasswordTextField resignFirstResponder];
    [_checkXinPasswordTextField resignFirstResponder];
}

#pragma mark - Action
- (IBAction)updatePasswordAction:(id)sender {
    NSLog(@"修改密码");
    if ([self p_checkPassword]) {
        //修改密码
        [self p_updatePasswordWithOld:_oldPasswordTextField.text
                                  new:_xinPasswordTextField.text];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //最多输入16位
    if (textField.text.length>=16) {
        textField.text=[textField.text substringToIndex:15];
    }
    if (range.location>=16) {
        return NO;
    }
    return YES;
}

#pragma mark - private
//修改密码
- (void)p_updatePasswordWithOld:(NSString *)oStr new:(NSString *)nStr{
    NSDictionary *dic=@{@"password":oStr,@"newpassword":nStr};
    [KYSNetwork updatePasswordWithParameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [CustomToast showToastWithInfo:@"密码修改成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failureBlock:^(id object) {
        if (isConnectingNetwork){
            [CustomToast showToastWithInfo:@"密码修改失败"];
        }
    } view:self.view];
    
}

//验证密码格式
- (BOOL)p_isPassword:(NSString *)passWord {
    //6-16字符，包括英文、数字、符号组合，区分大小写
    NSString *PASSWORD = @"^[A-Za-z0-9!@#$%^&*()_-]{6,16}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORD];
    if ([regextestmobile evaluateWithObject:passWord]) {
        return YES;
    }
    return NO;
}

- (BOOL)p_checkPassword{
    if (0==_oldPasswordTextField.text.length) {
        [CustomToast showToastWithInfo:@"请输入原密码"];
        return NO;
    }
    if (0==_xinPasswordTextField.text.length) {
        [CustomToast showToastWithInfo:@"请输入新密码"];
        return NO;
    }
    if (0==_checkXinPasswordTextField.text.length) {
        [CustomToast showToastWithInfo:@"请输入确认密码"];
        return NO;
    }
    
    if (![self p_isPassword:_xinPasswordTextField.text]) {
        [CustomToast showToastWithInfo:@"密码格式错误"];
        return NO;
    }
    
    if (![_xinPasswordTextField.text isEqualToString:_checkXinPasswordTextField.text]) {
        [CustomToast showToastWithInfo:@"新密码和确认密码不一致"];
        return NO;
    }
    return YES;
}

@end
