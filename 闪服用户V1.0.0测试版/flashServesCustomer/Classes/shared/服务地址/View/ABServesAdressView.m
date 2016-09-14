//
//  ABServesAdressView.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServesAdressView.h"
#import "UIView+Extention.h"
#import "ABCommonAdressViewController.h"
#import "UIButton+Extention.h"
#import "ABServiceAdressHistoryTableView.h"
#import "ABLocation.h"
#import "UILabel+Extention.h"
#import "ABHistoryLocations.h"
#import "ABServesAdressViewController.h"
#import "ABNetworkManager.h"

#define SIZE_HEIGHT_ADRESSTEXTFILED 45   // 地址‘文本输入框’的高度
#define SIZE_HEIGHT_CONFIRMBUTTON_BACKVIEW  105 // ‘确认’按钮的背景视图高度
#define PADDIG_TOP_HISTORYLABEL 20 // 历史记录标签上间距

@interface ABServesAdressView ()<UITextFieldDelegate,ABServiceAdressHistoryTableViewDelegate>

@property(nonatomic,strong) UIView *sep1;   // 分割线1
@property(nonatomic,strong) UIView *sep2;   // 分割线2
@property(nonatomic,strong) UIView *confirmButtonBackView;   // ‘确定’按钮的背景视图
@property(nonatomic,strong) UIView *historyViewBackView;   // 背景视图 - 颜色切换
@property(nonatomic,strong) UILabel *historyLabel;  // 历史记录标签
@property(nonatomic,assign) BOOL isNeedHistory; // 是否需要历史记录
@property(nonatomic,strong) NSMutableArray<ABLocation *> *historyDatas;

@end

@implementation ABServesAdressView

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame isNeedHistory:(BOOL)isNeedHistory {
    self = [super initWithFrame:frame];
    if (self) {
        self.isNeededHistory = isNeedHistory;
        // 请求用户历史订单列表
        [self loadHistoryServiceList];
        [self setupUI];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHistoryLabel:) name:NOTIFICATION_ISSHOWHISTORYLABEL object:nil];
    }
    return self;
}

+ (instancetype)servesAdressViewWithFrame:(CGRect)frame isNeedHistory:(BOOL)isNeedHistory {
    ABServesAdressView *servesAdressView = [[ABServesAdressView alloc] initWithFrame:frame isNeedHistory:isNeedHistory];
    return servesAdressView;
}

#pragma mark - UI设置
- (void)setupUI {
    self.backgroundColor = KGrayGroundColor;
    // 1. 添加控件
    [self addSubview:self.adressTextField];
    [self addSubview:self.adressButton];
    [self addSubview:self.adressDetailTextField];
    [self addSubview:self.sep1];
    [self addSubview:self.sep2];
    [self addSubview:self.confirmButtonBackView];
    [self addSubview:self.confirmButton];
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下一级"]];
    [_adressTextField addSubview:arrowImageView];
    // 2. 布局
    
    // 小区输入栏
    self.adressTextField.height = SIZE_HEIGHT_ADRESSTEXTFILED;
    self.adressTextField.width = ScreenWidth - 2 * PADDING_30PX;
    self.adressTextField.x = PADDING_30PX;
    self.adressTextField.y = 0;
    
    // 下一级图标
    arrowImageView.centerY = self.adressTextField.height / 2;
    arrowImageView.right = self.adressTextField.width;
    
    // 小区输入栏 按钮
    self.adressButton.frame = self.adressTextField.frame;
    
    // 详细地址输入栏
    self.adressDetailTextField.height = SIZE_HEIGHT_ADRESSTEXTFILED;
    self.adressDetailTextField.width = ScreenWidth - 2 * PADDING_30PX;
    self.adressDetailTextField.x = PADDING_30PX;
    self.adressDetailTextField.y = self.adressTextField.bottom;
    
    // 顶部白色背景视图
    UIView *topBackView = [[UIView alloc] init];
    [self insertSubview:topBackView atIndex:0];
    topBackView.backgroundColor = KWhiteColor;
    topBackView.width = self.width;
    topBackView.height = self.adressDetailTextField.bottom - self.adressTextField.y;
    topBackView.x = 0;
    topBackView.bottom = self.adressDetailTextField.bottom;
    
    // 分割线1
    self.sep1.width = ScreenWidth;
    self.sep1.height = 1;
    self.sep1.x = 0;
    self.sep1.y = self.adressTextField.bottom;
    
    // 分割线1
    self.sep2.width = ScreenWidth;
    self.sep2.height = 1;
    self.sep2.x = 0;
    self.sep2.y = self.adressDetailTextField.bottom;
    
    // ‘确认’按钮背景视图
    self.confirmButtonBackView.width = ScreenWidth;
    self.confirmButtonBackView.height = SIZE_HEIGHT_CONFIRMBUTTON_BACKVIEW;
    self.confirmButtonBackView.x = 0;
    self.confirmButtonBackView.y = self.sep2.bottom;
    
    // ‘确认’按钮
    self.confirmButton.width = ScreenWidth - 2 * PADDING_30PX;
    if (iPhone5) {
        self.confirmButton.height = HEIGHT_LOGIN_AND_RIGISTER_BUTTON_IPHONE5;
    } else {
        self.confirmButton.height = HEIGHT_LOGIN_AND_RIGISTER_BUTTON_IPHONE6;
    }
    self.confirmButton.x = PADDING_30PX;
    self.confirmButton.y = self.adressDetailTextField.bottom + PADDING_30PX;
}

