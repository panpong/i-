//
//  ABAdviceViewController.m
//  LoveTourGuide
//
//  Created by 002 on 15/12/18.
//  Copyright © 2015年 fhhe. All rights reserved.
//

#import "ABAdviceViewController.h"
#import "ABAdviceView.h"
#import "Masonry.h"
//#import "ABBusiness.h"
#import "KYSNetwork.h"
#import "MBProgressHUD.h"
#import "CustomToast.h"
#import "UIView+Extention.h"
#import "KYSTextView.h"
#import "HFHTextField.h"
#import "UIViewController+CustomNavigationBar.h"

#define MAX_LIMIT_NUMS 300   // ‘意见反馈框’ 最大输入字数
#define keyboardDidShowY 227    // ‘iPhone4’ 键盘弹出后 ‘键盘’的 ‘y’ 点坐标

//text size for this controller view
#define TEXT_SIZE_30D   15
#define TEXT_SIZE_28D   14

//横向padding
#define PADDING_H 12
#define PADDING_V 12

@interface ABAdviceViewController ()<UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong) KYSTextView *adviceText;    // 意见反馈输入框

@property(nonatomic,strong) UILabel *desc;  // "请留下您的联系方式，感谢您的支持！"

@property(nonatomic,strong) HFHTextField *phoneText; // 手机号输入框

@property(nonatomic,strong) UIScrollView *backView;   // 父控件

@property(nonatomic,assign) NSInteger distance; // 滚动距离

@property(nonatomic,strong) UILabel *wordNumLabel;

@end

@implementation ABAdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ABLog(@"ABAdviceViewController:%@",self.navigationController.navigationBar);
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    
    // 设置导航栏
    [self setNavigationBarItem:@"意见反馈" leftButtonIcon:@"返回" rightButtonTitle:@"提交"];
    
    // 监听右边按钮事件
    [self.rightButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置界面
    [self setupUI];
    // 点击空白处退出键盘
    [self resignKeyboardWhenClickBlankZone];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewValueChange:(NSNotification *)not{
    ABLog(@"%@",not.object);
    if (not.object==self.adviceText) {
        self.wordNumLabel.text=[NSString stringWithFormat:@"%lu/%d",(unsigned long)self.adviceText.text.length,MAX_LIMIT_NUMS];
    }
}

//处理属性改变事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ABLog(@"%d",_adviceText.text.length);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneText) {
        // 1. 当长度达到11时，取消输入
        if (range.location >= 11){
            return false;
        }
    }
    return true;
}

/**
 返回一个BOOL值指明是否允许根据用户请求清除内容
 可以设置在特定条件下才允许清除内容
 
 @param textField 文本输入框
 
 @return
 */
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // iPhone4由于屏幕高度问题，弹出的键盘会部分挡住 ‘手机输入框’，所以需要滚动到一定位置
    if (iPhone4) {
        self.distance = CGRectGetMaxY(self.backView.frame) - keyboardDidShowY - 40 + 3;
        [self.backView setContentOffset:CGPointMake(self.backView.x, self.distance) animated:NO];
    }
    ABLog(@"%@",self.backView);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 键盘退出后需要滚回原来位置
    if (iPhone4) {
        [self.backView setContentOffset:CGPointMake(self.backView.x, 0) animated:NO];
    }
    ABLog(@"退出键盘");
}

#pragma mark - 设置页面
/**
 设置页面
 */
- (void)setupUI {
    
    // 1. 添加控件
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.adviceText];
    [self.backView addSubview:self.desc];
    [self.backView addSubview:self.phoneText];
    [self.backView addSubview:self.wordNumLabel];
    
    // 2. 布局
    // 2.0） 父控件布局
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // --------------- by kys start -------------------
        make.top.equalTo(self.view.mas_top).offset(64);
        // --------------- by kys end ---------------------
        
        //make.top.equalTo(self.view.mas_top).offset(74);
        make.height.equalTo(@(self.view.height * 0.3 - 10 + 20)); // + 1 是为了能显示底部的边框
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    // 2.1） 意见反馈框
    [self.adviceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top);
        make.height.equalTo(@(self.view.height * 0.3 - 10));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.wordNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backView.mas_top).offset(self.view.height*0.3-10-4-20);
