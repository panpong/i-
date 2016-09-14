
//
//  ABFirstClassSubclassViewController.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABFirstClassSubclassViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "UIView+Extention.h"
#import "ABFirstClassSubclassTableView.h"
#import "ABNetworkManager.h"
#import "CustomToast.h"
#import "UILabel+Extention.h"
#import "UIImageView+Extention.h"

#define COUNT_LINE_COLLECTIONVIEW 3 // collectionView每行显示个数
#define SIZE_HEIGHT_FIRSTCLASSSUBCLASSCOLLECTIONVIEWCELL 60  // ‘一级服务项’cell的‘高度’

@interface ABFirstClassSubclassViewController ()

@property(nonatomic,strong) ABFirstClassSubclassTableView *firstClassSubclassTableView;
@property (nonatomic, copy) NSString *className;    // 请求的参数
@property(nonatomic,strong) NSArray<ABFirstClassSubclass *> *subclasses;    // 数据源
@property(nonatomic,strong) UIView *requestFailedView;  // 请求失败View
@property(nonatomic,assign) BOOL isLoadedDataSuccessed; // 加载数据是否成功

@end

@implementation ABFirstClassSubclassViewController

- (instancetype)initWithClassName:(NSString *)className {
    self = [super init];
    if (className && ![@"" isEqualToString:className]) {
        self.view.backgroundColor = KWhiteColor;
        [self setNavigationBarItem:className leftButtonIcon:@"返回"];
        self.className = className;
        // 进行网络请求
        [self loadData];
    }
    
    return self;
}

+ (instancetype)firstClassSubclassViewControllerWithClassName:(NSString *)className  {
    ABFirstClassSubclassViewController *firstClassSubclassViewController = [[self alloc] initWithClassName:className];
    return firstClassSubclassViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark - 网络请求
- (void)loadData {

    // 接口 service/v1.0.1/sublist
    // TODO:主席的接口文档是service/v1.0.1/subface，而实际是service/v1.0.1/sublist
    NSString *urlStr = @"service/v1.0.1/sublist";
    
    // 接口参数
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.className forKey:@"classname"];
    [CustomToast showWatingInView:self.view];
//    [CustomToast showWatingInView:[UIApplication sharedApplication].keyWindow];
    [KABNetworkManager POST:urlStr parameters:dict success:^(id responseObject) {
        [CustomToast hideWatingInView:self.view];
        if (self.requestFailedView.superview) {
            [self.requestFailedView removeFromSuperview];
        }
        // 模型转化
        if ([@"200" isEqualToString:responseObject[@"errcode"]]) {
            
            // 真数据
            NSArray *subclasses = responseObject[@"subclass"];
            
            // 假数据
            //            NSArray *subclasses = @[@{@"name" : @"test1",
            //                                      @"thumb_url" : @"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=359478407,743815024&fm=58",
            //                                      @"services" : @[@{@"id":@"1", @"name" : @"testt1",@"thumb_url" : @"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=359478407,743815024&fm=58",@"price" : @"100"}]}];
            NSMutableArray *subclassArrayM = [NSMutableArray arrayWithCapacity:subclasses.count];
            
            for (NSDictionary *dict in subclasses) {
                
                ABFirstClassSubclass *firstClassSubclass = [ABFirstClassSubclass firstClassSubclassWithDict:dict];
                
                NSArray *services = dict[@"service"];
                NSMutableArray *servicesArrayM = [NSMutableArray arrayWithCapacity:services.count];
                
                for (NSDictionary *serviceDict in services) {
                    ABFirstClassServes *service = [ABFirstClassServes firstClassServesWithDict:serviceDict];
                    [servicesArrayM addObject:service];
                }
                firstClassSubclass.service = [servicesArrayM mutableCopy];
                [subclassArrayM addObject:firstClassSubclass];
            }
            
            NSArray<ABFirstClassSubclass *> *dataArray = [subclassArrayM mutableCopy];
            self.subclasses = dataArray;
            
            // 设置UI
            [self setupUI];
            
            // 刷新tableview
            [self.firstClassSubclassTableView reloadData];
            
            ABLog(@"请求成功，subclass：%@",subclasses);
        }
        
        ABLog(@"responseObject:%@",responseObject);
    } failure:^(id object) {
        self.isLoadedDataSuccessed = NO;
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

- (void)setupUI {
    
    // 1. 添加控件
    [self.view addSubview:self.firstClassSubclassTableView];
    // 2. 布局
    // 2.1 firstClassSubclassTableView布局在get方法里设置了
    
    // 2.2
}

#pragma mark - 再次请求网络
- (void)sendRequsetAgain {
    if (!self.isLoadedDataSuccessed) {
        if (self.requestFailedView.superview) {
            [self.requestFailedView removeFromSuperview];
        }
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (ABFirstClassSubclassTableView *)firstClassSubclassTableView {
    if (!_firstClassSubclassTableView) {
        _firstClassSubclassTableView = [ABFirstClassSubclassTableView firstClassSubclassTableViewWithFrame:CGRectMake(0, SIZE_HEIGHT_NAVIGATIONBAR, ScreenWidth, ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR) firstClassSubclass:self.subclasses];
        _firstClassSubclassTableView.viewController = self;
    }
    return _firstClassSubclassTableView;
}

- (UIView *)requestFailedView {
    if (!_requestFailedView) {
        _requestFailedView = [[UIView alloc] init];
        _requestFailedView.backgroundColor = kColorBackground;
        _requestFailedView.frame = CGRectMake(0, SIZE_HEIGHT_NAVIGATIONBAR, ScreenWidth, ScreenHeight - SIZE_HEIGHT_NAVIGATIONBAR);
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
