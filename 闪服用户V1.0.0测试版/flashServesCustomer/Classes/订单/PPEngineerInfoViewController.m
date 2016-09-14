//
//  PPEngineerInfoViewController.m
//  flashServesCustomer
//
//  Created by Mr.P on 16/8/30.
//  Copyright © 2016年 002. All rights reserved.
//
#import "UIViewController+CustomNavigationBar.h"
#import "PPEngineerInfoViewController.h"
#import "CPSkillViewCell.h"
#import "CPLineLabel.h"
#import "ABNetworkManager.h"
#import "UIView+Extention.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define KColorBackGround CPColor(246, 246, 246)
@interface PPEngineerInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
//技能展示视图
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UITableView *SkillTavbleView;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLable;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;

@property (weak, nonatomic) IBOutlet UILabel *sexLable;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLable;

@property (nonatomic,strong) NSDictionary *dataDic;
@property(nonatomic,strong)NSDate *selectedAgeDate;
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;

@property (weak, nonatomic) IBOutlet UIImageView *companyImageView;

//技能数组
@property (nonatomic, strong)NSMutableArray <NSDictionary *>*arraySkills;

@end

@implementation PPEngineerInfoViewController

- (instancetype)initWithDic:(NSDictionary *)dic
{

    if (self = [super init]) {
        _dataDic = dic;
        
    }
    return self;
}
//懒加载
- (NSMutableArray<NSDictionary *> *)arraySkills
{
    if (!_arraySkills) {
        _arraySkills = [NSMutableArray arrayWithArray:_dataDic[@"abilities_tags"]];
       // _arraySkills = nil;

    }
    return _arraySkills;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     [self setNavigationBarItem:@"工程师信息" leftButtonIcon:@"返回" rightButtonTitle:@"联系客服"];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self settingTableView];
//    [self settingStarView];
    [self refeshViews];
}


- (void)rightButtonClick:(UIButton *)button {
    
    NSURL *phoneURL = [NSURL URLWithString: [NSString stringWithFormat: @"tel:/%@",SERVICE_PHONE_NUM]];
    UIWebView *  phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
    
}

- (void)refeshViews
{
    self.nameLable.text = _dataDic[@"profile"][@"name"];
    self.titleImageView.layer.cornerRadius = 40;
    _titleImageView.layer.masksToBounds=YES;

    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"profile"][@"thumb_url"]]
                           placeholderImage:[UIImage imageNamed:@"个人中心头像"]];
     self.orderNumLable.text=[NSString stringWithFormat:@" %d",[_dataDic[@"statis"][@"order_count"] intValue]];
    CGFloat starCount=[_dataDic[@"statis"][@"satisfactory"] floatValue]==0?5:[_dataDic[@"statis"][@"satisfactory"] floatValue];
    for (int i=0; i<starCount; i++) {
        UIImageView *imageView=[[UIImageView alloc] init];
        imageView.frame=CGRectMake((12+3)*i, 3, 12, 12);
        imageView.backgroundColor=[UIColor clearColor];
        imageView.contentMode=UIViewContentModeCenter;
        imageView.image=[UIImage imageNamed:i<starCount?@"形状-8":@"形状-9"];
        [_starView addSubview:imageView];
    }
    self.scoreLabel.text=[_dataDic[@"statis"][@"satisfactory"] floatValue]?[NSString stringWithFormat:@"%.1f",starCount]:@"暂无评价";
    self.sexLable.text = [_dataDic[@"profile"][@"gender"] floatValue]==1?@"男":@"女";
    
    
    _selectedAgeDate=[NSDate dateWithTimeIntervalSince1970:[_dataDic[@"profile"][@"birthday"] doubleValue]];
    _ageLable.text = [NSString stringWithFormat:@"%zd岁",[self p_getAgeWithDate:_selectedAgeDate]];
    _adressLable.text = [NSString stringWithFormat:@"%@",_dataDic[@"profile"][@"city"]];
    if (!self.arraySkills.count) {
        [self.skillImageView setImage:[UIImage imageNamed:@"ic_star_normal"]];
    }
    if (!_dataDic[@"profile"][@"supplier_no"]) {
        [self.companyImageView setImage:[UIImage imageNamed:@"ic_service_no"]];
    }
}


- (NSInteger)p_getAgeWithDate:(NSDate *)date{
    NSDate *currrentDate=[NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitYear;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:currrentDate  options:0];
    return [comps year];
}

- (void)settingTableView
{
    self.SkillTavbleView.dataSource = self;
    self.SkillTavbleView.delegate = self;
    [self.SkillTavbleView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.SkillTavbleView setBackgroundColor:KColorBackGround];
    //[self.SkillTavbleView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.SkillTavbleView.backgroundColor = [UIColor whiteColor];
    self.SkillTavbleView.bounces = NO;
    
    self.infoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"组2"]];
    
    
}

#pragma mark- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arraySkills.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        cell.textLabel.text = @"暂无技能~";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
       
        return cell;
    }
    CPSkillViewCell *cell = [CPSkillViewCell skillViewCellWith:tableView];
    cell.arrayKill =  [self.arraySkills copy];
    
    return  cell;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arraySkills.count == 0) {
        return 90;
    }
    CPSkillViewCell *cell = [CPSkillViewCell skillViewCellWith:tableView];
    cell.arrayKill = [self.arraySkills copy];
    return cell.heightView;
}
#pragma mark - 分区头

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     NSArray *array = @[@"技能标签"];
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = KColorBackGround;
    headView.bounds = CGRectMake(0, 0, 320, 25);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 0, 100, 25);
    [headView addSubview:label];
    label.text = array[section];
    label.textColor = kColorTextGrey;
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    
    [self settitingLineForHeadView:headView section:section];
    return headView;
}

- (void)settitingLineForHeadView:(UIView *)headView  section:(NSInteger)section {
    
    if (section != 0) {
        UILabel *tipLine = [[CPLineLabel alloc] init];
        tipLine.frame = CGRectMake(0, 0, ScreenWidth, CPLineHeight);
        [headView addSubview:tipLine];
    }
    
    UILabel *bottomLine = [[CPLineLabel alloc] init];
    bottomLine.frame = CGRectMake(0, headView.height - 1, ScreenWidth, CPLineHeight);
    [headView addSubview:bottomLine];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

#pragma mark - starView


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
