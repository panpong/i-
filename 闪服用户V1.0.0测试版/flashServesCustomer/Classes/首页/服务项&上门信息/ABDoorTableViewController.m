//
//  ABDoorTableViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABDoorTableViewController.h"
#import "CPChoicePhoto.h"
#import "UIView+Extention.h"
#import "KYSNetwork.h"
#import "CustomToast.h"
#import "ABServesAdressViewController.h"
#import "ABLocation.h"
#import "ABHistoryLocations.h"
#import "NSString+KYSAddition.h"

@interface ABDoorTableViewController ()<ABServesAdressViewController,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *imageBtn1;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn2;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn3;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn1;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn2;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn3;

@property(nonatomic,strong)NSArray *imageBtnArray;
@property(nonatomic,strong)NSArray *deleteBtnArray;

@property(nonatomic,strong)NSMutableArray *heightArray;

@property(nonatomic,strong)CPChoicePhoto *choicePhoto;

@end

//上门信息-+照片
//上门信息-删除照片

@implementation ABDoorTableViewController

+ (ABDoorTableViewController *)getDoorTableViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"ServerItem&Door" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ABDoorTableViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self p_loadCustomerDescription];
    
    [self p_refreshImage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加textFiled文本变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除textField文本变化通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Action
//todo KYS
- (IBAction)imageBtnAction:(UIButton *)btn {
    [self p_resignFirstResponder];
    
    __weak typeof(self) wSelf=self;
    [self.choicePhoto showPhotoChoicesWith:^(UIImage *choiceImage) {
        
        // 选中图片后进行上传
        [CustomToast showWatingInView:self.view.superview];
        [KABNetworkManager updaleImage:choiceImage success:^(id responseObject) {
            [CustomToast hideWatingInView:self.view.superview];
            if (checkNetworkResultObject(responseObject)) {
                ABLog(@"%d",btn.tag);
                if (wSelf.photoIdsArrayM.count>btn.tag) {
                    [wSelf.photoIdsArrayM replaceObjectAtIndex:btn.tag withObject:responseObject[@"image_id"]];
                    [wSelf.imageArray replaceObjectAtIndex:btn.tag withObject:choiceImage];
                }else{
                    [wSelf.photoIdsArrayM addObject:responseObject[@"image_id"]];
                    [wSelf.imageArray addObject:choiceImage];
                }
                [wSelf p_refreshImage];
            }
        } failure:^(id object) {
            ABLog(@"上传失败");
            [CustomToast hideWatingInView:self.view.superview];
            if (isConnectingNetwork) {
                [CustomToast showToastWithInfo:@"图片上传失败"];
            }else{
                [CustomToast showNetworkError];
            }
        }];
        
//        [KYSNetwork postImageWithImage:choiceImage success:^(id responseObject) {
//            
//            
//            ABLog(@"上传成功:%@",responseObject);
//        } failureBlock:^(id object) {
//            ABLog(@"上传失败");
//            if (isDisConnectedNetwork) {
//                [CustomToast showToastWithInfo:@"上传图片失败"];
//            }
//        } view:wSelf.view];
    }];
}

- (IBAction)deleteBtnAction:(UIButton *)btn {
    if (btn.tag<self.imageArray.count) {
        [self.imageArray removeObjectAtIndex:btn.tag];
        [self.photoIdsArrayM removeObjectAtIndex:btn.tag];
        [self p_refreshImage];
    }
}

#pragma mark - ABServesAdressViewController
- (void)setAdressWithlocation:(ABLocation *)location{
    ABLog(@"112233445566: %@,%@,%@",location.address,location.longitude,location.latitude);
    _location=location;
    [self p_refreshAddress];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.heightArray[indexPath.row] floatValue];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ABLog(@"%ld",(long)indexPath.row);
    [self p_resignFirstResponder];
//    if (0 == indexPath.row) {
//        //进入选择地址页面
//        ABLog(@"进入选择地址页面");
//        [self p_enterAddressViewController];
//    }else if( 1==indexPath.row){
//        //弹出时间选择页面
//        ABLog(@"弹出时间选择页面");
//        if ([_delegate respondsToSelector:@selector(showDatePicker)]) {
//            [_delegate showDatePicker];
//        }
//    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_contactsTextField==textField||_mobileTextField==textField){
        return YES;
    }
    //显示pickerView
    if (_serverAddressTextField==textField) {
        //进入选择地址页面
        ABLog(@"进入选择地址页面");
        [self p_resignFirstResponder];
        [self p_enterAddressViewController];
    }else if (_serverTimeTextField==textField) {
        //弹出时间选择页面
        ABLog(@"弹出时间选择页面");
        if ([_delegate respondsToSelector:@selector(showDatePicker)]) {
            [self p_resignFirstResponder];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_delegate showDatePicker];
            });
        }
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (range.location>=(_contactsTextField==textField?10:20)){
//        return NO;
//    }
//    //限制输入字符数
//    ABLog(@"%@  %@",textField.text,string);
//    if (textField.text.length>(_contactsTextField==textField?10:20)) {
//        textField.text=[textField.text substringToIndex:(_contactsTextField==textField?10:20)];
//        return NO;
//    }
    return YES;
}

#pragma mark - UITextFieldTextDidChangeNotification
- (void)textFieldTextChange:(NSNotification *)not{
    ABLog(@"textFieldTextChange:%@",not.object);

    UITextField *textField=not.object;
    
    if (_contactsTextField == textField ) {
        
        return;
    }
    
    if (textField.text.length>(_contactsTextField==textField?10:20)) {
        textField.text=[textField.text substringToIndex:(_contactsTextField==textField?10:20)];
    }
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    _desLabel.hidden=textView.text.length?YES:NO;
    if (textView.text.length>100) {
        textView.text=[textView.text substringToIndex:100];
    }
    _wordCountLabel.text=[NSString stringWithFormat:@"%lu/100",(unsigned long)textView.text.length];
}

