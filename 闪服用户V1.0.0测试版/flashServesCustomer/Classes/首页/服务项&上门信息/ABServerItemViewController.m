//
//  ABServerItemViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/23.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServerItemViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABServerItemCollectionViewCell.h"
#import "ABServerItemCollectionReusableView.h"
#import "ABCollectionHeaderView.h"
#import "ABCollectionConfig.h"
#import "NSString+KYSAddition.h"
#import "KYSNetwork.h"
#import "KYSNetErrorView.h"
#import "ABDoorViewController.h"
#import "ABFirstClassSubclass.h"
#import "ABNetworkDelegate.h"
#import "ABLoginViewController.h"
#import "HFHWebViewController.h"
#import "CustomToast.h"

@interface ABServerItemViewController ()<ABCollectionHeaderViewDelegate,KYSNetErrorViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSDictionary *originDataDic;
@property(nonatomic,strong)NSArray *typeArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableDictionary *selectedDic;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *nextView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnWidth;

@property(nonatomic,strong)KYSNetErrorView *netErrorView;

@property(nonatomic,assign)NSInteger deviceCount;
@property(nonatomic,assign)BOOL hasLoadData;

@end

@implementation ABServerItemViewController


+ (ABServerItemViewController *)getServerItemViewController{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"ServerItem&Door" bundle:nil];
    ABServerItemViewController *sVC=[storyBoard instantiateViewControllerWithIdentifier:@"ABServerItemViewController"];
    return sVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _deviceCount=1;
    
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBarItem:@"服务项" leftButtonIcon:@"返回" rightButtonTitle:@"服务须知" ];
    
    // ---------------------------- by fhhe Start ------------------------------
    [self.rightButton addTarget:self action:@selector(jumpToServieGuidelines) forControlEvents:UIControlEventTouchUpInside];
    // ---------------------------- by fhhe End ------------------------------
    [self.rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //_nextBtnWidth.constant=_nextBtnWidth.constant/3*2;
    
    [_collectionView registerClass:[ABServerItemCollectionReusableView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"ABServerItemCollectionReusableView"];
    
    UINib *nib = [UINib nibWithNibName:@"CollectionHeaderView" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"ABCollectionHeaderView"];
    
    [self p_loadServerItems];
}

// ---------------------------- by fhhe Start------------------------------
#pragma mark - 跳转到服务须知界面
- (void)jumpToServieGuidelines {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[ABNetworkDelegate serverHtml5URL],@"/files/userServiceNotice.html"];
    
    self.navigationController.navigationBar.hidden = YES;
    [HFHWebViewController showWithController:self withUrlStr:urlStr withTitle:@"服务须知" hidesBottomBarWhenPushed:YES];
}
// ---------------------------- by fhhe End------------------------------

#pragma mark - Action
- (void)rightBtnAction{
    ABLog(@"进入服务须知页面");
    
}

- (IBAction)nextAction:(id)sender {
    ABLog(@"点击下一步按钮");
    if ([ABNetworkDelegate isLogined]) {
        //进入上门信息页面
        ABDoorViewController *doorViewcontroller =[ABDoorViewController getDoorViewController];
        doorViewcontroller.orderDataDic=[self p_createOrderDataDic];
        [self.navigationController pushViewController:doorViewcontroller animated:YES];
    }else{
        ABLoginViewController *loginVC=[ABLoginViewController loginViewControllerWithDesinationViewController:self];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (!_hasLoadData) {
        return 0;
    }
    return self.dataArray.count ?: 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!_hasLoadData) {
        return 0;
    }
    return self.dataArray.count ? [self.dataArray[section][@"serverItems"] count] : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ABServerItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:
                                           @"ABServerItemCollectionViewCell" forIndexPath:indexPath];
    NSString *title = self.dataArray[indexPath.section][@"serverItems"][indexPath.row];
    [cell setTitle:title];
    [cell setHasSelected:[self p_isSelectedIndexPath:indexPath]];
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArray[indexPath.section][@"serverItems"][indexPath.row];
    //int width = [label.text widthForFont:label.font]+2*KYS_TEXT_MARGIN;//此时label.text还没赋值
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    
    int width = (int)([title widthForFont:[UIFont systemFontOfSize:KYS_SCREEN_WIDTH>320?14:13]]+2*KYS_SPACE);
    //ABLog(@"%d",width);
    if (width>((int)(KYS_SCREEN_WIDTH-2*KYS_SPACE))){
        width=(int)(KYS_SCREEN_WIDTH-2*KYS_SPACE);
        //ABLog(@"调整:%d",width);
    }
    return  CGSizeMake(width, 32*KYS_WIDTH_RATE);
