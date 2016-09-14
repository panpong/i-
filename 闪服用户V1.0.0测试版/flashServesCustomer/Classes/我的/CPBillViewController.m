//
//  CPBillViewController.m
//  flashServesCustomer
//
//  Created by yjin on 16/6/1.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPBillViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ABNetworkManager.h"
#import "CustomToast.h"
#import "UIView+Extention.h"
#import "CPLineLabel.h"
#import "CPButtonWithHightColor.h"
#import "CPModalOrder.h"
#import "CPAcceptBillCell.h"
#import "ABBigMessageView.h"
#import "CPBilllDetailViewController.h"
#import "ABApplyBillViewController.h"
@interface CPBillViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *arrayModal ;

@property (nonatomic, strong)UILabel *labelPrice;
@property (nonatomic, strong)UILabel *labelYuan;

// ------------------------------ start by fhhe ------------------------------
// 发票说明提示View
@property(nonatomic,strong) ABBigMessageView *bigMessageView;

// 提示View的内容
@property(nonatomic,strong) NSMutableAttributedString *message;
// ------------------------------ end by fhhe --------------------------------


@property (nonatomic, strong)UILabel *label ;


@end

@implementation CPBillViewController

- (NSMutableArray *)arrayModal {
    
    if (_arrayModal == nil) {
        
        _arrayModal = [NSMutableArray array];
        
    }
    return _arrayModal;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.frame = self.view.bounds;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    [_tableView setBackgroundColor:kColorBackground];
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 55;
    
    [self setNavigationBarItem:@"申请发票" leftButtonIcon:@"返回" rightButtonTitle:@"开票说明"];
    
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    

    UIView *headView  = [[UIView alloc] init];
    [headView setBackgroundColor:kColorBackground];
    headView.frame = CGRectMake(0, 0, ScreenWidth, 175);
    
    UIView *priceView = [self priceView];

    [headView addSubview:priceView];
    
    CPButtonWithHightColor *button = [CPButtonWithHightColor buttonWithType:UIButtonTypeCustom];
    button.typeBackGroundColor = BackGroundColorBlue;
    [button setTitle:@"我要开票" forState:UIControlStateNormal];
    button.frame = CGRectMake(15, 109, ScreenWidth - 30, 50);
    [headView addSubview:button];
    [button addTarget:self action:@selector(buttonOrderClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setBackgroundColor:KColorBlue];
    button.layer.cornerRadius = 5.0f;
    button.titleLabel.font = [UIFont systemFontOfSize:19];
    
    CPLineLabel *line = [[CPLineLabel alloc] init];
    line.y = 174;
    line.width = ScreenWidth;
    [headView addSubview:line];
    
    
    _tableView.tableHeaderView = headView;
}

- (void)buttonOrderClick:(UIButton *)button {
    
    NSString *lastTitl  = self.arrayModal.count == 0 ? nil : self.arrayModal[0][@"title"];
    
    ABApplyBillViewController *applyBillViewController = [ABApplyBillViewController applyBillViewControllerWithLeftMoeny:self.labelPrice.text lastBillTitle:lastTitl];
    [self.navigationController pushViewController:applyBillViewController animated:YES];
}


- (UIView *)priceView {
    
     UIView *priceView = [[UIView alloc] init];
    [priceView setBackgroundColor:[UIColor whiteColor]];
    priceView.frame = CGRectMake(0, 0, ScreenWidth, 90);
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"可开票金额";
    textLabel.frame = CGRectMake(15, 10, 40, 20);
    textLabel.textColor = KColorTextBlack;
    textLabel.font = [UIFont systemFontOfSize:12];
    [textLabel sizeToFit];
    [priceView addSubview:textLabel];
    
    UILabel *labelYuan = [[UILabel alloc] init];
    labelYuan.text = @"元";
    labelYuan.textColor = kColorOrange;
    labelYuan.font = [UIFont systemFontOfSize:15];
    labelYuan.y = 44;
    _labelYuan = labelYuan;
    [_labelYuan sizeToFit];
    
    [priceView addSubview:labelYuan];
    
    UILabel *labelPrice = [[UILabel alloc] init];
    labelPrice.textColor = kColorOrange;
    labelPrice.font = [UIFont systemFontOfSize:30];
    labelPrice.y = 32;
    _labelPrice = labelPrice;

    [priceView addSubview:labelPrice];
    
    CPLineLabel *line = [[CPLineLabel alloc] init];
    line.y = 89;
    line.width = ScreenWidth;
    [priceView addSubview:line];
    
    return priceView;
}

- (void)setingPrice:(NSDictionary *)dic {
    
    _labelPrice.text = dic[@"left_money"];
    [_labelPrice sizeToFit];
    _labelPrice.centerX = (ScreenWidth - _labelYuan.width) * 0.5;
    _labelYuan.x = CGRectGetMaxX(_labelPrice.frame);
}




- (void)viewWillAppear:(BOOL)animated {
    
    [self reLoadData];
}


- (void)reLoadData {
  
    [self showLoadingView];
    NSDictionary *paramer = nil;
    [KABNetworkManager GETURI:@"customer/invoices/v1.0.1/list" parameters:paramer success:^(id responseObject) {
        [self removeLoadingView ];
        if (checkNetworkResultObject(responseObject)) {
            
            self.arrayModal = responseObject[@"data"];
            [self.tableView reloadData];
            [self setingPrice:responseObject];
            
            return ;
        }
      
        if (_arrayModal == nil) {
            
            [self showErrorView];
        }
        
        [CustomToast showDialog:responseObject[kErrmsg]];
    } failure:^(id object) {

        [CustomToast hideWating];
        [CustomToast showNetworkError];
        [self showErrorView];
        
    }];
        
    
    
}

- (void)rightButtonClick:(UIButton *)button {
    
    
    // ------------------------------ start by fhhe ------------------------------
     [self.bigMessageView show];
    
    if (_label == nil) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"开票相关问题可咨询客服";
        label.font = [UIFont systemFontOfSize:14];
        [label sizeToFit];
        [label setTextColor:[UIColor whiteColor]];
        [self.bigMessageView addSubview:label];
        _label = label;
        
        
        UIButton *buttom = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttom setTintColor:[UIColor whiteColor]];
        [buttom setTitle:SERVICE_PHONE_NUM forState:UIControlStateNormal];
        [buttom.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttom sizeToFit];
        [buttom addTarget:self action:@selector(buttonPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bigMessageView addSubview:buttom];
        
        CGFloat marginX = (ScreenWidth - buttom.width - label.width) * 0.5;
        label.x = marginX;
        buttom.x = marginX + label.width + 4;
        label.y = ScreenHeight - 22 - label.height;
        buttom.centerY = label.centerY;
        
    }
  
  
    
    
    
    // ------------------------------ end by fhhe --------------------------------
}



