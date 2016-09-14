//
//  ABHomeViewController.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/15.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABHomeViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "XRCarouselView.h"
#import "ABNetworkManager.h"
#import "CustomToast.h"
#import "UIView+Extention.h"
#import "ABHomeView.h"
#import "HFHWebViewController.h"
#import "UIButton+Extention.h"
#import "ABFirstClassServesCollectionView.h"
#import "ABCommonServesCollectionView.h"
#import "ABServesProgressScrollView.h"
#import "ABCustomerServiceView.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "ABCity.h"
#import "ABCustomerPickerView.h"
#import "ABButtonLeftTitleRightImage.h"
#import "ABCityButton.h"
#import "UILabel+Extention.h"
#import "UIImageView+Extention.h"

#define SIZE_HEIGHT_CAROUSELVIEW 180 // 轮播组件高度
#define PADDING_TOP_LOCATIONBUTTON 13 // ‘gps定位按钮’距离父控件'上边距'
#define PADDING_LEFT_LOCATIONBUTTON 13 // ‘gps定位按钮’距离父控件'左边距'
#define SIZE_HEIGHT_FIRSTCLASSSERVESCOLLECTIONVIEW 113  // ‘一级服务项’视图 ‘高度’
#define SIZE_HEIGHT_SEP1 10 // 分割视图1的高度
#define SIZE_HEIGHT_SEP2 10 // 分割视图2的高度
#define SIZE_WIDTH_COMMONSERVESCOLLECTIONVIEWCELL  ScreenWidth//‘commonServesCollectionViewCell’宽度
#define SIZE_HEIGHT_COMMONSERVESCOLLECTIONVIEWCELL (ScreenWidth*6/13)//‘commonServesCollectionView’高度
//#define SIZE_HEIGHT_COMMONSERVESCOLLECTIONVIEW ScreenWidth  // ‘commonServesCollectionView’视图 ‘高度’
#define PADDING_TOP_COMMONSERVESCOLLECTIONVIEW 25 // ‘commonServesCollectionView’距离分割线'上边距'
#define PADDING_LINE_COMMONSERVESCOLLECTIONVIEW 5 // ‘commonServesCollectionView’的‘行间距’
#define COUNT_LINE_COLLECTIONVIEW 3 // collectionView每行显示个数
#define TIME_DELAY_CAROUSEVIEW 3 // 轮播组件轮播的间隔时间，单位s
#define SIZE_HEIGHT_SERVESPROGRESSSCROLLVIEW (75 + 15 * 2) // ‘流程视图’高度
#define SIZE_HEIGHT_SERVESPROGRESSSCROLLVIEW_IPHONE6PLUS (92.5 + 10 * 2) // ‘流程视图’高度
#define SIZE_HEIGHT_SERVESPROGRESSSCROLLVIEW_PHONE5 (75  + (10 / 4 * 3) * 2 ) // IPhone5下流程图的高度

#define SIZE_HEIGHT_CUSTOMERSERVICEVIEW 31 // ‘客服区域’视图高度
#define SIZE_HEIGHT_SELECTEDVIEW 180 // 选择城市弹出的视图的高度‘’
// 定位处于关闭状态
#define LocationClosed [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied

// 定位处于开启状态
#define LocationAccessed [CLLocationManager locationServicesEnabled] &&([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)



#define TIME_MAX 10   // 倒计时上限 到达后提示‘定位失败’
#define TIME_MIN 1   // 倒计时下限

@interface ABHomeViewController ()<XRCarouselViewDelegate,ABCustomerPickerViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;   // scrollView
@property(nonatomic,strong) XRCarouselView *carouselView;   // 轮播组件
@property(nonatomic,strong) NSArray *links; // 轮播图片点击跳转地址数组
@property(nonatomic,strong) UIButton *locatonButton;    // gps定位按钮
@property(nonatomic,strong) ABCityButton *cityButton;   // 城市按钮
@property(nonatomic,strong) UIView *sep1;   // 分割视图1
@property(nonatomic,strong) UIView *sep2;   // 分割视图2
@property(nonatomic,strong) UIButton *servesButton; // ‘常用服务’显示视图
@property(nonatomic,strong) ABCustomerServiceView *customerServiceView; // ‘客服区域’视图
@property(nonatomic,strong) NSArray *cities;  // 服务的城市列表
@property(nonatomic,strong) ABCustomerPickerView *cityPickerView;  // 城市选择器
@property (nonatomic,strong) UIView *backView;  // 城市选择器北京视图
@property (nonatomic,strong) UIView *selectView;    // 城市选择器父视图
@property (nonatomic, copy) NSString *choosedCityName;  // 选择的城市名称
@property (nonatomic, copy) NSString *locationCityName;  // 定位城市的名称
@property(nonatomic,assign) BOOL isAccessWithServiceCity;  // 是否属于服务城市

