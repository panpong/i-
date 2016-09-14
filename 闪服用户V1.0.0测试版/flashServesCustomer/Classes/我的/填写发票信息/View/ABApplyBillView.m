//
//  ABApplyBillView.m
//  flashServesCustomer
//
//  Created by 002 on 16/6/3.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABApplyBillView.h"
#import "UIView+Extention.h"
#import "UILabel+Extention.h"
#import "HFHTextField.h"
#import "ABNetworkManager.h"
#import "CustomToast.h"
#import "ABSingleFormView.h"
#import "HFHTextView.h"
#import "UIButton+Extention.h"

#define PADDING_TOP_applyBillButton 20 // ‘提交’顶部间距
#define minBillPrice 0 // 开发票的最小金额
#define max_length_billDatailAdress 100 // 详细地址最大数字字数

@interface ABApplyBillView ()<UITextViewDelegate,UITextFieldDelegate>

// 发票抬头
@property(nonatomic,strong) ABSingleFormView *billTitleView;

// 发票内容
@property(nonatomic,strong) ABSingleFormView *billContentView;

// 发票金额
@property(nonatomic,strong) ABSingleFormView *billPriceView;

// 收件人
@property(nonatomic,strong) ABSingleFormView *billReceiverView;

// 联系电话
@property(nonatomic,strong) ABSingleFormView *billPhoneNumView;

// 详细地址
@property(nonatomic,strong) ABSingleFormView *billDetailAdressView;

// 详细地址的ContenView组件的原始高度
@property(nonatomic,assign) CGFloat contentViewOriginHeight;

// 提交按钮
@property(nonatomic,strong) UIButton *applyBillButton;

@property(nonatomic,assign) CGFloat offsetY;

// 退出键盘View
@property(nonatomic,strong) UIView *resignView;

// 可开发票金额
@property (nonatomic, copy) NSString *leftMoney;

// 上一次发票抬头信息
@property (nonatomic, copy) NSString *lastBillTitle;

// 键盘的frame
@property(nonatomic,assign) CGRect keyBoardFrame;

@end

@implementation ABApplyBillView