- (void)updateUI {
    [self addSubview:self.historyLabel];
    [self addSubview:self.serviceAdressHistoryTableView];
    // 判断是否有历史记录
    BOOL hasHistoryLocations;
    if (self.historyLocations.count > 0 && self.isNeededHistory) {
        hasHistoryLocations = YES;
    } else {
        self.historyLabel.hidden = YES;
        self.serviceAdressHistoryTableView.hidden = YES;
        
        // 添加灰色背景遮罩
        [self addSubview:self.historyViewBackView];
        self.historyViewBackView.width = ScreenWidth;
        self.historyViewBackView.height = ScreenHeight - self.confirmButtonBackView.bottom;
        self.historyViewBackView.x = 0;
        self.historyViewBackView.y = self.confirmButtonBackView.bottom;
        
    }
    // 历史记录标签
    self.historyLabel.x = PADDING_30PX;
    self.historyLabel.y = self.confirmButton.bottom + PADDIG_TOP_HISTORYLABEL;
    
    // 历史记录tableview
    self.serviceAdressHistoryTableView.x = 0;
    self.serviceAdressHistoryTableView.y = self.confirmButtonBackView.bottom;
    self.serviceAdressHistoryTableView.height = ScreenHeight - self.confirmButtonBackView.bottom - SIZE_HEIGHT_NAVIGATIONBAR;
    [self bringSubviewToFront:self.serviceAdressHistoryTableView];

}

- (void)showHistoryLabel:(NSNotification *)notifation {
    if ([@"YES" isEqualToString:notifation.object] && self.isNeededHistory) {
        self.historyLabel.hidden = NO;
    } else {
        self.historyLabel.hidden = YES;
    }
}

- (void)loadHistoryServiceList {
    
    NSString *urlStr = @"customer/locations/v1.0.1/list";
    
    [KABNetworkManager POST:urlStr parameters:nil success:^(id responseObject) {
        if ([@"200" isEqualToString:responseObject[@"errcode"]]) {
            
            NSArray *datas = responseObject[@"data"];
            if (datas.count > 0) {
                self.historyDatas = [NSMutableArray arrayWithCapacity:datas.count];
                for (NSDictionary *dict in datas) {
                    ABLocation *location = [ABLocation locationWithDict:dict];
                    [self.historyDatas addObject:location];
                }
                self.historyLocations = self.historyDatas;;
                self.serviceAdressHistoryTableView.historyLocations = self.historyDatas;
            }
        [self updateUI];
        }
    } failure:^(id object) {
        [self updateUI];
        ABLog(@"object:%@",object);
    }];
}