// 百度定位对象
@property(nonatomic,strong) BMKLocationService *locService;
@property(nonatomic,strong) BMKGeoCodeSearch *searcher;
@property(nonatomic,strong) CLLocationManager *locationManger;

@property(nonatomic,strong) UIAlertView *noServiceAlertView;    // 城市未开通服务提示
@property(nonatomic,strong) UIView *requestFailedView;  // 请求失败View
@property(nonatomic,strong) NSArray *services;


// ‘一级服务项’视图
@property(nonatomic,strong) ABFirstClassServesCollectionView *firstClassServesCollectionView;
// '常用服务'视图
@property(nonatomic,strong) ABCommonServesCollectionView *commonServesCollectionView;
// ‘服务流程内容’
@property(nonatomic,strong) ABServesProgressScrollView *servesProgressScrollView;

// 加载数据完成flag
// 加载轮播数据是否成功
@property(nonatomic,assign) BOOL loadCarouselViewDataSuccessed;
// 加载'常用服务'视图数据是否成功
@property(nonatomic,assign) BOOL loadcommonServesCollectionViewDataSuccessed;

@end

@implementation ABHomeViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KWhiteColor;
    
    // 1. 设置导航栏
    [self setNavigationBarItem:@"i 闪服"];
//   UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 2. 加载 ‘首页信息’
    [self loadHomeViewData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 3. 请求城市列表
    [self showAllCityList];
    
    // 4. 定位提示只在客户端启动的时候提示一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 4.1 定位
        if ([self canLocate]) {
            //初始化BMKLocationService
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate = self;
            //启动LocationService
            [_locService startUserLocationService];
            
            _searcher = [[BMKGeoCodeSearch alloc]init];
            _searcher.delegate = self;
            [self countDown];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打开定位开关"
                                                                message:@"定位服务未开启，请进入【设置】>【隐私】>【定位服务】中打开开关，并允许闪服使用定位服务"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"去设置", nil];
            alertView.tag = 1102;
            [alertView show];
        }
    });
    
    // 监听刷新通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendRequsetAgain) name:NOTIFICATION_RELOADHOMEVIEW object:nil];
}

#pragma mark -UIAlertView 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 1102) {
        return;
    }
    if (buttonIndex == 1) {
        if(iOS8) {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication]openURL:url];
            return;
        }
        
//        NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
//        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 状态栏显示白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; 
}

#pragma mark - 定位时长10秒
- (void)countDown {
    __block int timeout = TIME_MAX; // 倒计时时间:10~1秒
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout < TIME_MIN){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 定位可用的情况下 北京昌平区回龙观
                if (!(LocationClosed)) {
//                    ABLog(@"self.city%@",self.city);
                    // 如果定位成功直接返回
                    if (![@"" isEqualToString:self.locationCityName] && self.locationCityName.length > 0) {
                        return ;
                    } else {
                        // 弹窗提示“定位失败，”显示为默认城市北京；
                        [self.cityButton setTitle:self.choosedCityName forState:UIControlStateNormal];
                        [CustomToast showDialog:@"定位失败" time:1.5];
                    }
                }
            });
        } else {
            timeout--;
            if (LocationClosed){
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    ABLog(@"定位功能不可用，提示用户或忽略");
                    // 弹窗提示“定位失败，”显示为默认城市北京；
                    [self.cityButton setTitle:self.choosedCityName forState:UIControlStateNormal];
                    [CustomToast showDialog:@"定位失败" time:1.5];
                });
            }
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    // 坐标更新的时候调用反地理编码
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
        ABLog(@"反geo检索发送成功");
    }
    else
    {
        ABLog(@"反geo检索发送失败");
    }
}

