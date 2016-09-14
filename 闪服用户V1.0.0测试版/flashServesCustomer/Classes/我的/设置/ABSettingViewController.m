//
//  ABSettingViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABSettingViewController.h"
#import "ABSettingTableViewCell.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABBindEmailViewController.h"
#import "ABUpdatePasswordViewController.h"
#import "ABNetworkDelegate.h"
#import "KYSNetwork.h"
#import "CustomToast.h"
#import "ABAboutMeViewController.h"
#import "ABNotifacation.h"

@interface ABSettingViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (nonatomic,strong)NSArray *itemArray;

@end

@implementation ABSettingViewController

+ (ABSettingViewController *)getSettingViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Me" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ABSettingViewController"];
}

- (NSArray *)itemArray{
    if (!_itemArray) {
        NSString *email=_dataDic[@"email"];
        _itemArray=@[@{@"title":email.length?@"修改登录邮箱":@"绑定登录邮箱"},
                     @{@"title":@"修改密码"},
                     @{@"title":@"关于我们"}];
    }
    return _itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBarItem:@"账号设置" leftButtonIcon:@"返回" rightButtonTitle:nil];
    
    _bottomBtn.layer.cornerRadius=3.0;
    _bottomBtn.layer.masksToBounds=YES;
}

#pragma mark - Action
//退出当前账号
- (IBAction)logoutAction:(id)sender {
    NSLog(@"退出当前账号");
    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"退出登录"
                                                       message:@"确定要退出吗？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确认", nil];
    [alertView show];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ABSettingTableViewCell *cell=(ABSettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ABSettingTableViewCell" forIndexPath:indexPath];
    [cell setDataWithDic:_itemArray[indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.itemArray[indexPath.row][@"title"]);
    if (0==indexPath.row) {
        ABBindEmailViewController *viewController=[ABBindEmailViewController getBindEmailViewController];
        viewController.dataDic=_dataDic;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if(1==indexPath.row){
        ABUpdatePasswordViewController *viewController=[ABUpdatePasswordViewController getUpdatePasswordViewController];
        viewController.dataDic=_dataDic;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if(2==indexPath.row){
        ABAboutMeViewController *aVC=[ABAboutMeViewController getAboutMeViewController];
        [self.navigationController pushViewController:aVC animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ABLog(@"%ld",(long)buttonIndex);
    if (1==buttonIndex) {
        ABNotifacation *notifacation = [ABNotifacation sharedNotifacation];
        [notifacation loginOutWith:^{
            KABNetworkDelegate.stringUserID = nil;
            KABNetworkDelegate.stringSID = nil;
            [ABNetworkDelegate loginOutHandle];
            ABLog(@"tabBarController1:%@",self.tabBarController);
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINOUT object:nil];
        }];        
    }
}


@end
