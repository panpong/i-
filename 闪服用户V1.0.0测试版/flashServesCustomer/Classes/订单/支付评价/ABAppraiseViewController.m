//
//  ABAppraiseViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/22.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABAppraiseViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "UIView+Extention.h"
#import "KYSNetwork.h"
#import "CustomToast.h"
#import "AppDelegate.h"

@interface ABAppraiseViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIButton *assessBtn1;
@property (weak, nonatomic) IBOutlet UIButton *assessBtn2;
@property (weak, nonatomic) IBOutlet UIButton *assessBtn3;
@property (weak, nonatomic) IBOutlet UIButton *assessBtn4;
@property (nonatomic,strong)NSArray *assessBtnArray;
@property (nonatomic,assign)NSInteger assessIndex;

@property (weak, nonatomic) IBOutlet UIButton *professionalBtn1;
@property (weak, nonatomic) IBOutlet UIButton *professionalBtn2;
@property (weak, nonatomic) IBOutlet UIButton *professionalBtn3;
@property (weak, nonatomic) IBOutlet UIButton *professionalBtn4;
@property (weak, nonatomic) IBOutlet UIButton *professionalBtn5;
@property (nonatomic,strong)NSArray *professionalBtnArray;
@property (nonatomic,assign)NSInteger professionalIndex;

@property (weak, nonatomic) IBOutlet UIButton *punctualBtn1;
@property (weak, nonatomic) IBOutlet UIButton *punctualBtn2;
@property (weak, nonatomic) IBOutlet UIButton *punctualBtn3;
@property (weak, nonatomic) IBOutlet UIButton *punctualBtn4;
@property (weak, nonatomic) IBOutlet UIButton *punctualBtn5;
@property (nonatomic,strong)NSArray *punctualBtnArray;
@property (nonatomic,assign)NSInteger punctualIndex;

@property (weak, nonatomic) IBOutlet UIButton *communicateBtn1;
@property (weak, nonatomic) IBOutlet UIButton *communicateBtn2;
@property (weak, nonatomic) IBOutlet UIButton *communicateBtn3;
@property (weak, nonatomic) IBOutlet UIButton *communicateBtn4;
@property (weak, nonatomic) IBOutlet UIButton *communicateBtn5;
@property (nonatomic,strong)NSArray *communicateBtnArray;
@property (nonatomic,assign)NSInteger communicateIndex;

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation ABAppraiseViewController

+ (ABAppraiseViewController *)getAppraiseViewController{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Pay&Appraise" bundle:nil];
    ABAppraiseViewController *appVC=[storyBoard instantiateViewControllerWithIdentifier:@"ABAppraiseViewController"];
    
    
    return appVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _assessIndex=0;
    _professionalIndex=5;
    _punctualIndex=5;
    _communicateIndex=5;
    
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBarItem:@"评价" leftButtonIcon:@"返回" rightButtonTitle:nil];
    
    for( UIButton *btn in self.assessBtnArray){
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.borderWidth=1.0;
        btn.layer.borderColor=[UIColor colorWithRed:0 green:162/255.0 blue:227/255.0 alpha:1].CGColor;
        btn.layer.cornerRadius=3.0;
        btn.layer.masksToBounds=YES;
    }
    
    _commitBtn.layer.cornerRadius=3.0;
    _commitBtn.layer.masksToBounds=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Action
- (IBAction)tapAction:(id)sender {
    NSLog(@"tap");
    [_textView resignFirstResponder];
}