-(void)startUserLocationService {
    ABLog(@"startUserLocationService");
}

#pragma mark - BMKGeoCodeSearchDelegate
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        // 在此处理正常结果
        // 停止调用百度定位服务
        [_locService stopUserLocationService];
        
        ABLog(@"定位城市是:%@",result.addressDetail.city);
        // 赋值
        NSString *city = result.addressDetail.city;
        
        self.locationCityName = [city substringToIndex:city.length - 1];
        
        if (self.cities && self.cities.count > 0) {
            for (NSDictionary *city in self.cities) {
                NSString *name = city[@"name"];
                if ([name isEqualToString:self.locationCityName]) {
                    self.isAccessWithServiceCity = YES;
                    [self.cityButton setTitle:self.locationCityName forState:UIControlStateNormal];
                    [self.cityButton sizeToFit];
                    
                    // 定位成功就把‘定位城市’设置为‘选择城市’
                    self.choosedCityName = self.locationCityName;
                    return;
                }
            }
            // 弹框提示 - 定位的城市不属于服务城市
            [self.noServiceAlertView show];
            self.isAccessWithServiceCity = NO;
            return;
        }
    }
    else {
        
        // 默认城市为北京
        self.choosedCityName = @"北京";
        ABLog(@"抱歉，未找到结果");
    }
}

#pragma mark - 设置UI
- (void)setupUI {
    
    // 1. 添加控件
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.locatonButton];
    [self.scrollView addSubview:self.cityButton];
    [self.scrollView addSubview:self.sep1];
    [self.scrollView addSubview:self.servesButton];
    [self.scrollView addSubview:self.firstClassServesCollectionView];
    _firstClassServesCollectionView.viewController = self;
    [self.scrollView addSubview:self.commonServesCollectionView];
    [self.scrollView addSubview:self.servesProgressScrollView];
    [self.scrollView addSubview:self.sep2];
    
    // 2. 布局
    // 2.1 scrollView
    self.scrollView.width = ScreenWidth;
    self.scrollView.height = ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR - SIZE_HEIGHT_TABBAR;
    self.scrollView.x = 0;
    self.scrollView.y = SIZE_HEIGHT_NAVIGATIONBAR;
    
    // 2.2 ‘轮播视图’carouselView在laodADVdata方法里设置了
    
    // 2.3 gps按钮
    self.locatonButton.y = PADDING_TOP_LOCATIONBUTTON;
    self.locatonButton.x = PADDING_LEFT_LOCATIONBUTTON;
    
    // 2.4 城市按钮
    self.cityButton.centerY = self.locatonButton.centerY;
    self.cityButton.x = self.locatonButton.right + 7;
    
    // 2.4 灰色分割视图1
    self.sep1.width = ScreenWidth;
    self.sep1.height = SIZE_HEIGHT_SEP1;
    self.sep1.x = 0;
    self.sep1.y = self.firstClassServesCollectionView.bottom;
    
    // 2.5 ‘常用服务’灰色视图
    self.servesButton.width = self.servesButton.width + 2 * 36;
    self.servesButton.height = 20;
    self.servesButton.centerX = self.view.centerX;
    self.servesButton.y = self.sep1.bottom - 5;
    
    // 2.6‘一级服务项分类视图’在firstClassServesCollectionView（get方法）方法里完成了
    
    // commonServesCollectionView的行数
    NSInteger lineCount = 0;
    if (self.services.count % 3 == 0) {
        lineCount = self.services.count / 3;
    } else {
        lineCount = self.services.count / 3 + 1;
    }
    
    // ‘常用服务视图’设置数据
    self.commonServesCollectionView.height = SIZE_HEIGHT_COMMONSERVESCOLLECTIONVIEWCELL*self.services.count + PADDING_LINE_COMMONSERVESCOLLECTIONVIEW*(self.services.count-1);
    self.commonServesCollectionView.services = self.services;
    
    // ‘常用服务视图’布局位置
    self.commonServesCollectionView.x = 0;
    self.commonServesCollectionView.y = self.sep1.bottom + PADDING_TOP_COMMONSERVESCOLLECTIONVIEW;
    
    // 分割视图2
    self.sep2.width = ScreenWidth;
    self.sep2.height = SIZE_HEIGHT_SEP2;
    self.sep2.x = 0;
    self.sep2.y = self.commonServesCollectionView.bottom;
    
    // 流程视图
    self.servesProgressScrollView.x = 0;
    self.servesProgressScrollView.y = self.sep2.bottom;
    
    // 客服视图
    _customerServiceView = [[ABCustomerServiceView alloc] initWithFrame:CGRectMake(0, self.servesProgressScrollView.bottom, ScreenWidth, SIZE_HEIGHT_CUSTOMERSERVICEVIEW)];
    _customerServiceView.viewController = self;
    [self.scrollView addSubview:_customerServiceView];
    
    // 最后设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, _customerServiceView.bottom);
}