#pragma clang diagnostic pop
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section) {
            ABServerItemCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ABServerItemCollectionReusableView" forIndexPath:indexPath];//需要zhuce
            header.titleLabel.text = self.dataArray[indexPath.section][@"title"];
            return header;
        }else{
            ABCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ABCollectionHeaderView" forIndexPath:indexPath];//需要zhuce
            header.nameLabel.text = self.originDataDic[@"name"];
            header.textView.text=self.originDataDic[@"description"];
            //设置单个价格（单价）
            header.deviceCostLabel.text=[NSString stringWithFormat:@"%d元/台",[self.originDataDic[@"price"] intValue]/100];
            header.delegate=self;
            if ([self.dataArray count]>=1) {
                header.headerSectionView.hidden=NO;
                _collectionView.backgroundColor=[UIColor whiteColor];
                header.titleLabel.text = self.dataArray[indexPath.section][@"title"];
            }else{
                header.headerSectionView.hidden=YES;
                _collectionView.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
            }
            //ABLog(@"111222333444555666");
            return header;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSString *des=self.originDataDic[@"description"];
    NSInteger height = [des sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(ScreenWidth-30, 10000) mode:NSLineBreakByWordWrapping].height;
    return CGSizeMake(self.view.frame.size.width, section?45:(height+(265-137)+20));//宽默认
}

//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    return KYS_SPACE;
#pragma clang diagnostic pop
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    return KYS_SPACE;
#pragma clang diagnostic pop
}

//设置整个分区相对上下左右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    return UIEdgeInsetsMake(KYS_SPACE, KYS_SPACE, KYS_SPACE, KYS_SPACE);
#pragma clang diagnostic pop
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ABLog(@"%@",indexPath);
    [self p_selectedCellWithCollectionView:collectionView IndexPath:indexPath];
}

#pragma mark - ABCollectionHeaderViewDelegate
- (void)minusAction:(NSInteger)count{
    ABLog(@"%ld",(long)count);
    _deviceCount=count;
    [self p_refreshOrder];
}

- (void)addAction:(NSInteger)count{
    ABLog(@"%ld",(long)count);
    _deviceCount=count;
    [self p_refreshOrder];
}

#pragma mark - KYSNetErrorViewDelegate
- (void)tapAction{
    [self p_loadServerItems];
}

#pragma mark - private