#pragma mark - ABServiceAdressHistoryTableViewDelegate
- (void)serviceAdressHistoryTableView:(ABServiceAdressHistoryTableView *)ServiceAdressHistoryTableView DidSelectLocation:(ABLocation *)location {
    
    self.adressTextField.text = location.name;
    self.adressDetailTextField.text = location.no;
    
    // 记录下对象
    self.location = location;
    
    // 返回到上门信息界面
    [self.viewController confirmButtonDidClick];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ISSHOWHISTORYLABEL object:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

#pragma mark - 懒加载
- (HFHTextField *)adressTextField {
    if (!_adressTextField) {
        _adressTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入小区、街道、大厦名称" placeHolderSize:PADDING_30PX placeHolderPadding:2 * PADDING_30PX leftViewImageName:@"服务地址-位置1"];
        [_adressTextField setValue:KColorTextPlaceHold forKeyPath:@"_placeholderLabel.textColor"];
        [[_adressTextField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
        _adressTextField.tag = 1001;
    }
    return _adressTextField;
}

- (UIButton *)adressButton {
    if (!_adressButton) {
        _adressButton = [[UIButton alloc] init];
        _adressButton.backgroundColor = [UIColor clearColor];
    }
    return _adressButton;
}

- (HFHTextField *)adressDetailTextField {
    if (!_adressDetailTextField) {
        _adressDetailTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入详细门牌号" placeHolderSize:PADDING_30PX placeHolderPadding:2 * PADDING_30PX leftViewImageName:@"服务地址-位置2"];
        _adressDetailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_adressDetailTextField setValue:KColorTextPlaceHold forKeyPath:@"_placeholderLabel.textColor"];
        _adressDetailTextField.limitLength = 20;   // 限制输入20字符
    }
    return _adressDetailTextField;
}

- (UIView *)sep1 {
    if (!_sep1) {
        _sep1 = [[UIView alloc] init];
        _sep1.backgroundColor = KColorLine;
    }
    return _sep1;
}

- (UIView *)sep2 {
    if (!_sep2) {
        _sep2 = [[UIView alloc] init];
        _sep2.backgroundColor = KColorLine;
    }
    return _sep2;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithTitle:@"确认" color:KWhiteColor fontSize:19 imageName:nil];
        _confirmButton.backgroundColor = KColorBlue;
        [_confirmButton.layer setCornerRadius:5];        
    }
    return _confirmButton;
}

- (UIView *)confirmButtonBackView {
    if (!_confirmButtonBackView) {
        _confirmButtonBackView = [[UIView alloc] init];
        _confirmButtonBackView.backgroundColor = KGrayGroundColor;
    }
    return _confirmButtonBackView;
}

- (UIView *)historyViewBackView {
    if (!_historyViewBackView) {
        _historyViewBackView = [[UIView alloc] init];
        _historyViewBackView.backgroundColor = KGrayGroundColor;
    }
    return _historyViewBackView;
}

- (UILabel *)historyLabel {
    if (!_historyLabel) {
        _historyLabel = [UILabel labelWithTitle:@"使用历史地址" fontSize:PADDING_30PX color:kColorTextGrey];
    }
    return _historyLabel;
}

- (ABServiceAdressHistoryTableView *)serviceAdressHistoryTableView {
    if (!_serviceAdressHistoryTableView) {
        _serviceAdressHistoryTableView = [ABServiceAdressHistoryTableView serviceAdressHistoryTableViewWithFrame:CGRectMake(0, self.confirmButtonBackView.bottom, ScreenWidth, ScreenHeight - self.confirmButtonBackView.bottom) style:UITableViewStylePlain];
//        _serviceAdressHistoryTableView.hidden = YES;
        _serviceAdressHistoryTableView.bounces = NO;
        _serviceAdressHistoryTableView.historyDelegate = self;
    }
    return _serviceAdressHistoryTableView;
}


@end
