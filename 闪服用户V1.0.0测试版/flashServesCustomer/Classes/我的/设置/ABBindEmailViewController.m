//
//  ABBindEmailViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABBindEmailViewController.h"
#import "NSString+KYSAddition.h"
#import "UIViewController+CustomNavigationBar.h"
#import "KYSNetwork.h"
#import "CustomToast.h"

@interface ABBindEmailViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end

@implementation ABBindEmailViewController

+ (ABBindEmailViewController *)getBindEmailViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Me" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ABBindEmailViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    NSString *oldEmail=[_dataDic[@"email"] copy];
//    [self setNavigationBarItem:oldEmail.length?@"修改邮箱":@"绑定邮箱" leftButtonIcon:@"返回" rightButtonTitle:nil];
//    _emailTextField.text=oldEmail.length?oldEmail:@"";
    //_emailTextField.placeholder=oldEmail.length?@"修改邮箱":@"绑定邮箱";
    
    [self setNavigationBarItem:@"绑定邮箱" leftButtonIcon:@"返回" rightButtonTitle:nil];
    
    _bottomBtn.layer.cornerRadius=3.0;
    _bottomBtn.layer.masksToBounds=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tap];
    
    [self p_loadCustomerDescription];
}

- (void)tapGesture{
    [_emailTextField resignFirstResponder];
}


- (IBAction)bindAction:(id)sender {
    
    if (!_emailTextField.text.length) {
        //请输入邮箱
        [CustomToast showToastWithInfo:@"请输入邮箱"];
        return;
    }
    
    if (![_emailTextField.text isValidateEmail]) {
        [CustomToast showToastWithInfo:@"邮箱格式错误，请重新输入"];
        return;
    }
    NSLog(@"绑定邮箱");
    [self p_updateEmail:_emailTextField.text];
}

#pragma mark - private
- (void)p_updateEmail:(NSString *)email{
    NSDictionary *dic=@{@"email":email};
    //NSString *oldEmail=[_dataDic[@"email"] copy];
    [KYSNetwork updateEmailWithParameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        //[CustomToast showToastWithInfo:oldEmail.length?@"修改邮箱成功":@"绑定邮箱成功"];
        [CustomToast showToastWithInfo:@"绑定邮箱成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failureBlock:^(id object) {
        NSLog(@"%@",object);
//        if ([object isKindOfClass:[NSDictionary class]]) {
//            //邮箱已绑定其他账号
//            if (50000 == [object[@"errcode"] integerValue]) {
//                return;
//            }
//        }
        if (isConnectingNetwork){
            //[CustomToast showToastWithInfo:oldEmail.length?@"修改邮箱失败":@"绑定邮箱失败"];
            [CustomToast showToastWithInfo:@"绑定邮箱失败"];
        }
    } view:self.view];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length>=100) {
        textField.text=[textField.text substringToIndex:99];
    }
    if (range.location>=100) {
        return NO;
    }
    return YES;
}

#pragma mark - private
//加载我的资料数据
- (void)p_loadCustomerDescription{
    __weak typeof(self) wSelf=self;
    [KYSNetwork getCustomerDescriptionWithParameters:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if (responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            [wSelf p_updateProfileWithDic:responseObject[@"profile"]];
        }
    } failureBlock:^(id object) {
        if (isConnectingNetwork) {
            [CustomToast showToastWithInfo:@"数据加载失败"];
        }
    } view:self.view];
}

- (void)p_updateProfileWithDic:(NSDictionary *)dic{
    _dataDic=dic;
    _emailTextField.text=_dataDic[@"email"];
    //刷新页面数据
}

@end