//        make.right.equalTo(self.view.mas_right).offset(-12);
        make.top.equalTo(self.adviceText.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo([NSValue valueWithCGSize:CGSizeMake(100, 20)]);
    }];
    
    // 2.2） 描述
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adviceText.mas_bottom);
        make.height.equalTo(@40);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    // 2.3） 手机号输入框
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desc.mas_bottom);
        make.height.equalTo(@44);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
//    // 2.4） 分割线
//    UIView *sep1 = [[UIView alloc] init];
//    sep1.backgroundColor = CPColor(225, 225, 225);
//    UIView *sep2 = [[UIView alloc] init];
//    sep2.backgroundColor = CPColor(225, 225, 225);
//    
//    
//    // --------------- by kys start -------------------
//    UIView *sep3 = [[UIView alloc] init];
//    //sep3.backgroundColor = CPColor(225, 225, 225);
//    sep3.backgroundColor=[UIColor clearColor];
//    UIView *sep4 = [[UIView alloc] init];
//    //sep4.backgroundColor = CPColor(225, 225, 225);
//    sep4.backgroundColor=[UIColor clearColor];
//    // --------------- by kys end ---------------------
//    
//    
//    [self.backView addSubview:sep1];
//    [self.backView addSubview:sep2];
//    [self.backView addSubview:sep3];
//    [self.backView addSubview:sep4];
//    
//    [sep1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.adviceText.mas_top);
//        make.height.equalTo(@0.5);
//        if (iPhone4) {
//            make.width.equalTo(@640);
//        } else {
//            make.width.equalTo(@(self.view.width));
//        }
//    }];
//    
//    [sep2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.adviceText.mas_bottom);
//        make.height.equalTo(@0.5);
//        if (iPhone4) {
//            make.width.equalTo(@640);
//        } else {
//            make.width.equalTo(@(self.view.width));
//        }    }];
//
//    [sep3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.desc.mas_bottom);
//        make.height.equalTo(@0.5);    
//        if (iPhone4) {
//            make.width.equalTo(@640);
//        } else {
//            make.width.equalTo(@(self.view.width));
//        }
//    }];
//    
//    [sep4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.phoneText.mas_top).offset(40.5);  // 微调
//        make.height.equalTo(@0.5);
//        if (iPhone4) {
//            make.width.equalTo(@640);
//        } else {
//            make.width.equalTo(@(self.view.width));
//        }
//    }];

}

#pragma mark - 提交
- (void)commit {
    if (self.phoneText.text.length > 11) {
        ABLog(@"%@",[self.phoneText.text substringToIndex:11]);
    }
    else {
        ABLog(@"%@",self.phoneText.text);
    }
    
    if ([self.adviceText.text isEqualToString:@""] || [self.adviceText.text isEqualToString:@"闪服致力于提供高质量的IT运维服务，请您提出宝贵的意见和建议！"]) {
        [CustomToast showDialog:@"请输入您的反馈意见" time:1.5];
        return;        
    } else {
        
        [self commitContent:self.adviceText.text phone:_phoneNumber.length?_phoneNumber:@""];
    }
}

#pragma mark - 网络请求
//提交反馈信息
- (void)commitContent:(NSString *)content phone:(NSString *)phone {
    ABLog(@"提交");
    NSDictionary *dictParamert = @{@"content":content};
    __typeof(self) wSelf=self;
    [CustomToast showToastWithString:@"提交中..." InView:self.view];
    [KYSNetwork sugggestWithParameters:dictParamert success:^(id responseObject) {
        [CustomToast hideWatingInView:wSelf.view];
        // 悬浮提示框停留 1.5 秒
        [CustomToast showDialog:@"感谢您的建议" time:1.5];
        [wSelf.navigationController popViewControllerAnimated:YES];
        ABLog(@"success:%@",dictParamert);
    } failureBlock:^(id object) {
        [CustomToast hideWatingInView:self.view];
        if (object) {
           
        }
    } view:nil];
}

