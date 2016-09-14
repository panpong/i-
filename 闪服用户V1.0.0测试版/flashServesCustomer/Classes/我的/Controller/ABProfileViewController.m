//
//  ABProfileViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/18.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABProfileViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABProfileTableViewCell.h"
#import "ABSettingViewController.h"
#import "ABMyProfileViewController.h"
#import "KYSNetwork.h"
#import "ABNetworkDelegate.h"
#import "ABLoginViewController.h"
#import "CPBillViewController.h"
#import "ABAdviceViewController.h"
#import "HFHWebViewController.h"


@interface ABProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBtnWidth;


@property (nonatomic,strong)NSArray *itemArray;//存放页面信息

@end

@implementation ABProfileViewController

+ (UIViewController *)getProfileViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Me" bundle:nil];
    return [storyboard instantiateInitialViewController];
}

- (NSArray *)itemArray{
    if (!_itemArray) {
        _itemArray=@[@[@{@"image":@"16",@"title":@"我的资料"},
                       @{@"image":@"15",@"title":@"申请发票"}],
                     @[@{@"image":@"13",@"title":@"常见问题"},
                       @{@"image":@"14",@"title":@"意见反馈"},
                       @{@"image":@"12",@"title":@"联系客服",@"tag":@(1)}]];
    }
    return _itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBarItem:@"我的" leftButtonIcon:nil rightButtonTitle:@"设置"];
    [self.rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.backgroundColor =[UIColor clearColor];
    
    _imageView.layer.cornerRadius=1.0;
    _imageView.layer.masksToBounds=YES;

    _headBtn.layer.cornerRadius=16.5;
    _headBtn.layer.masksToBounds=YES;
    
    //注册资料成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotification:) name:@"update.profile.success" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self updateNotification:nil];
}

- (IBAction)headBtnAction:(id)sender {
    if (![ABNetworkDelegate isLogined]) {
        NSLog(@"进入登录页面");
        ABLoginViewController *loginVC=[ABLoginViewController loginViewControllerWithDesinationController:@"ABProfileViewController"];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)rightBtnAction{
    if([ABNetworkDelegate isLogined]){
        ABSettingViewController *viewController=[ABSettingViewController getSettingViewController];
        //viewController.dataDic=_dataDic;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        NSLog(@"进入登录页面");
        ABLoginViewController *loginVC=[ABLoginViewController loginViewControllerWithDesinationController:@"ABProfileViewController"];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

//收到修改资料成功通知
- (void)updateNotification:(NSNotification *)notification{
    NSLog(@"ABProfileViewController update.profile.success: %@",notification.object);
    //[self p_updateProfileWithDic:notification.object];
    if ([ABNetworkDelegate isLogined]) {
        _headBtnWidth.constant=125;
        NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
        [_headBtn setTitle:mobile forState:UIControlStateNormal];
    }else{
        _headBtnWidth.constant=50;
        [_headBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (0==section) {
        return 0.0;
    }
    return 12.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView=[[UIView alloc] init];
    sectionView.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.itemArray[section] count];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ABProfileTableViewCell *cell=(ABProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ABProfileTableViewCell" forIndexPath:indexPath];
    [cell setDataWithDic:_itemArray[indexPath.section][indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.itemArray[indexPath.section][indexPath.row][@"title"]);
    if (0==indexPath.section) {
        if (![ABNetworkDelegate isLogined]) {
            NSLog(@"进入登录页面");
            ABLoginViewController *loginVC=[ABLoginViewController loginViewControllerWithDesinationController:@"ABProfileViewController"];
            loginVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        if (0== indexPath.row) {
            //进入我的资料页
            ABMyProfileViewController *myProfileViewController=[[ABMyProfileViewController alloc] init];
            myProfileViewController.hidesBottomBarWhenPushed=YES;
            myProfileViewController.isUpdate=NO;
            [self.navigationController pushViewController:myProfileViewController animated:YES];
        }else if (1 == indexPath.row) {
            //进入申请发票页面
            CPBillViewController *bill = [[CPBillViewController alloc] init];
            bill.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bill animated:YES];
            return;
        }
    }else{
        if (0== indexPath.row) {
            //常见问题
            [HFHWebViewController showWithController:self
                                      withUrlStr:CHANG_JIAN_WEN_TI
                                       withTitle:@"常见问题"
                        hidesBottomBarWhenPushed:YES];
            
        }else if (1 == indexPath.row) {
            //进入意见反馈页面
            ABAdviceViewController *viewController=[[ABAdviceViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.phoneNumber=[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
            [self.navigationController pushViewController:viewController animated:YES];
            return;
        }else if(2==indexPath.row){
            //拨打客服电话
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",SERVICE_PHONE_NUM];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        
    }
}

@end