- (void)buttonPhoneClick:(UIButton *)button {
    
   
    NSURL *phoneURL = [NSURL URLWithString: [NSString stringWithFormat: @"tel:/%@",SERVICE_PHONE_NUM]];
    UIWebView *  phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark 数据源代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrayModal.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    CPAcceptBillCell *cell = [CPAcceptBillCell acceptBillCell:tableView];
    cell.modal = self.arrayModal[indexPath.row];
    
    if (self.arrayModal.count - 1 == indexPath.row ) {
        
        cell.isLastCell = YES;
        
    }else {
        cell.isLastCell = NO;
    }
    
    return cell
    ;

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.arrayModal[indexPath.row];
    CPBilllDetailViewController *detailVC = [CPBilllDetailViewController billlDetailViewCotnroller:dic[@"id"]];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}



- (void)tapClick {
    
    [self reLoadData];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// ------------------------------ start by fhhe ------------------------------
- (ABBigMessageView *)bigMessageView {
    if (!_bigMessageView) {
        _bigMessageView = [ABBigMessageView bigMessageViewWithFrame:self.view.frame message:self.message];
    }
    return _bigMessageView;
}

- (NSMutableAttributedString *)message {
    if (!_message) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;
        _message = [[NSMutableAttributedString alloc] initWithString:@"开票说明：\n1、根据申请发票金额，如果超过2000元，由闪服科技包邮快递发票；\n2、发票类型仅限于服务费；\n3、如果未超过2000元，客户可选累积至2000元或由闪服科技快递到付发票； \n4、发票在客户申请提交后5个工作日内寄出。"];
        [_message addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}  range:NSMakeRange(0, _message.length)];
        [_message addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}  range:NSMakeRange(0, 5)];
        [_message addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:PADDING_28PX]}  range:NSMakeRange(5, _message.length - 5)];
    }
    return _message;
}
// ------------------------------ end by fhhe --------------------------------



@end