#pragma mark - 加载轮播数据
- (void)laodADVdata {
    
    NSString *urlStr = @"app/v1.0.1/adv";
    
    [CustomToast showWatingInView:self.view];
    [KABNetworkManager POST:urlStr parameters:nil success:^(id responseObject) {
        [CustomToast hideWatingInView:self.view];
        if (self.requestFailedView.superview) {
            [self.requestFailedView removeFromSuperview];
        }
        if ([@"200" isEqualToString:responseObject[@"errcode"]]) {
            self.loadCarouselViewDataSuccessed = YES;
            if (self.loadCarouselViewDataSuccessed && self.loadcommonServesCollectionViewDataSuccessed) {
                // 设置UI
                [self setupUI];
            }
            
            NSArray *images = responseObject[@"images"];
            NSMutableArray *imageurls = [NSMutableArray arrayWithCapacity:images.count];
            NSMutableArray *links = [NSMutableArray arrayWithCapacity:images.count];
            for (NSDictionary *dict in images) {
                NSString *imageurl = dict[@"imageurl"];
                NSString *link = dict[@"link"];
                [imageurls addObject:imageurl];
                [links addObject:link];
            }
            self.links = links.mutableCopy;
            // 初始化轮播视图
            _carouselView = [XRCarouselView carouselViewWithFrame:CGRectMake(0, 0, ScreenWidth, SIZE_HEIGHT_CAROUSELVIEW) imageArray:imageurls.mutableCopy];
            ABLog(@"_carouselView%@",_carouselView);
            // 设置每张图片的停留时间
            _carouselView.time = TIME_DELAY_CAROUSEVIEW;
            // 设置分页控件的图片,不设置则为系统默认
            [_carouselView setPageImage:[UIImage imageNamed:@"首页-轮播1"] andCurrentImage:[UIImage imageNamed:@"首页-轮播选中"]];
            _carouselView.delegate = self;
            // 设置分页控件的位置
            _carouselView.pagePosition = PositionBottomCenter;
            [self.scrollView addSubview:self.carouselView];
            
            // gps定位按钮置前
            [self.scrollView bringSubviewToFront:self.locatonButton];
            // 城市按钮
            [self.scrollView bringSubviewToFront:self.cityButton];
            
        }
    } failure:^(id object) {
        self.loadCarouselViewDataSuccessed = NO;
        [CustomToast hideWatingInView:self.view];
        if (!self.requestFailedView.superview) {
            [self.view addSubview:self.requestFailedView];
        }
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
        ABLog(@"object%@",object);
    }];
}

#pragma mark - 加载首页服务信息
- (void)loadHomeViewData {
    
    NSString *urlStr = @"service/v1.0.1/topface";
    
    [CustomToast showWatingInView:self.view];
    [KABNetworkManager POST:urlStr parameters:nil success:^(id responseObject) {
        [CustomToast hideWatingInView:self.view];
        if ([@"200" isEqualToString:responseObject[@"errcode"]]) {
            self.loadcommonServesCollectionViewDataSuccessed = YES;
            if (self.loadcommonServesCollectionViewDataSuccessed) {
                self.services = responseObject[@"services"];
                // 加载轮播数据
                [self laodADVdata];
            }
        }
    } failure:^(id object) {
        self.loadcommonServesCollectionViewDataSuccessed = NO;
        [CustomToast hideWatingInView:self.view];
        if (!self.requestFailedView.superview) {
            [self.view addSubview:self.requestFailedView];
        }
        if (isDisConnectedNetwork) {
            [CustomToast showNetworkError];
        }
        ABLog(@"object%@",object);
    }];
}