- (BOOL)p_isSelectedIndexPath:(NSIndexPath *)indexPath{
    //ABLog(@"p_isSelectedIndexPath: %@",self.selectedDic);
    NSDictionary *dic=self.dataArray[indexPath.section];
    id serverItem = self.selectedDic[dic[@"serverItemType"]];
    if([serverItem isKindOfClass:[NSString class]]){
        NSString *str=serverItem;
        if(str.length && [str isEqualToString:dic[@"serverItems"][indexPath.row]]){
            return YES;
        }
    }else if([serverItem isKindOfClass:[NSArray class]]){
        for (NSString *str in serverItem) {
            if(str.length && [str isEqualToString:dic[@"serverItems"][indexPath.row]]){
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)p_isSelectedNeedRefreshIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=self.dataArray[indexPath.section];
    //获取已选择的服务项
    id serverItem = self.selectedDic[dic[@"serverItemType"]];
    if([self p_isSelectedIndexPath:indexPath]){
        //删除
        if([serverItem isKindOfClass:[NSArray class]]){
            [serverItem removeObject:dic[@"serverItems"][indexPath.row]];
        }else{
            [self.selectedDic removeObjectForKey:dic[@"serverItemType"]];
        }
        return YES;
    }
    
    //添加
    if([serverItem isKindOfClass:[NSArray class]]){
        NSMutableArray *selectArray=serverItem;
        NSInteger insertIndex = -1;
        for(NSInteger i=0;i<selectArray.count;i++){
            //字符串在数组中的位置
            NSInteger index=[dic[@"serverItems"] indexOfObject:selectArray[i]];
            if(index>indexPath.row){
                insertIndex=i;
                break;
            }
        }
        //插入指定位置
        if (-1==insertIndex) {
            [selectArray addObject:dic[@"serverItems"][indexPath.row]];
        }else{
            [selectArray insertObject:dic[@"serverItems"][indexPath.row] atIndex:insertIndex];
        }
//        ABLog(@"inserted array");
//        for (NSString *str in selectArray) {
//            ABLog(@"%@",str);
//        }
    }else{
        [self.selectedDic setObject:dic[@"serverItems"][indexPath.row] forKey:dic[@"serverItemType"]];
    }
    return NO;
}

//刷新订单
- (void)p_refreshOrder{
    //刷新总价
    _moneyLabel.text=[NSString stringWithFormat:@"%ld元",[self.originDataDic[@"price"] intValue]/100*_deviceCount];
    _moneyWidth.constant=[_moneyLabel.text widthForFont:_moneyLabel.font]+10;
    
    //刷新服务时间
    NSInteger minute=[self.originDataDic[@"duration"] integerValue]*_deviceCount;
    NSInteger m=minute%60;
    NSInteger h=minute/60;
    NSString *minu=[NSString stringWithFormat:@"%@分钟",@(m)];
    NSString *hour=[NSString stringWithFormat:@"%@小时",@(h)];
    NSString *time=[NSString stringWithFormat:@"%@%@",h?hour:@"",((!m&&!h)||m)?minu:@""];
    _timeLabel.text=[NSString stringWithFormat:@"(约%@)",time];
    _timeWidth.constant=[_timeLabel.text widthForFont:_timeLabel.font]+17;
    [_moneyLabel layoutIfNeeded];
    
    ABLog(@"%@",NSStringFromCGRect(_scrollView.frame));
    
    ABLog(@"%f",_timeLabel.frame.origin.x+_timeWidth.constant);
    
    _scrollView.contentSize=CGSizeMake(_timeLabel.frame.origin.x+_timeWidth.constant, 49);
}

//点击某一个Cell
- (void)p_selectedCellWithCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath{
    
    ABLog(@"11");
    if([self p_isSelectedNeedRefreshIndexPath:indexPath]){
        ABLog(@"22");
        ABLog(@"p_selectedCellWithCollectionView: %@",self.selectedDic);
        ABServerItemCollectionViewCell *cell=(ABServerItemCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        [cell setHasSelected:NO];
        return;
    }
    ABLog(@"p_selectedCellWithCollectionView: %@",self.selectedDic);
    
    ABLog(@"33");
    NSDictionary *dic=self.dataArray[indexPath.section];
    id serverItem = self.selectedDic[dic[@"serverItemType"]];
    ABLog(@"serverItem :%@",serverItem);
    if([serverItem isKindOfClass:[NSArray class]]){
        ABLog(@"44");
        ABServerItemCollectionViewCell *cell=(ABServerItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setHasSelected:YES];
    }else{
        ABLog(@"55");
        NSArray *visibleIndexPathArray=[collectionView indexPathsForVisibleItems];
        for (NSIndexPath *visibleIndexPath in visibleIndexPathArray){
            //过滤出与当前indexPath.secion相同的IndexPath
            if (visibleIndexPath.section==indexPath.section) {
                //ABLog(@"44");
                ABServerItemCollectionViewCell *cell=(ABServerItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:visibleIndexPath];
                [cell setHasSelected:visibleIndexPath.row==indexPath.row];
            }
        }
    }
}

- (void)p_loadServerItems{
    ABLog(@"加载数据");
    ABLog(@"%@",_firstClassServes.servesid);
    ABLog(@"%@",_firstClassServes.dict);
    NSDictionary *dic=@{@"id":_firstClassServes.servesid};
    __weak typeof(self) wSelf=self;
    _nextView.hidden=YES;
    _hasLoadData=NO;
    [KYSNetwork getServerItemWithParameters:dic success:^(id responseObject) {
        ABLog(@"服务项请求成功");
        ABLog(@"%@",responseObject);
        wSelf.collectionView.hidden=NO;
        wSelf.nextView.hidden=NO;
        wSelf.hasLoadData=YES;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [wSelf.netErrorView hideHint];
            wSelf.originDataDic=responseObject[@"data"];
            [wSelf p_dealResponseDic:wSelf.originDataDic];
            [wSelf.collectionView reloadData];
            [wSelf p_refreshOrder];
        }
    } failureBlock:^(id object) {
        ABLog(@"服务项请求失败");
        wSelf.collectionView.hidden=YES;
        wSelf.nextView.hidden=YES;
        wSelf.hasLoadData=NO;
        //if (isDisConnectedNetwork) {
            [wSelf.netErrorView showHint];
            wSelf.rightButton.hidden=YES;
        //}
//        else{
//            [CustomToast showToastWithInfo:@"服务项加载失败"];
//        }
    } view:wSelf.view];
    
//    ABLog(@"_serverItem.dict: %@",_serverItem.dict);
//    //使用上一页传来的数据，如果为空显示自定义数据
//    self.originDataDic=_serverItem.dict;
//    [self p_dealResponseDic:self.originDataDic];
//    [self.collectionView reloadData];
//    [self p_refreshOrder];
}

//处理 过滤
- (void)p_dealResponseDic:(NSDictionary *)dic{
    self.dataArray=[[NSMutableArray alloc] init];
    for (NSDictionary *typeDic in self.typeArray) {
        NSArray *array=dic[typeDic[@"serverItemType"]];
        if (array&&array.count) {
            [self.dataArray addObject:@{@"title":typeDic[@"title"],
                                        @"serverItemType":typeDic[@"serverItemType"],
                                        @"serverItems":array}];
        }
    }
}

//生成订单Dic
- (NSMutableDictionary *)p_createOrderDataDic{
    //总价格:单价*台数 - by fhhe 改为传入单台的价格 - 主席那边计算
    NSInteger cost = [self.originDataDic[@"price"] intValue];
    //中耗时:单个时间*台数 - by fhhe 改为传入单台的时间 - 主席那边计算
    NSInteger minute=[self.originDataDic[@"duration"] integerValue];
    //创建订单data
    NSArray *comArray=self.selectedDic[@"device_components"];
    NSMutableDictionary *dic =[@{@"service_id":self.originDataDic[@"id"]?:@"",
                                 @"device_num":[NSString stringWithFormat:@"%ld",(long)_deviceCount],//总价格，总耗时都传了，为什么还要传台数
                                 @"price":[NSString stringWithFormat:@"%ld",(long)cost],
                                 @"duration":[NSString stringWithFormat:@"%ld",(long)minute],
                                 //@"service_classname":_firstClassServes.subclassName,//服务项分类名(上一级)
                                 @"service_name":self.originDataDic[@"name"]?:@"",
                                 @"failure_types":self.selectedDic[@"failure_types"]?:@"",
                                 @"service_types":self.selectedDic[@"service_types"]?:@"",
                                 @"device_types":self.selectedDic[@"device_types"]?:@"",
                                 @"os_types":self.selectedDic[@"os_types"]?:@"",
                                 @"device_brands":self.selectedDic[@"device_brands"]?:@"",
                                 @"device_components":comArray.count?[comArray componentsJoinedByString:@";"]:@""
                                 }mutableCopy];
    
    return dic;
}

#pragma mark - 懒加载
- (KYSNetErrorView *)netErrorView{
    if (!_netErrorView) {
        CGRect rect=CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);
        _netErrorView=[[KYSNetErrorView alloc] initWithFrame:rect];
        _netErrorView.delegate=self;
        [self.view addSubview:_netErrorView];
    }
    return _netErrorView;
}

- (NSArray *)typeArray{
    if (!_typeArray) {
        _typeArray=@[@{@"title":@"故障类型",@"serverItemType":@"failure_types"},
                     @{@"title":@"服务类型",@"serverItemType":@"service_types"},
                     @{@"title":@"设备类型",@"serverItemType":@"device_types"},
                     @{@"title":@"系统类型",@"serverItemType":@"os_types"},
                     @{@"title":@"品牌",@"serverItemType":@"device_brands"},
                     @{@"title":@"部件",@"serverItemType":@"device_components"}];
    }
    return _typeArray;
}

- (NSMutableDictionary *)selectedDic{
    if (!_selectedDic) {
        _selectedDic=[@{@"failure_types":@"",
                        @"service_types":@"",
                        @"device_types":@"",
                        @"os_types":@"",
                        @"device_brands":@"",
                        @"device_components":[@[] mutableCopy]} mutableCopy];
    }
    return _selectedDic;
}











@end
