//
//  ABCommonAdressViewController.m
//  flashServes
//
//  Created by 002 on 16/3/23.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABCommonAdressViewController.h"
#import <MapKit/MapKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import "HFHTextField.h"
#import "UIView+Extention.h"
#import "UIButton+Extention.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABCommonAdressCell.h"
#import "ABGetAdressFailedView.h"
#import "ABCommonAdressDefaultView.h"
#import "CustomToast.h"
#import "UIViewController+CustomNavigationBar.h"

#define ReusableCellWithIdentifier @"ReusableCellWithIdentifier" // tableview的可重用id

#define PADDING_LEFT_BACKBUTTON 5    // ‘返回按钮’按钮距离当前‘自定义导航栏’左边间距
#define PADDING_RIGHT_ADRESSTEXTFIELD 15 // ‘地址输入框’按钮距离当前‘自定义导航栏’右边边间距
#define WIDTH_BACKBUTTON 44 // 返回按钮的宽高
#define HEIGHT_ADRESSTEXTFIELD 30 // ‘地址输入框’的高
#define HEIGHT_STATUSBAR 22 // 状态栏高度
#define HEIGHT_NAVIGATIONBAR 64 // 自定义导航栏高度
//#define CENTERY_VIEW (HEIGHT_STATUSBAR + (HEIGHT_NAVIGATIONBAR - HEIGHT_STATUSBAR) / 2) // 产品要求按钮布局的垂直中心点
#define HEIGHT_TABLEVIEW_ROW 55   // tableview行高
#define COUNT_TABLEVIEW_MAX 10 // tableview每行显示最多的个数

@interface ABCommonAdressViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,BMKPoiSearchDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) HFHTextField *adressTextField;  // 地址输入框
@property(nonatomic,strong) UITableView *tableView; // 展示联想词列表的tableview
@property(nonatomic,strong) NSArray *poiInfoList;  // 关键词检索结果集
@property (nonatomic, copy) NSString *city; // 所选城市

@property(nonatomic,strong) BMKPoiSearch *poiSearch;    // 检索管理对象
//@property(nonatomic,strong) ABGetAdressFailedView *adressFaileView; // 地址加载失败提示View
@property(nonatomic,strong) ABCommonAdressDefaultView *adressFaileView; // 地址加载失败提示View
@property(nonatomic,strong) UIView *sep1;   // 分割线1
@property(nonatomic,strong) NSArray *cities;    // 本地缓存的城市列表字典
//@property(nonatomic,strong) NSMutableArray *cityNames;  // 城市列表名称数组 - // 测试所选城市不再服务城市而添加 - code1

@property(nonatomic,strong) UIAlertView *alertView; // 选择地址属于未开通城市
@property(nonatomic,assign) CGFloat contentOffsetY; // 键盘弹出后scrollView需要滚动的值
@property(nonatomic,assign) BOOL isAdressTextFieldEmpty;    // 地址输入框是否为空

@end

@implementation ABCommonAdressViewController


- (instancetype)initWithSearchOption:(BMKCitySearchOption *)searchOption {
    
    if (self = [super init]) {
        if (searchOption) {
            NSString *city = [[NSUserDefaults standardUserDefaults] stringForKey:NOTIFICATION_CHOOSEDCITY];
            if (city && ![@"" isEqualToString:city]) {
                searchOption.city = [NSString stringWithFormat:@"%@市",city];
            } else {
                searchOption.city = @"北京市";
            }
            self.searchOption = searchOption;
            if (![@"" isEqualToString:searchOption.keyword] && searchOption.keyword) {
                self.adressTextField.text = searchOption.keyword;
            }
        }
    }
    return self;
}

+ (instancetype)commonAdressViewController:(BMKCitySearchOption *)searchOption {
    return [[self alloc] initWithSearchOption:searchOption];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置导航栏
    [self setNavigationBarItem:@"服务地址" leftButtonIcon:@"返回"];
    
    // 2. 设置UI
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification"
                                               object:self.adressTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 1. 自动弹出键盘
    [self.adressTextField becomeFirstResponder];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 加载完毕后如果有值就显示联想词列表
    if (self.searchOption && ![@"" isEqualToString:self.searchOption.keyword]) {
        if (self.tableView.superview == nil) {
            [self.view addSubview:self.tableView];
        }
        [self poiSearch:self.searchOption];
    }
}

//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.poiSearch.delegate = nil;
}

// 布局子控件
//- (void)setupUI {
//    
//    // 自定义导航栏
//    [self setNavigationBarItem:nil leftButtonIcon:@"返回"];
//    
//    // 1. 添加控件
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.adressTextField];
//    [self.view addSubview:self.sep1];    
//    
//    // 2. 布局 - 有关中心点的布局都必须先设置宽高在设置位置
//    self.adressTextField.width = ScreenWidth - PADDING_RIGHT_ADRESSTEXTFIELD;
//    self.adressTextField.height = HEIGHT_ADRESSTEXTFIELD;
//    self.adressTextField.x = PADDING_RIGHT_ADRESSTEXTFIELD;
//    self.adressTextField.y = SIZE_HEIGHT_NAVIGATIONBAR;
//    
//    self.sep1.width = ScreenWidth;
//    self.sep1.height = 1;
//    self.sep1.x = 0;
//    self.sep1.y = self.adressTextField.bottom;
//}