- (IBAction)assessBtnAction:(UIButton *)btn {
    for (int i=0; i<self.assessBtnArray.count; i++) {
        UIButton *button=self.assessBtnArray[i];
        if (i==(4-btn.tag)) {
            [button setBackgroundColor:[UIColor colorWithRed:0 green:162/255.0 blue:227/255.0 alpha:1]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor colorWithRed:0 green:162/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
    _assessIndex=btn.tag;
     NSLog(@"%ld",(long)_assessIndex);
}

- (IBAction)professionalBtnAction:(UIButton *)btn {
    [self p_updateCountWithArray:self.professionalBtnArray index:btn.tag];
    _professionalIndex=btn.tag;
    NSLog(@"%ld",(long)_professionalIndex);
}

- (IBAction)punctualBtnAction:(UIButton *)btn {
    [self p_updateCountWithArray:self.punctualBtnArray index:btn.tag];
    _punctualIndex=btn.tag;
    NSLog(@"%ld",(long)_punctualIndex);
}

- (IBAction)communicateBtnAction:(UIButton *)btn {
    [self p_updateCountWithArray:self.communicateBtnArray index:btn.tag];
    _communicateIndex=btn.tag;
    NSLog(@"%ld",(long)_communicateIndex);
}

- (IBAction)commitAction:(id)sender {
    [self p_commitComment];
}


#pragma mark - Notification
- (void)showKeyboard{
    _tableView.contentSize=CGSizeMake(_tableView.width, _tableView.height+[self p_getHeightMargin]);
    _tableView.contentOffset=CGPointMake(0, [self p_getHeightMargin]);
}

- (void)hideKeyboard{
    _tableView.contentSize=CGSizeMake(_tableView.width, _tableView.height);
    _tableView.contentOffset=CGPointMake(0, 0);
}

#pragma mark - UITextViewDelegate
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (range.location>=100) {
//        return NO;
//    }
//    _wordCountLabel.text=[NSString stringWithFormat:@"%lu/100",(unsigned long)range.location];
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView{
    _alertLabel.hidden=_textView.text.length?YES:NO;
    if (_textView.text.length>100) {
        _textView.text=[_textView.text substringToIndex:100];
    }
    _wordCountLabel.text=[NSString stringWithFormat:@"%lu/100",(unsigned long)_textView.text.length];
}


#pragma mark - private
- (NSInteger)p_getHeightMargin{
    NSLog(@"%f",self.view.height);
    if(self.view.height<=568){
        return 181;
    }else if(self.view.height<=667){
        return 87;
    }else if(self.view.height<=736){
        return 22;
    }
    return 0;
}

- (void)p_updateCountWithArray:(NSArray *)array index:(NSInteger)index{
    for (int i=0; i<array.count; i++) {
        NSString *imageStr=i<index?@"评价-星1":@"评价-星2";
        UIButton *button=array[i];
        [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    }
}

- (void)p_commentFinish{
    [self.navigationController popToRootViewControllerAnimated:NO];
    //应该发一个更新订单列表的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderListChangeNotification" object:nil];
    //进入订单列表
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    UITabBarController *tabVC=(UITabBarController *)appDel.window.rootViewController;
    UINavigationController *naVC=tabVC.viewControllers[2];
    [naVC popToRootViewControllerAnimated:NO];
    [tabVC setSelectedIndex:2];
}

- (void)p_commitComment{
    
    if(![self p_checkData]){
        return;
    }
    
    NSDictionary *dic=@{@"engineer_id":_engineerId.length?_engineerId:@"",
                        @"order_id":_orderId.length?_orderId:@"",
                        @"assess":[NSString stringWithFormat:@"%ld",(long)_assessIndex],
                        @"score_professional":[NSString stringWithFormat:@"%ld",(long)_professionalIndex],
                        @"score_punctual":[NSString stringWithFormat:@"%ld",(long)_punctualIndex],
                        @"score_communicate":[NSString stringWithFormat:@"%ld",(long)_communicateIndex],
                        @"comment":_textView.text.length?_textView.text:@""};
    NSLog(@"%@",dic);
    
    __weak typeof(self) wSelf=self;
    [KYSNetwork commitCommentWithParameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [CustomToast showToastWithInfo:@"评价成功"];
        [wSelf p_commentFinish];
        //返回订单列表
    } failureBlock:^(id object) {
        if (isConnectingNetwork){
            [CustomToast showToastWithInfo:@"评价失败"];
        }
        [wSelf p_commentFinish];
    } view:self.view];
}

- (BOOL)p_checkData{
    if (!_assessIndex) {
        [CustomToast showToastWithInfo:@"请对该工程师进行评价"];
        return NO;
    }
    if (!_professionalIndex||!_punctualIndex||!_communicateIndex) {
        [CustomToast showToastWithInfo:@"请给工程师专业、守时、沟通评分"];
        return NO;
    }
    return YES;
}

#pragma mark - data
- (NSArray *)assessBtnArray{
    if (!_assessBtnArray) {
        _assessBtnArray=@[_assessBtn1,_assessBtn2,_assessBtn3,_assessBtn4];
    }
    return _assessBtnArray;
}

- (NSArray *)professionalBtnArray{
    if (!_professionalBtnArray) {
        _professionalBtnArray=@[_professionalBtn1,_professionalBtn2,_professionalBtn3,_professionalBtn4,_professionalBtn5];
    }
    return _professionalBtnArray;
}

- (NSArray *)punctualBtnArray{
    if (!_punctualBtnArray) {
        _punctualBtnArray=@[_punctualBtn1,_punctualBtn2,_punctualBtn3,_punctualBtn4,_punctualBtn5];
    }
    return _punctualBtnArray;
}

- (NSArray *)communicateBtnArray{
    if (!_communicateBtnArray) {
        _communicateBtnArray=@[_communicateBtn1,_communicateBtn2,_communicateBtn3,_communicateBtn4,_communicateBtn5];
    }
    return _communicateBtnArray;
}


@end