// ----------------------------------- by fhhe Start--------------------------------
//#pragma mark - UIScrollViewDelegate 
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    // 获取当前界面的第一响应对象
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//    if (firstResponder==_desTextView) {
//        return;
//    }
//    // 退出键盘
//    [firstResponder resignFirstResponder];
//}
// ----------------------------------- by fhhe End--------------------------------


#pragma mark - private
- (void)p_resignFirstResponder{
    [_serverAddressTextField resignFirstResponder];
    [_serverTimeTextField resignFirstResponder];
    [_contactsTextField resignFirstResponder];
    [_mobileTextField resignFirstResponder];
    [_desTextView resignFirstResponder];
}

//进入选择地址页
- (void)p_enterAddressViewController{
    //company_location
    ABServesAdressViewController *addVC=[ABServesAdressViewController servesAdressViewControllerWithLocation:_location isNeededHistory:YES];
    addVC.title = @"服务地址";    
    addVC.servesAdressDelegate=self;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)p_refreshImage{
    for (int i=0; i<3; i++) {
        ((UIButton *)self.imageBtnArray[i]).hidden=i<=self.imageArray.count?NO:YES;
        [((UIButton *)self.imageBtnArray[i]) setBackgroundImage:i<self.imageArray.count ? self.imageArray[i]:[UIImage imageNamed:@"上门信息-+照片"] forState:UIControlStateNormal];
        ((UIButton *)self.deleteBtnArray[i]).hidden=i<self.imageArray.count?NO:YES;
    }
}

//加载个人信息
- (void)p_loadCustomerDescription{
    ABLog(@"p_loadCustomerDescription");
    //获取历史地址
    //NSArray *historyLocations = [[ABHistoryLocations sharedHistoryLocations] getHistoryLocations];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSnapshot"];
    ABLog(@"lastSnapshot %@",dic);
    //if (historyLocations.count>=1) {
    if (dic[@"company_contact"]) {
        //记录个人信息里的地址
        //_location=historyLocations[0];
        _location=[ABLocation locationWithDict:dic[@"company_location"]];
        ABLog(@"本地数据 %@ %@ %@ %@",_location.name,_location.no,_location.longitude,_location.latitude);
        ABLog(@"%@",dic);
        [self p_refreshAddress];
        _contactsTextField.text=dic[@"company_contact"];
        _mobileTextField.text=dic[@"company_tel"];
    }else{
        __weak typeof(self) wSelf=self;
        [KYSNetwork getCustomerDescriptionWithParameters:nil success:^(id responseObject) {
            //ABLog(@"网络返回数据： %@",responseObject);
            if (responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
                //记录个人信息里的地址
                wSelf.contactsTextField.text=responseObject[@"profile"][@"company_contact"];
                wSelf.mobileTextField.text=responseObject[@"profile"][@"company_tel"];
                NSDictionary *dic=responseObject[@"profile"][@"company_location"];
                NSString *name=dic[@"name"];
                if (name.length) {
                    wSelf.location=[ABLocation locationWithDict:dic];
                    ABLog(@" Net p_refreshData %@ %@",wSelf.location.name,wSelf.location.no);
                    [wSelf p_refreshAddress];
                    return;
                }
            } 
            wSelf.location=nil;
        } failureBlock:^(id object) {
            wSelf.location=nil;
        } view:self.view.superview];
    }
}

- (void)p_refreshAddress{
    //1.刷新地址
    _serverAddressTextField.text=[NSString stringWithFormat:@"%@%@",_location.name?:@"",_location.no?:@""];
    
    //2.刷新服务范围
    _regionTextView.text=@"";
    ABLog(@"p_refreshAddress: %@",_location.city);
    NSArray *serverArray=[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTKEY_SERVICECITIES];
    for (NSDictionary *dic in serverArray) {
        ABLog(@"p_refreshAddress %@",dic);
        if ([dic[@"name"] isEqualToString:_location.city]||[_location.city hasPrefix:dic[@"name"]]) {
            _regionTextView.text=[NSString stringWithFormat:@"城市服务范围:（%@）%@",dic[@"name"],dic[@"service_range"]];
            break;
        }
    }
    
    NSString *des=_regionTextView.text;
    NSInteger height = [des sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(ScreenWidth-30, 10000) mode:NSLineBreakByWordWrapping].height;
    [self.heightArray replaceObjectAtIndex:self.heightArray.count-1 withObject:@(height+30)];
    [self.tableView reloadData];
}

#pragma mark - data
- (NSMutableArray *)heightArray{
    if (!_heightArray) {
        _heightArray=[@[@(45),@(45),@(45),@(45),@(150),@(110),@(0)] mutableCopy];
    }
    return _heightArray;
}


- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray=[[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSArray *)imageBtnArray{
    if (!_imageBtnArray) {
        _imageBtnArray=@[_imageBtn1,_imageBtn2,_imageBtn3];
    }
    return _imageBtnArray;
}

- (NSArray *)deleteBtnArray{
    if (!_deleteBtnArray) {
        _deleteBtnArray=@[_deleteBtn1,_deleteBtn2,_deleteBtn3];
    }
    return _deleteBtnArray;
}

- (CPChoicePhoto *)choicePhoto{
    if (!_choicePhoto) {
        _choicePhoto=[[CPChoicePhoto alloc] init];
    }
    return _choicePhoto;
}

- (NSMutableArray *)photoIdsArrayM {
    if (!_photoIdsArrayM) {
        _photoIdsArrayM = [NSMutableArray array];
    }
    return _photoIdsArrayM;
}

@end