#pragma mark - XRCarouselViewDelegate
- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index {
    if (isDisConnectedNetwork) {
        [self.carouselView clearDiskCache];
    }
    NSString *urlStr = self.links[index];
    if (urlStr && ![@"" isEqualToString:urlStr]) {
        [HFHWebViewController showWithController:self withUrlStr:urlStr withTitle:@"i 闪服" hidesBottomBarWhenPushed:YES];
    } else {
        ABLog(@"该图片没有对应的跳转地址 urlStr:%@", urlStr);
    }
}


#pragma  mark - 城市列表
- (void)showAllCityList {
    
    // 本地没有则走接口 - 启动的时候都要请求服务城市列表
    NSString *urlStr = @"service/city/v1.0.1/all";
    
    [KABNetworkManager POST:urlStr parameters:nil success:^(id responseObject) {
        if ([@"200" isEqualToString:responseObject[@"errcode"]]) {
            ABLog(@"返回城市列表成功");
            self.cities = responseObject[@"cities"];
            // 持久化
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"cities"] forKey:USERDEFAULTKEY_SERVICECITIES];
        }
    } failure:^(id object) {
        if (isDisConnectedNetwork) {
            self.cities = @[@{@"name":@"北京",@"province":@"北京",@"service_range":@"城市开通服务的范围"}];
        }
        ABLog(@"返回城市列表失败:object:%@",object);
    }];
}

#pragma mark - 判断能否定位
- (BOOL)canLocate {
    if ([CLLocationManager locationServicesEnabled]&&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) { // 定位可用
            
            ABLog(@"location：能定位");
            return YES;
        }
    ABLog(@"location：不能定位");
    return NO;
}

#pragma mark - 弹出城市选择器
- (void)showcitiesPickerView {
    
    [self.view addSubview:self.backView];
    // 先确定弹出的时候显示哪个城市
    [self checkCityPickerViewWhenShow];
    self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, SIZE_HEIGHT_SELECTEDVIEW);
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, self.view.frame.size.height-SIZE_HEIGHT_SELECTEDVIEW - SIZE_HEIGHT_TABBAR, self.view.frame.size.width, SIZE_HEIGHT_SELECTEDVIEW);
        self.cityButton.iconImageView.transform = CGAffineTransformRotate(self.cityButton.iconImageView.transform, -M_PI);
    } completion:^(BOOL finished) {
        //CGRectMake(0, _backView.frame.size.height-180, self.view.frame.size.width, 180)
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma - mark - 城市选择器：取消、确定按钮
- (void)btnAction:(UIButton *)btn{
    ABLog(@"%ld",(long)btn.tag);
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
        self.cityButton.iconImageView.transform = CGAffineTransformRotate(self.cityButton.iconImageView.transform, M_PI);
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
    // 点击确定
    if(2==btn.tag){
//        NSInteger row=[self.pickView selectedRowInComponent:0];
//        if (0==_secectIndex) {
//            _startTimeLabel.text=[self p_getTimeStrWithIndex:row];
//        }else if (1==_secectIndex){
//            _endTimeLabel.text=[self p_getTimeStrWithIndex:row];
//        }
        
        [self.cityButton setTitle:self.choosedCityName forState:UIControlStateNormal];
        [self.cityButton sizeToFit];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.choosedCityName forKey:NOTIFICATION_CHOOSEDCITY];
        
        // 选择城市后就取消定位
        [_locService stopUserLocationService];
    }
}

#pragma mark - 移除遮罩
- (void)tap{
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
        self.cityButton.iconImageView.transform = CGAffineTransformRotate(self.cityButton.iconImageView.transform, M_PI);
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
}

