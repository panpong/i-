//
//  ABServesAdressViewController.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServesAdressViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import <BaiduMapAPI_Search/BMKPoiSearchOption.h>
#import "ABCommonAdressViewController.h"
#import "CustomToast.h"
#import "ABLocation.h"
#import "ABHistoryLocations.h"

@interface ABServesAdressViewController ()<chosedCommonAdressDelegate>

@property(nonatomic,strong) ABLocation *location;   // 传入和上传的地址对象
@property(nonatomic,strong) ABLocation *tempLocation;   // 零时地址对象
@property(nonatomic,assign) BOOL isNeededHistory;   // 是否需要历史记录

@end

@implementation ABServesAdressViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 设置导航栏
    [self setNavigationBarItem:self.title leftButtonIcon:@"返回"];
    
    [self setupUI];
}

- (instancetype)initWithLocation:(ABLocation *)location {
    self = [super init];
    if (self) {
        _location = location;
        if (location.name && ![@"" isEqualToString:location.name]) {
            self.servesAdressView.adressTextField.text = location.name;
        }
        if (location.address && ![@"" isEqualToString:location.address]) {
            self.servesAdressView.adressDetailTextField.text = location.no;
        }
    }
    return self;
}

- (instancetype)initWithLocation:(ABLocation *)location isNeededHistory:(BOOL)isNeededHistory {
    self = [super init];
    if (self) {
        _location = location;
        self.isNeededHistory = isNeededHistory;
        if (location.name && ![@"" isEqualToString:location.name]) {
            self.servesAdressView.adressTextField.text = location.name;
        }
        if (location.no && ![@"" isEqualToString:location.no]) {
            self.servesAdressView.adressDetailTextField.text = location.no;
        }
    }
    return self;
}

+ (instancetype)servesAdressViewControllerWithLocation:(ABLocation *)location {
    ABServesAdressViewController *servesAdressViewController = [[ABServesAdressViewController alloc] initWithLocation:location];
    return servesAdressViewController;
}

+ (instancetype)servesAdressViewControllerWithLocation:(ABLocation *)location isNeededHistory:(BOOL)isNeededHistory {
    ABServesAdressViewController *servesAdressViewController = [[ABServesAdressViewController alloc] initWithLocation:location isNeededHistory:isNeededHistory];
    return servesAdressViewController;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    // 添加监听键盘通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    
//    // 移除通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI设置
- (void)setupUI {

    // 1.添加控件
    [self.view addSubview:self.servesAdressView];
    
    // 2.布局
    // 2.1 servesAdressView的布局在get方法里写了
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -监听键盘
//- (void)keyboardWasShown:(NSNotification*)aNotification {
//    // 获取当前界面的第一响应对象
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//    
//    
//    
//    // 如果是‘小区输入框’，条状到联想词输入界面
//    if (firstResponder.tag == 1001) {
//        BMKCitySearchOption *searchOption = [[BMKCitySearchOption alloc] init];
//        searchOption.city = @"北京";
//        [self.navigationController pushViewController:[ABCommonAdressViewController commonAdressViewController:searchOption] animated:YES];
//        [firstResponder resignFirstResponder];
//    }
//}

#pragma mark - 跳转到联想词界面
- (void)jumpToABCommonAdressViewController {
    if (self.navigationController) {
        BMKCitySearchOption *searchOption = [[BMKCitySearchOption alloc] init];
        NSString *keyword = self.servesAdressView.adressTextField.text;
        if (keyword&& ![@"" isEqualToString:keyword]) {
            searchOption.keyword = keyword;
        }
        ABCommonAdressViewController *commonAdressViewController = [ABCommonAdressViewController commonAdressViewController:searchOption];
        commonAdressViewController.delegate = self;
        [self.navigationController pushViewController:commonAdressViewController animated:YES];
    }
}

#pragma mark - 确认
- (void)confirmButtonDidClick {
    
    if ([@"" isEqualToString:self.servesAdressView.adressTextField.text]) {
        [CustomToast showDialog:@"请输入小区、街道、大厦名称" time:1.5];
        return;
    }
    
    if ([@"" isEqualToString:self.servesAdressView.adressDetailTextField.text]) {
        [CustomToast showDialog:@"请输入详细门牌号" time:1.5];
        return;
    }
    if (self.tempLocation) {    // 联想词获取的对象
        self.location = self.tempLocation;
    } else if (self.servesAdressView.location) {   // 历史记录获取的对象
        self.location = self.servesAdressView.location;
    } 
    self.location.no = self.servesAdressView.adressDetailTextField.text;
    
//    // 1. 创建对象
//    [[ABHistoryLocations sharedHistoryLocations] saveLocation:self.location];
//    
//    NSMutableArray <ABLocation *> *locations = [ABHistoryLocations sharedHistoryLocations].getHistoryLocations;
//    ABLog(@"locations:%@",locations);
    
    // 执行代理，回调数据
    if ([self.servesAdressDelegate respondsToSelector:@selector(setAdressWithlocation:)]) {
        [self.servesAdressDelegate setAdressWithlocation:self.location];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - chosedCommonAdressDelegate
- (void)chosedCommonAdress:(BMKPoiInfo *)poiDetailResult {
    self.tempLocation = [[ABLocation alloc] init];
    self.tempLocation.name = poiDetailResult.name;
    self.tempLocation.address = poiDetailResult.address;
    CLLocationCoordinate2D pt = poiDetailResult.pt;    
    self.tempLocation.latitude = [NSString stringWithFormat:@"%lf",pt.latitude];
    self.tempLocation.longitude = [NSString stringWithFormat:@"%lf",pt.longitude];
    self.tempLocation.city = [poiDetailResult.city substringToIndex:poiDetailResult.city.length - 1];
    
    self.servesAdressView.adressTextField.text = self.tempLocation.name;
}

#pragma mark - 懒加载
- (ABServesAdressView *)servesAdressView {
    if (!_servesAdressView) {
        _servesAdressView = [ABServesAdressView servesAdressViewWithFrame:CGRectMake(0, SIZE_HEIGHT_NAVIGATIONBAR, ScreenWidth, ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR) isNeedHistory:self.isNeededHistory];
        // 跳转到联想词界面
        [_servesAdressView.adressButton addTarget:self action:@selector(jumpToABCommonAdressViewController) forControlEvents:UIControlEventTouchUpInside];
        [_servesAdressView.confirmButton addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        _servesAdressView.viewController = self;
    }
    return _servesAdressView;
}

@end