- (void)setupUI {
    // 自定义导航栏
    [self setNavigationBarItem:nil leftButtonIcon:@"返回"];
    
    // 1. 添加控件
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationBar addSubview:self.adressTextField];
    
    // 2. 布局 - 有关中心点的布局都必须先设置宽高在设置位置
    self.adressTextField.width = ScreenWidth - WIDTH_BACKBUTTON - PADDING_RIGHT_ADRESSTEXTFIELD;
    self.adressTextField.height = HEIGHT_ADRESSTEXTFIELD;
    self.adressTextField.x = WIDTH_BACKBUTTON;
    self.adressTextField.centerY = 42;

}

#pragma mark - UITextFieldDelegate
-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    if (![@"" isEqualToString:textField.text]) {
        self.isAdressTextFieldEmpty = NO;
        NSString *keyWord = textField.text;
        
//        if (self.tableView.superview == nil) {
//            [self.view addSubview:self.tableView];
//        }
        
        self.searchOption.keyword = keyWord;
        
        [self poiSearch:self.searchOption];
    } else if ([@"" isEqualToString:textField.text] || (textField.text == nil)) {
        self.isAdressTextFieldEmpty = YES;
        if (self.tableView.superview) {
            [self.tableView removeFromSuperview];
        }
        
        if (self.adressFaileView.superview) {
            [self.adressFaileView removeFromSuperview];
        }
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isAdressTextFieldEmpty) {
        return 0;
    } else {
        return 1;
    }    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 动态改变tableView的高度
    NSInteger count = self.poiInfoList.count;
    CGFloat tableViewMaxHeight = ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR - HEIGHT_ADRESSTEXTFIELD;
    if (count * HEIGHT_TABLEVIEW_ROW > tableViewMaxHeight) {
        self.tableView.height = tableViewMaxHeight;
    }