#pragma mark - ABCustomerPickerViewDelegate
- (void)didSelectedCustomerPickerView:(NSString *)selectedStr {
    
    // 记录所选城市 - 点击确定的时候才进行更新
    self.choosedCityName = selectedStr;
//    [self.cityButton setTitle:selectedStr forState:UIControlStateNormal];
//    [self.cityButton sizeToFit];
}

#pragma mark - 确定选择器弹出时的城市
- (void)checkCityPickerViewWhenShow {
    for (int i = 0; i < self.cities.count; ++i) {
        NSDictionary *dict = self.cities[i];
        if ([dict[@"name"] isEqualToString:self.choosedCityName]) {
            [_cityPickerView selectRow:i inComponent:0 animated:NO];
            return;
        }
    }
}

#pragma mark - 再次请求网络
- (void)sendRequsetAgain {
    if (self.requestFailedView.superview) {
        [self.requestFailedView removeFromSuperview];
    }
    // 加载首页数据
    [self loadHomeViewData];
    
    // 加载城市列表
    [self showAllCityList];
}

-(void)dealloc {
    [self.carouselView clearDiskCache];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UIButton *)locatonButton {
    if (!_locatonButton) {
        _locatonButton = [UIButton buttonWithTitle:nil color:nil fontSize:0 imageName:@"我的订单-GPS"];
    }
    return _locatonButton;
}