- (instancetype)initWithFrame:(CGRect)frame leftMoney:(NSString *)leftMoney lastBillTitle:(NSString *)lastBillTitle {
    if (self = [super initWithFrame:frame]) {
        self.leftMoney = leftMoney;
        self.lastBillTitle = lastBillTitle;
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

+ (instancetype)applyBillViewWithFrame:(CGRect)frame leftMoney:(NSString *)leftMoney lastBillTitle:(NSString *)lastBillTitle {
    ABApplyBillView *applyBillView = [[ABApplyBillView alloc] initWithFrame:frame leftMoney:leftMoney lastBillTitle:lastBillTitle];
    return applyBillView;
}

#pragma mark - UI设置
- (void)setupUI {
    // 1. 添加控件
    [self addSubview:self.billTitleView];
    [self addSubview:self.billContentView];
    [self addSubview:self.billPriceView];
    [self addSubview:self.billReceiverView];
    [self addSubview:self.billPhoneNumView];
    [self addSubview:self.billDetailAdressView];
    [self addSubview:self.applyBillButton];
 
//    // 2. 布局
//    self.billTitleView.x = 0;
//    self.billTitleView.y = 0;
//    
//    self.billContentView.x = self.billTitleView.x;
//    self.billContentView.y = self.billTitleView.bottom;
//
//    self.billPriceView.x = self.billTitleView.x;
//    self.billPriceView.y = self.billContentView.bottom;
//    
//    self.billReceiverView.x = self.billTitleView.x;
//    self.billReceiverView.y = self.billPriceView.bottom + 10;
//    
//    self.billPhoneNumView.x = self.billTitleView.x;
//    self.billPhoneNumView.y = self.billReceiverView.bottom;
//    
//    self.billDetailAdressView.x = self.billTitleView.x;
//    self.billDetailAdressView.y = self.billPhoneNumView.bottom;
//    
//    self.applyBillButton.width = ScreenWidth - 2 * PADDING_30PX;
//    self.applyBillButton.height = HEIGHT_LOGIN_AND_RIGISTER_BUTTON_IPHONE6;
//    if (iPhone5) {
//        self.applyBillButton.height = HEIGHT_LOGIN_AND_RIGISTER_BUTTON_IPHONE5;
//    }
//    self.applyBillButton.x = PADDING_30PX;
//    self.applyBillButton.y = self.billDetailAdressView.bottom + PADDING_TOP_applyBillButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    // 2. 布局
    self.billTitleView.x = 0;
    self.billTitleView.y = 0;
    
    self.billContentView.x = self.billTitleView.x;
    self.billContentView.y = self.billTitleView.bottom;
    
    self.billPriceView.x = self.billTitleView.x;
    self.billPriceView.y = self.billContentView.bottom;
    
    self.billReceiverView.x = self.billTitleView.x;
    self.billReceiverView.y = self.billPriceView.bottom + 10;
    
    self.billPhoneNumView.x = self.billTitleView.x;
    self.billPhoneNumView.y = self.billReceiverView.bottom;
    
    self.billDetailAdressView.x = self.billTitleView.x;
    self.billDetailAdressView.y = self.billPhoneNumView.bottom;
    
    self.applyBillButton.width = ScreenWidth - 2 * PADDING_30PX;
    self.applyBillButton.height = HEIGHT_LOGIN_AND_RIGISTER_BUTTON_IPHONE6;
    if (iPhone5) {
        self.applyBillButton.height = HEIGHT_LOGIN_AND_RIGISTER_BUTTON_IPHONE5;
    }
    self.applyBillButton.x = PADDING_30PX;
    self.applyBillButton.y = self.billDetailAdressView.bottom + PADDING_TOP_applyBillButton;
}

#pragma mark - 申请发票
- (void)submitApplyInfo {
    
    if (![self isApplyInfoCorrected]) {
        return;
    }
    NSString *urlStr = @"customer/invoices/v1.0.1/apply";
    
    // 单位：分
    NSString *price = [NSString stringWithFormat:@"%lf",[self.billPriceView.textValue floatValue] * 100 ];
    ABLog(@"%@",price);
    NSDictionary *dict = @{@"money" : price,
                           @"title" : self.billTitleView.textValue,
                           @"content" : self.billContentView.textValue,
                           @"contact" : self.billReceiverView.textValue,
                           @"mobile" : self.billPhoneNumView.textValue,
                           @"address" : self.billDetailAdressView.textValue};
    
    [CustomToast showWatingInView:self.viewController.view];
    [KABNetworkManager POST:urlStr parameters:dict success:^(id responseObject) {
        [CustomToast hideWatingInView:self.viewController.view];
        if (checkNetworkResultObject(responseObject)) {
            [CustomToast showDialog:@"提交成功" time:1.5];
            [self.viewController.navigationController popViewControllerAnimated:YES];
            
            // 默认显示上一次开票的发票抬头，提交成功后存储本地
            [[NSUserDefaults standardUserDefaults] setObject:self.billTitleView.textValue forKey:@"billTitleView"];
        } else {
            [CustomToast showDialog:responseObject[@"errmsg"] time:1.5];
        }
    } failure:^(id object) {
        [CustomToast hideWatingInView:self.viewController.view];
        [CustomToast showNetworkError];
    }];
}

#pragma mark - 验证信息正确性
- (BOOL)isApplyInfoCorrected {
    if ([@"" isEqualToString:self.billTitleView.textValue]) {
        [CustomToast showDialog:@"请输入发票抬头" time:1.5];
        return false;
    }
    if ([@"" isEqualToString:self.billReceiverView.textValue]) {
        [CustomToast showDialog:@"请输入收件人" time:1.5];
        return false;
    }
    if ([@"" isEqualToString:self.billPhoneNumView.textValue]) {
        [CustomToast showDialog:@"请输入联系电话" time:1.5];
        return false;
    }
    if ([@"" isEqualToString:self.billDetailAdressView.textValue]) {
        [CustomToast showDialog:@"请输入详细地址" time:1.5];
        return false;
    }
    if ([@"" isEqualToString:self.billPriceView.textValue]) {
        [CustomToast showDialog:@"请输入发票金额" time:1.5];
        return false;
    }
    
    if ([self.billPriceView.textValue floatValue] > [self.leftMoney floatValue]) {
        
        [CustomToast showDialog:@"请输入正确的发票金额" time:1.5];
        return false;
    }
    
    if (  [self.billPriceView.textValue floatValue] <= minBillPrice) {
        [CustomToast showDialog:@"请输入正确的发票金额" time:1.5];
        return false;
    }
    return true;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    // 让输入文字能随时滚动到最后一行
    [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 1, 1)];
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > max_length_billDatailAdress)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:max_length_billDatailAdress];
        
        [textView setText:s];
    }
    textView.height = textView.contentSize.height;
    if (textView.height < SIZE_HEIGHT_TABLEVIEW_ROW) {
        textView.height = SIZE_HEIGHT_TABLEVIEW_ROW;
    }
    
    
    self.billDetailAdressView.height = textView.height;
    
    self.applyBillButton.y = self.billDetailAdressView.bottom + PADDING_TOP_applyBillButton;
    
    // 换行的时候如果高度超过键盘高度处理
    // 获取当前界面的第一响应对象
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    CGRect firstResponderFrame = firstResponder.frame;
    CGRect newFrameFirstResponder = [firstResponder.superview convertRect:firstResponderFrame toView:[[UIApplication sharedApplication] keyWindow]];
    
    // 如果键盘盖过了当前输入框,滚动
    if (newFrameFirstResponder.origin.y + newFrameFirstResponder.size.height > self.keyBoardFrame.origin.y) {
        
        CGFloat offsetY = newFrameFirstResponder.origin.y + newFrameFirstResponder.size.height - self.keyBoardFrame.origin.y;
        self.offsetY = offsetY;
        CGFloat contentOffsetY = self.contentOffset.y + offsetY;
        [self setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
        ABLog(@"self:%@",self);
        ABLog(@"ContentSize%@",NSStringFromCGSize(self.contentSize));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.contentOffset.y < contentOffsetY) {
                ABLog(@"2");
                [self setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
            }
        });
    }

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return YES;
    
}