#pragma mark - 退出键盘
- (void)resignKeyboardWhenClickBlankZone {

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    // 设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer2.cancelsTouchesInView = NO;
    
    // 将触摸事件添加到当前view 和 navigationBar,实现 ‘非输入区域’点击退出键盘
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.navigationController.navigationBar addGestureRecognizer:tapGestureRecognizer2];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap {
    ABLog(@"tap:%@",tap);
    [self.adviceText resignFirstResponder];
    [self.phoneText resignFirstResponder];
}

#pragma mark - 懒加载数据
- (UIScrollView *)backView {
    if (!_backView) {
        _backView = [[UIScrollView alloc] init];
        //_backView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        _backView.backgroundColor=[UIColor whiteColor];
    }
    return _backView;
}

- (KYSTextView *)adviceText {
    if (!_adviceText) {
        _adviceText = [[KYSTextView alloc] init];
//        _adviceText.delegate = self;    // 不需要设置代理，CPTextView的初始化方法里做了设置
        _adviceText.backgroundColor = [UIColor whiteColor]; // 背景色
        _adviceText.textColor = [UIColor blackColor];   // 字体颜色
        _adviceText.font = [UIFont systemFontOfSize:TEXT_SIZE_28D];    // 字体大小
        _adviceText.textContainerInset = UIEdgeInsetsMake(PADDING_V, PADDING_H, PADDING_V, PADDING_H);   // 设置边距 - 上左下右
        _adviceText.maxLength = MAX_LIMIT_NUMS;    // 最大字数输入限制
        _adviceText.placehoder = @"闪服致力于提供高质量的IT运维服务，请您提出宝贵的意见和建议！";
        _adviceText.placeHoderPoint = CGPointMake(PADDING_H + 3, PADDING_V);    // + 3 微调
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueChange:) name:UITextViewTextDidChangeNotification object:_adviceText];
    }
    return _adviceText;
}

- (UILabel *)wordNumLabel{
    if (!_wordNumLabel) {
        _wordNumLabel=[[UILabel alloc] init];
        _wordNumLabel.font=[UIFont systemFontOfSize:12.0];
        _wordNumLabel.textColor=[UIColor lightGrayColor];
        _wordNumLabel.textAlignment=NSTextAlignmentRight;
        _wordNumLabel.backgroundColor=[UIColor clearColor];
        _wordNumLabel.text=[NSString stringWithFormat:@"0/%d",MAX_LIMIT_NUMS];
    }
    return _wordNumLabel;
}

- (UILabel *)desc {
    if(!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.text = @"   请留下您的联系方式，感谢您的支持！";
        _desc.font = [UIFont systemFontOfSize:TEXT_SIZE_30D];
        _desc.backgroundColor=CPColor(246, 246, 246);
        _desc.textColor = CPColor(132, 132, 132);
        
        // --------------- by kys start ---------------------
        _desc.hidden=YES;
        // --------------- by kys end ---------------------
    }
    return _desc;
}

- (HFHTextField *)phoneText {
    if (!_phoneText) {
        _phoneText = [[HFHTextField alloc] init];
        _phoneText.delegate = self; // 设置代理
        _phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;   // 设置编辑的时候可以清空
        _phoneText.backgroundColor = [UIColor whiteColor];  // 背景色
        _phoneText.placeholder = @"请输入手机号";
        _phoneText.font = [UIFont systemFontOfSize:TEXT_SIZE_28D];    // 字体大小
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;  // 数字键盘
        _phoneText.placeHolderPadding = PADDING_H;  // 设置placeholder距离左边的间距
        _phoneText.placeHolderColor = CPColor(160, 160, 160); // 设置placeholder字体颜色
        _phoneText.placeHolderFontSize = 14; // 设置placeholder字体大小
        
        // --------------- by kys start -------------------
        _phoneText.hidden=YES;
        // --------------- by kys end ---------------------
    }
    return _phoneText;
}

@end