- (ABCityButton *)cityButton {
    if (!_cityButton) {
        self.choosedCityName = @"北京";
        _cityButton = [ABCityButton cityButtonWithCityName:self.choosedCityName iconImageName:@"首页-定位箭头"];
        _cityButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cityButton addTarget:self action:@selector(showcitiesPickerView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cityButton;
}

- (ABCustomerPickerView *)cityPickerView {
    if (!_cityPickerView) {
        _cityPickerView = [ABCustomerPickerView customerPickerViewWithArray:self.cities];
    }
    return _cityPickerView;
}

- (ABFirstClassServesCollectionView *)firstClassServesCollectionView {
    if (!_firstClassServesCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(ScreenWidth / COUNT_LINE_COLLECTIONVIEW, SIZE_HEIGHT_FIRSTCLASSSERVESCOLLECTIONVIEW);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _firstClassServesCollectionView = [[ABFirstClassServesCollectionView alloc] initWithFrame:CGRectMake(0, SIZE_HEIGHT_CAROUSELVIEW, ScreenWidth, SIZE_HEIGHT_FIRSTCLASSSERVESCOLLECTIONVIEW) collectionViewLayout:flowLayout];
    }
    return _firstClassServesCollectionView;
}

- (UIView *)sep1 {
    if (!_sep1) {
        _sep1 = [[UIView alloc] init];
        _sep1.backgroundColor = KGrayGroundColor;
    }
    return _sep1;
}

- (UIButton *)servesButton {
    if (!_servesButton) {
        _servesButton = [UIButton buttonWithTitle:@"常用服务" color:KBlackColor fontSize:PADDING_30PX imageName:nil];
        _servesButton.backgroundColor = KGrayGroundColor;
        _servesButton.layer.borderWidth = 1;
        _servesButton.layer.borderColor = [KGrayGroundColor CGColor];
        _servesButton.layer.cornerRadius = 7;
        _servesButton.clipsToBounds = YES;
    }
    return _servesButton;
}

- (ABCommonServesCollectionView *)commonServesCollectionView {
    if (!_commonServesCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = PADDING_LINE_COMMONSERVESCOLLECTIONVIEW;
        flowLayout.minimumInteritemSpacing = 0;
        
//        flowLayout.itemSize = CGSizeMake(ScreenWidth / COUNT_LINE_COLLECTIONVIEW, SIZE_HEIGHT_COMMONSERVESCOLLECTIONVIEW);
        flowLayout.itemSize = CGSizeMake(SIZE_WIDTH_COMMONSERVESCOLLECTIONVIEWCELL, SIZE_HEIGHT_COMMONSERVESCOLLECTIONVIEWCELL);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _commonServesCollectionView.scrollEnabled = YES;
        _commonServesCollectionView = [[ABCommonServesCollectionView alloc] initWithFrame:CGRectMake(0, SIZE_HEIGHT_CAROUSELVIEW + SIZE_HEIGHT_FIRSTCLASSSERVESCOLLECTIONVIEW + SIZE_HEIGHT_SEP1 + PADDING_TOP_COMMONSERVESCOLLECTIONVIEW, ScreenWidth, SIZE_HEIGHT_COMMONSERVESCOLLECTIONVIEWCELL*self.services.count) collectionViewLayout:flowLayout];
        __weak typeof(self) weakSelf = self;
        _commonServesCollectionView.viewController = self;
//        _commonServesCollectionView.backgroundColor = [UIColor redColor];

    }
    return _commonServesCollectionView;
}

- (UIView *)sep2 {
    if (!_sep2) {
        _sep2 = [[UIView alloc] init];
        _sep2.backgroundColor = KGrayGroundColor;
    }
    return _sep2;
}

- (ABServesProgressScrollView *)servesProgressScrollView {
    if (!_servesProgressScrollView) {
        _servesProgressScrollView = [[ABServesProgressScrollView alloc] init];
        if (iPhone5) {
        _servesProgressScrollView.height = SIZE_HEIGHT_SERVESPROGRESSSCROLLVIEW_PHONE5;
        } else if(iPhone6Plus){
        _servesProgressScrollView.height = SIZE_HEIGHT_SERVESPROGRESSSCROLLVIEW_IPHONE6PLUS;
        } else {
            _servesProgressScrollView.height = SIZE_HEIGHT_SERVESPROGRESSSCROLLVIEW;
        }
        _servesProgressScrollView.width = ScreenWidth;
    }
    return _servesProgressScrollView;
}

- (UIView *)backView{
    
    if (!_backView) {
        _backView=[[UIView alloc] initWithFrame:self.view.bounds];
        _backView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.15];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_backView addGestureRecognizer:tap];
        
        _selectView=[[UIView alloc] init];
        _selectView.backgroundColor=[UIColor whiteColor];
        _selectView.frame=CGRectMake(0, _backView.frame.size.height - SIZE_HEIGHT_SELECTEDVIEW - SIZE_HEIGHT_TABBAR, self.view.frame.size.width, SIZE_HEIGHT_SELECTEDVIEW);
        _selectView.backgroundColor=[UIColor whiteColor];
        [_backView addSubview:_selectView];
        
        UIButton *btn1=[[UIButton alloc] init];
        btn1.tag=1;
        btn1.frame=CGRectMake(0, 0, 50, 40);
        [btn1 setTitle:@"取消" forState:UIControlStateNormal];
        btn1.titleLabel.font=[UIFont systemFontOfSize:17.0];
        [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn1];
        
        UIButton *btn2=[[UIButton alloc] init];
        btn2.tag=2;
        btn2.frame=CGRectMake(_backView.frame.size.width-50, 0, 50, 40);
        [btn2 setTitle:@"确定" forState:UIControlStateNormal];
        btn2.titleLabel.font=[UIFont systemFontOfSize:17.0];
        [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn2];
        
        // 城市pickerView
        self.cityPickerView.frame=CGRectMake(0, 30, _selectView.frame.size.width, _selectView.frame.size.height - 30);
        self.cityPickerView.showsSelectionIndicator = YES;
        
        [_cityPickerView selectRow:self.cities.count / 2 inComponent:0 animated:YES];
        self.cityPickerView.backgroundColor=[UIColor whiteColor];
        self.cityPickerView.customerPickerViewDelegate = self;
        [_selectView addSubview:self.cityPickerView];
    }
    return _backView;
}

- (UIAlertView *)noServiceAlertView {
    if (!_noServiceAlertView) {
        _noServiceAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"城市尚未开通，请您耐心等待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
    return _noServiceAlertView;
}

- (UIView *)requestFailedView {
    if (!_requestFailedView) {
        _requestFailedView = [[UIView alloc] init];
        _requestFailedView.backgroundColor = kColorBackground;
        _requestFailedView.frame = CGRectMake(0, SIZE_HEIGHT_NAVIGATIONBAR, ScreenWidth, ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR - SIZE_HEIGHT_TABBAR);
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

@end