#pragma mark - 监听键盘
- (void)keyboardHide {
    // 获取当前界面的第一响应对象
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    // 取消注册
    [firstResponder resignFirstResponder];
    
//    if (self.resignView.superview) {
//        [self.resignView removeFromSuperview];
//    }
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // 获取当前界面的第一响应对象
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    // 键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyBoardFrame = keyBoardFrame;
    
//    self.resignView.x = 0;
//    self.resignView.bottom = keyBoardFrame.origin.y;
//    [[[UIApplication sharedApplication] keyWindow] addSubview:self.resignView];
    
    ABLog(@"keyBoardFrame:%@",NSStringFromCGRect(keyBoardFrame));
    
    // 1. 转换坐标 - 当前响应者 -> Window
    ABLog(@"firstResponder:%@",NSStringFromCGRect(firstResponder.frame));
    
    CGRect firstResponderFrame = firstResponder.frame;
    CGRect newFrameFirstResponder = [firstResponder.superview convertRect:firstResponderFrame toView:[[UIApplication sharedApplication] keyWindow]];
    
    // 如果键盘盖过了当前输入框,滚动
    if (newFrameFirstResponder.origin.y + newFrameFirstResponder.size.height > keyBoardFrame.origin.y) {
        
        CGFloat offsetY = newFrameFirstResponder.origin.y + newFrameFirstResponder.size.height - keyBoardFrame.origin.y;
        self.offsetY = offsetY;
        CGFloat contentOffsetY = self.contentOffset.y + offsetY;
        [self setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
        ABLog(@"self:%@",self);
        ABLog(@"ContentSize%@",NSStringFromCGSize(self.contentSize));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.contentOffset.y < contentOffsetY) {
                ABLog(@"2");
                [self setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
            }
        });
    }
    return;
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    ABLog(@"keyboardWillBeHidden:%@",NSStringFromCGRect(keyBoardFrame));
    
    if (self.contentOffset.y > 0) {
        // 恢复scrollView的滚动范围
        self.contentOffset = CGPointMake(0, 0);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (ABSingleFormView *)billTitleView {
    if (!_billTitleView) {
        HFHTextField *contentTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入发票抬头" placeHolderSize:PADDING_30PX placeHolderPadding:0 leftViewImageName:nil];
        contentTextField.placeHolderColor = KColorTextPlaceHold;
        contentTextField.backgroundColor = KWhiteColor;
        contentTextField.limitLength = 30;
        contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentTextField.delegate = self;
        
        UILabel *descLabel = [UILabel labelWithTitle:@"发票抬头" fontSize:PADDING_30PX color:KColorTextPlaceHold];
        descLabel.backgroundColor = KWhiteColor;
                
        if (self.lastBillTitle && ![@"" isEqualToString:self.lastBillTitle]) {
            contentTextField.text = self.lastBillTitle;
        }    
        _billTitleView = [ABSingleFormView singleFormViewWithFrame:CGRectMake(0, 0, ScreenWidth, SIZE_HEIGHT_TABLEVIEW_ROW) descLabel:descLabel contentTextField:contentTextField topSepWith:0 bottomSepWith:ScreenWidth - PADDING_30PX];
    }
    return _billTitleView;
}

- (ABSingleFormView *)billContentView {
    if (!_billContentView) {
        HFHTextField *contentTextField = [HFHTextField textFieldWithPlaceHolder:nil placeHolderSize:PADDING_30PX placeHolderPadding:0 leftViewImageName:nil];
        contentTextField.text = @"服务费";
        contentTextField.font = [UIFont systemFontOfSize:PADDING_30PX];
        contentTextField.userInteractionEnabled = false;
        contentTextField.backgroundColor = KWhiteColor;
        
        UILabel *descLabel = [UILabel labelWithTitle:@"发票内容" fontSize:PADDING_30PX color:KColorTextPlaceHold];
        descLabel.backgroundColor = KWhiteColor;
        
        _billContentView = [ABSingleFormView singleFormViewWithFrame:CGRectMake(0, 0, ScreenWidth, SIZE_HEIGHT_TABLEVIEW_ROW) descLabel:descLabel contentTextField:contentTextField topSepWith:0 bottomSepWith:ScreenWidth - PADDING_30PX];
    }
    return _billContentView;
}

- (ABSingleFormView *)billPriceView {
    if (!_billPriceView) {
        HFHTextField *contentTextField = [HFHTextField textFieldWithPlaceHolder:@"发票金额满2000元包邮" placeHolderSize:PADDING_30PX placeHolderPadding:0 leftViewImageName:nil];
        contentTextField.placeHolderColor = KColorTextPlaceHold;
        contentTextField.backgroundColor = KWhiteColor;
        contentTextField.limitLength = 30;
        contentTextField.keyboardType = UIKeyboardTypeDecimalPad;
        contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentTextField.delegate = self;
        contentTextField.textColor = KMoneyColor;
        
        UILabel *descLabel = [UILabel labelWithTitle:@"发票金额" fontSize:PADDING_30PX color:KColorTextPlaceHold];
        descLabel.backgroundColor = KWhiteColor;
        
        _billPriceView = [ABSingleFormView singleFormViewWithFrame:CGRectMake(0, 0, ScreenWidth, SIZE_HEIGHT_TABLEVIEW_ROW) descLabel:descLabel contentTextField:contentTextField topSepWith:0 bottomSepWith:ScreenWidth];
    }
    return _billPriceView;
}

- (ABSingleFormView *)billReceiverView {
    if (!_billReceiverView) {
        HFHTextField *contentTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入收件人" placeHolderSize:PADDING_30PX placeHolderPadding:0 leftViewImageName:nil];
        contentTextField.placeHolderColor = KColorTextPlaceHold;
        contentTextField.backgroundColor = KWhiteColor;
        contentTextField.limitLength = 15;
        contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentTextField.delegate = self;
        
        UILabel *descLabel = [UILabel labelWithTitle:@"收件人" fontSize:PADDING_30PX color:KColorTextPlaceHold];
        descLabel.backgroundColor = KWhiteColor;
        
        _billReceiverView = [ABSingleFormView singleFormViewWithFrame:CGRectMake(0, 0, ScreenWidth, SIZE_HEIGHT_TABLEVIEW_ROW) descLabel:descLabel contentTextField:contentTextField topSepWith:ScreenWidth bottomSepWith:ScreenWidth - PADDING_30PX];
    }
    return _billReceiverView;
}

- (ABSingleFormView *)billPhoneNumView {
    if (!_billPhoneNumView) {
        HFHTextField *contentTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入联系电话" placeHolderSize:PADDING_30PX placeHolderPadding:0 leftViewImageName:nil];
        contentTextField.placeHolderColor = KColorTextPlaceHold;
        contentTextField.backgroundColor = KWhiteColor;
        contentTextField.limitLength = 15;
        contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentTextField.delegate = self;
        
        UILabel *descLabel = [UILabel labelWithTitle:@"联系电话" fontSize:PADDING_30PX color:KColorTextPlaceHold];
        descLabel.backgroundColor = KWhiteColor;
        
        _billPhoneNumView = [ABSingleFormView singleFormViewWithFrame:CGRectMake(0, 0, ScreenWidth, SIZE_HEIGHT_TABLEVIEW_ROW) descLabel:descLabel contentTextField:contentTextField topSepWith:0 bottomSepWith:ScreenWidth - PADDING_30PX];
    }
    return _billPhoneNumView;
}

- (ABSingleFormView *)billDetailAdressView {
    if (!_billDetailAdressView) {
        
        UILabel *descLabel = [UILabel labelWithTitle:@"详细地址" fontSize:PADDING_30PX color:KColorTextPlaceHold];
        descLabel.backgroundColor = KWhiteColor;
        
        HFHTextView *contentTextView = [HFHTextView textViewWithFrame:CGRectMake(0, 0, ScreenWidth - 100 - PADDING_30PX, SIZE_HEIGHT_TABLEVIEW_ROW) placeHolder:@"请输入详细地址" placeHoderPoint:CGPointMake(0, 13) maxLength:100 remainedWordsLabel:nil];
        contentTextView.backgroundColor = KWhiteColor;
        contentTextView.font = [UIFont systemFontOfSize:PADDING_30PX];
        contentTextView.textContainerInset = UIEdgeInsetsMake(13, -3, 13, 0);
        contentTextView.delegate = self;        
        _billDetailAdressView = [ABSingleFormView singleFormViewWithFrame:CGRectMake(0, 0, ScreenWidth, SIZE_HEIGHT_TABLEVIEW_ROW) descLabel:descLabel contentTextView:contentTextView topSepWith:0 bottomSepWith:ScreenWidth];        
        self.contentViewOriginHeight = contentTextView.height;
    }
    return _billDetailAdressView;
}

- (UIButton *)applyBillButton {
    if (!_applyBillButton) {
        _applyBillButton = [UIButton buttonWithTitle:@"提交" color:KWhiteColor fontSize:18 imageName:nil];
        [_applyBillButton addTarget:self action:@selector(submitApplyInfo) forControlEvents:UIControlEventTouchUpInside];
        _applyBillButton.backgroundColor = KColorBlue;
        _applyBillButton.layer.cornerRadius = 5;
        _applyBillButton.clipsToBounds = YES;
    }
    return _applyBillButton;
}

//- (UIView *)resignView {
//    if (!_resignView) {
//        _resignView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
//        UIButton *resignButton = [UIButton buttonWithTitle:@"完成" color:KColorBlue fontSize:PADDING_28PX imageName:nil];
//        [resignButton addTarget:self action:@selector(keyboardHide) forControlEvents:UIControlEventTouchUpInside];
//        _resignView.backgroundColor = KWhiteColor;
//        [_resignView addSubview:resignButton];        
//        resignButton.right = ScreenWidth - 10;
//        resignButton.y = 0;
//    }
//    return _resignView;
//}

@end