//    self.sep2.bottom = self.tableView.height;
    return self.poiInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. 取cell
    ABCommonAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:ReusableCellWithIdentifier];
    if (!cell) {
        cell = [ABCommonAdressCell commonAdressCell:tableView];
    }
    
    // 分割线
    UIView *sep = [[UIView alloc] init];
    sep.backgroundColor = KColorLine;
    [cell.contentView addSubview:sep];
    sep.width = ScreenWidth - PADDING_30PX;
    sep.height = 1;
    sep.x = PADDING_30PX;
    sep.bottom = cell.contentView.bottom;
    // 2. 取数据
    BMKPoiInfo *poiInfo = self.poiInfoList[indexPath.row];
    
    cell.nameLabel.text = poiInfo.name;
    cell.adressLabel.text = poiInfo.address;
    
    // 特殊处理 最后一个cell的时候分割线和屏幕不留间隙
    if (indexPath.row == self.poiInfoList.count - 1) {
        sep.x = 0;
        sep.width = ScreenWidth;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 1. 取数据
    BMKPoiInfo *poiInfo = self.poiInfoList[indexPath.row];
    
    NSString *cityName = [poiInfo.city substringToIndex:poiInfo.city.length - 1];
    BOOL isServiceCity = NO;
    for (NSDictionary *dict in self.cities) {
        if ([cityName isEqualToString:dict[@"name"]]) {
            isServiceCity = YES;
            break;
        }
    }
    
//    // 测试所选城市不再服务城市而添加 - code3
//    for (NSString *name in self.cityNames) {
//        if ([cityName isEqualToString:name]) {
//            isServiceCity = YES;
//            break;
//        }
//    }
    
    if (!isServiceCity) {
        [self.alertView show];
        
        return;
    }
    
    CLLocationCoordinate2D loaction = poiInfo.pt;
    
    ABLog(@"latitude:%lf-----longitude:%lf",loaction.latitude,loaction.longitude);
    
    if ([self.delegate respondsToSelector:@selector(chosedCommonAdress:locationID:)] && self.locationID != nil && ![@"" isEqualToString:self.locationID]) {
        [self.delegate chosedCommonAdress:poiInfo locationID:self.locationID];
    } else if ([self.delegate respondsToSelector:@selector(chosedCommonAdress:)]) {                [self.delegate chosedCommonAdress:poiInfo];
    }
    
    // 2. 赋值 - 产品（晓庆）说不需要更新文本框的值
//    self.adressTextField.text = poiInfo.name;
    
    // 返回上一级界面
    [self disMiss];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.adressTextField isFirstResponder]) {
        [self.adressTextField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理
- (void)disMiss {
    // 从当前视图移除
    [self.tableView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)poiSearch:(BMKCitySearchOption *)searchOption {
    //发起检索
    searchOption.pageIndex = 0;
    searchOption.pageCapacity = COUNT_TABLEVIEW_MAX;
    BOOL flag = [self.poiSearcher poiSearchInCity:searchOption];
    if(flag)
    {
        ABLog(@"当前城市检索发送成功");
//        if (!self.tableView.superview) {
//            [self.view addSubview:self.tableView];
//        }
    }
    else
    {
        ABLog(@"当前城市检索发送失败");
    }
}

#pragma mark - BMKPoiSearchDelegate
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode;
{
    // 在此处理正常结果
    if (errorCode == BMK_SEARCH_NO_ERROR && poiResult.poiInfoList) {
        // searchOption.pageCapacity不生效，只能自己判断截取
        if (poiResult.poiInfoList.count > 10) {
            NSRange range = NSMakeRange(0, COUNT_TABLEVIEW_MAX);
            NSArray *resultArray = [poiResult.poiInfoList subarrayWithRange: range];
            self.poiInfoList = resultArray;
        } else {
            self.poiInfoList = poiResult.poiInfoList;
        }
        if (!self.tableView.superview) {
            [self.view addSubview:self.tableView];
        }
        [self.tableView reloadData];
        ABLog(@"返回结果成功");
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        ABLog(@"起始点有歧义");
    } else {
        ABLog(@"抱歉，未找到结果");
        // 移除tableView，显示提示页面
        if (self.tableView.superview) {
            [self.tableView removeFromSuperview];
        }
        if (!self.adressFaileView.superview) {
            [self.view addSubview:self.adressFaileView];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.adressTextField.text = @"";
        if (self.tableView.superview) {
            [self.tableView removeFromSuperview];
        }
    }
}

- (void)dealloc {
    // 注销通知 - 注销指定的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                name:@"UITextFieldTextDidChangeNotification"
                                                  object:nil];
}

#pragma mark - 懒加载
- (HFHTextField *)adressTextField {
    if (!_adressTextField) {
        _adressTextField = [HFHTextField textFieldWithPlaceHolder:@"请输入小区、街道、大厦名称" placeHolderSize:PADDING_30PX placeHolderPadding:PADDING_30PX leftViewImageName:nil];
        [_adressTextField setValue:KColorTextPlaceHold forKeyPath:@"_placeholderLabel.textColor"];
        _adressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _adressTextField.delegate = self;
        _adressTextField.returnKeyType = UIReturnKeyDone;
        _adressTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
        _adressTextField.layer.cornerRadius = 5;
        _adressTextField.clipsToBounds = YES;
        _adressTextField.layer.borderWidth = 1;
        _adressTextField.backgroundColor = [UIColor whiteColor];
    }
    return _adressTextField;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(self.view.x, self.navigationBar.bottom + 1, self.navigationBar.width, ScreenHeight - HEIGHT_NAVIGATIONBAR);
        _tableView.rowHeight = HEIGHT_TABLEVIEW_ROW;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (NSArray *)poiInfoList {
    if (!_poiInfoList) {
        _poiInfoList = [NSArray array];
    }
    return _poiInfoList;
}

- (BMKPoiSearch *)poiSearcher {
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc] init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}

- (void)setSearchOption:(BMKCitySearchOption *)searchOption {
    _searchOption = searchOption;
    _searchOption.pageCapacity = COUNT_TABLEVIEW_MAX;   // 不生效
    self.adressTextField.text = searchOption.keyword;
}

//- (ABGetAdressFailedView *)adressFaileView {
//    if (!_adressFaileView) {
//        _adressFaileView = [ABGetAdressFailedView getAdressFalied];
//        _adressFaileView.centerX = self.view.centerX;
//        _adressFaileView.centerY = self.view.centerY;
//    }
//    return _adressFaileView;
//}

- (ABCommonAdressDefaultView *)adressFaileView {
    if (!_adressFaileView) {
        //获得nib视图数组
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ABCommonAdressDefaultView" owner:self options:nil];
        _adressFaileView = [nib objectAtIndex:0];
        _adressFaileView.frame = self.view.frame;
        _adressFaileView.height = self.view.height - SIZE_HEIGHT_NAVIGATIONBAR - 45;
        _adressFaileView.y = SIZE_HEIGHT_NAVIGATIONBAR + SIZE_HEIGHT_TEXTFILED + 1;
    }
    return _adressFaileView;
}

- (UIView *)sep1 {
    if (!_sep1) {
        _sep1 = [[UIView alloc] init];
        _sep1.backgroundColor = KColorLine;
    }
    return _sep1;
}

- (NSArray *)cities {
    if (!_cities) {
        _cities = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTKEY_SERVICECITIES];
    }
    return _cities;
}

//// 测试所选城市不再服务城市而添加 - code2
//- (NSMutableArray *)cityNames {
//    if (!_cityNames) {
//        _cityNames = [NSMutableArray arrayWithCapacity:self.cities.count];
//        [_cityNames removeObject:@"北京"];
//    }
//    return _cityNames;
//}

- (UIAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"城市尚未开通，请您耐心等待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
    return _alertView;
}

@end
