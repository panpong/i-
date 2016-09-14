//
//  ABProfileAreaViewController.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/20.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABProfileAreaViewController.h"
#import "ABMyProfileViewController.h"
#import "NSDictionary+KYSAddition.h"
#import "KYSNetwork.h"
#import "ABServesAdressViewController.h"
#import "ABLocation.h"
#import "CustomToast.h"

@interface ABProfileAreaViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ABServesAdressViewController>

@property (weak, nonatomic) IBOutlet UITextField *linkmanTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberStaffTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberDeviceTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthServesTimesTextField;

@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;
@property (weak, nonatomic) IBOutlet UIImageView *numberStaffImageView;
@property (weak, nonatomic) IBOutlet UIImageView *numberDviceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *monthServesTimesImageview;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *selectView;
@property (nonatomic,strong) NSArray *dateArray;
@property (nonatomic,strong) UIPickerView *pickView;

@property (nonatomic,strong) NSArray *staffArray;
@property (nonatomic,strong) NSArray *deviceArray;
@property (nonatomic,strong) NSArray *servicesArray;

@property (nonnull,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,strong)ABLocation *location;

@end

@implementation ABProfileAreaViewController

+ (ABProfileAreaViewController *)getProfileAreaViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Me" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ABProfileAreaViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    _bottomBtn.layer.cornerRadius=3.0;
    _bottomBtn.layer.masksToBounds=YES;
    
    _addressImageView.hidden=!_isUpdate;
    _numberStaffImageView.hidden=!_isUpdate;
    _numberDviceImageView.hidden=!_isUpdate;
    _monthServesTimesImageview.hidden=!_isUpdate;
    
    if (!_isUpdate) {
        _linkmanTextField.placeholder=@"";
        _mobileTextField.placeholder=@"";
        _companyTextField.placeholder=@"";
        _addressTextField.placeholder=@"";
        _numberStaffTextField.placeholder=@"";
        _numberDeviceTextField.placeholder=@"";
        _monthServesTimesTextField.placeholder=@"";
    }
    
    [_bottomBtn setTitle:_isUpdate?@"保存":@"修改资料" forState:UIControlStateNormal];
    
    if (_isUpdate) {
        [self p_refreshData];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotification:) name:@"update.profile.success" object:nil];
        [self p_loadCustomerDescription];
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
- (IBAction)bottonBtnAction:(id)sender {
    if (_isUpdate) {
        //if ([self p_checkProfile]) {
            //保存数据
            [self p_updateProfile];
        //}
    }else{
        ABMyProfileViewController *myProfileViewController=[[ABMyProfileViewController alloc] init];
        myProfileViewController.dataDic=_dataDic;
        myProfileViewController.isUpdate=YES;
        [self.navigationController pushViewController:myProfileViewController animated:YES];
    }
}

//pickerView
- (void)tap{
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
}

- (void)btnAction:(UIButton *)btn{
    ABLog(@"%ld",(long)btn.tag);
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
    if(2==btn.tag){
        NSInteger row=[self.pickView selectedRowInComponent:0];
        if (7==_selectedIndexPath.row) {
            self.numberStaffTextField.text=self.staffArray[row+1];
        }else if (8==_selectedIndexPath.row){
            self.numberDeviceTextField.text=self.deviceArray[row+1];
        }else if (9==_selectedIndexPath.row){
            self.monthServesTimesTextField.text=self.servicesArray[row+1];
        }
    }
}

- (void)updateNotification:(NSNotification *)notification{
    NSLog(@"%@",notification.object);
    _dataDic=notification.object;
    [self p_refreshData];
}

#pragma mark - ABServesAdressViewController
- (void)setAdressWithlocation:(ABLocation *)location{
    NSLog(@"setAdressWithlocation: %@ %@",location.name,location.no);
    _location=location;
    _addressTextField.text=[NSString stringWithFormat:@"%@%@",_location.name?:@"",_location.no?:@""];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    [self p_resignFirstResponder];
    
    if (indexPath.row>=7&&indexPath.row<=9) {
        [self p_showPickerViewWithIndexPath:indexPath];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_linkmanTextField==textField||_mobileTextField==textField||_companyTextField==textField){
        return _isUpdate;
    }
    //显示pickerView
    if (_numberStaffTextField==textField) {
        [self p_showPickerViewWithIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    }else if (_numberDeviceTextField==textField) {
        [self p_showPickerViewWithIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    }else if (_monthServesTimesTextField==textField) {
        [self p_showPickerViewWithIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    }else if (_addressTextField==textField) {
        NSLog(@"进入选择地址页");
        if (_isUpdate) {
            [self p_resignFirstResponder];
            [self p_enterAddressViewController];
        }
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField.text.length>=(_linkmanTextField==textField?10:20)) {
//        textField.text=[textField.text substringToIndex:(_linkmanTextField==textField?10:20)-1];
//    }
//    if (range.location>=(_linkmanTextField==textField?10:20)){
//        
//        return NO;
//    }
    return YES;
}

#pragma mark - UITextFieldTextDidChangeNotification
- (void)textFieldTextChange:(NSNotification *)not{
    NSLog(@"textFieldTextChange:%@",not.object);
    UITextField *textField=not.object;
    if (textField.text.length>(_linkmanTextField==textField?10:20)) {
        textField.text=[textField.text substringToIndex:(_linkmanTextField==textField?10:20)];
    }
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dateArray count]-1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dateArray objectAtIndex:row+1];
}

#pragma mark - private
- (void)p_refreshData{
    NSLog(@"ABProfileAreaViewController:%@",_dataDic);
    _linkmanTextField.text=_dataDic[@"company_contact"];
    _mobileTextField.text=_dataDic[@"company_tel"];
    _companyTextField.text=_dataDic[@"company_title"];
    _addressTextField.text=_dataDic[@"company_address"];
    _numberStaffTextField.text=self.staffArray[[_dataDic[@"company_workers"] integerValue]];
    _numberDeviceTextField.text=self.deviceArray[[_dataDic[@"company_devices"] integerValue]];
    _monthServesTimesTextField.text=self.servicesArray[[_dataDic[@"require_services"] integerValue]];
    
    _location=[ABLocation locationWithDict:_dataDic[@"company_location"]];
    NSLog(@"p_refreshData %@ %@",_location.name,_location.no);
    _addressTextField.text=[NSString stringWithFormat:@"%@%@",_location.name?:@"",_location.no?:@""];
}


- (void)p_resignFirstResponder{
    [_linkmanTextField resignFirstResponder];
    [_mobileTextField resignFirstResponder];
    [_companyTextField resignFirstResponder];
}

//加载我的资料数据
- (void)p_loadCustomerDescription{
    __weak typeof(self) wSelf=self;
    [KYSNetwork getCustomerDescriptionWithParameters:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if (responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            [wSelf p_updateProfileWithDic:responseObject[@"profile"]];
        }
    } failureBlock:^(id object) {
        if (isConnectingNetwork) {
            [CustomToast showToastWithInfo:@"加载失败"];
        }
    } view:self.view.superview];
}

- (void)p_updateProfileWithDic:(NSDictionary *)dic{
    _dataDic=dic;
    //刷新页面数据
    [self p_refreshData];
}

- (void)p_enterAddressViewController{
    //company_location
    ABServesAdressViewController *addVC=[ABServesAdressViewController servesAdressViewControllerWithLocation:_location];
    addVC.title = @"公司地址";
    addVC.servesAdressDelegate=self;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (NSDictionary *)p_getSaveDic{
//    NSMutableDictionary *mDic=[@{@"profile":[[self p_getUpdateDic] jsonStringEncoded]} mutableCopy];
//    if (_location) {
//        [mDic setObject:[[self p_getAddressDic] jsonStringEncoded] forKey:@"location"];
//    }
//    return mDic;
    return @{@"profile":[[self p_getUpdateDic] jsonStringEncoded],
             @"location":[[self p_getAddressDic] jsonStringEncoded]};
}

- (NSDictionary *)p_getAddressDic{
    return @{@"name":_location.name?:@"",
             @"address":_location.address?:@"",
             @"no":_location.no?:@"",
             @"longitude":_location.longitude?:@"",
             @"latitude":_location.latitude?:@"",
             @"city":_location.city?:@""};
}

- (NSDictionary *)p_getUpdateDic{
    NSInteger staff=[self.staffArray indexOfObject:_numberStaffTextField.text];
    NSInteger device=[self.deviceArray indexOfObject:_numberDeviceTextField.text];
    NSInteger serves=[self.servicesArray indexOfObject:_monthServesTimesTextField.text];
    
    NSDictionary *profileDic=@{@"company_contact":_linkmanTextField.text?:@"",
                               @"company_tel":_mobileTextField.text?:@"",
                               @"company_title":_companyTextField.text?:@"",
                               @"company_workers":[NSString stringWithFormat:@"%d",(int)(staff>0?staff:0)],
                               @"company_devices":[NSString stringWithFormat:@"%d",(int)(device>0?device:0)],
                               @"require_services":[NSString stringWithFormat:@"%d",(int)(serves>0?serves:0)]};
    
    NSLog(@"%@",profileDic);
    return profileDic;
}

//保存数据
- (void)p_updateProfile{
    NSDictionary *dic=[self p_getSaveDic];
    
    [KYSNetwork updateProfileWithParameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if (responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            [CustomToast showToastWithInfo:@"资料修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            NSMutableDictionary *dic=[[self p_getUpdateDic] mutableCopy];
            [dic setObject:[self p_getAddressDic] forKey:@"company_location"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update.profile.success" object:dic];
        }
    } failureBlock:^(id object) {
        if (isConnectingNetwork){
            [CustomToast showToastWithInfo:@"保存失败"];
        }
    } view:self.view.superview];
}

//验证数据是否合法
- (BOOL)p_checkProfile{
    if (0==_linkmanTextField.text.length) {
        [CustomToast showToastWithInfo:@"请输入公司联系人"];
        return NO;
    }
    if (0==_mobileTextField.text.length) {
        [CustomToast showToastWithInfo:@"请输入公司联系电话"];
        return NO;
    }
    if (0==_companyTextField.text.length) {
        [CustomToast showToastWithInfo:@"请输入公司名称"];
        return NO;
    }
    if (0==_addressTextField.text.length) {
        [CustomToast showToastWithInfo:@"请输入公司地址"];
        return NO;
    }
    if (0==_numberStaffTextField.text.length) {
        [CustomToast showToastWithInfo:@"请选择员工数量"];
        return NO;
    }
    if (0==_numberDeviceTextField.text.length) {
        [CustomToast showToastWithInfo:@"请选择IT设备数量"];
        return NO;
    }
    if (0==_monthServesTimesTextField.text.length) {
        [CustomToast showToastWithInfo:@"请选择月服务次数"];
        return NO;
    }
    return YES;
}

//显示pickerView
- (void)p_showPickerViewWithIndexPath:(NSIndexPath *)indexPath{
    
    if (!_isUpdate) {
        return;
    }

    [self p_resignFirstResponder];

    _selectedIndexPath=indexPath;
    
    [self performSelector:@selector(showPickView) withObject:nil afterDelay:0.5];
}

- (void)showPickView{
    //刷新数据
    self.dateArray=(7==_selectedIndexPath.row)?self.staffArray:(8==_selectedIndexPath.row?self.deviceArray:self.servicesArray);
    [self.pickView reloadComponent:0];
    
    [self.view addSubview:self.backView];
    self.selectView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
    
    //选取指定位置
    NSString *str = (7==_selectedIndexPath.row)?_numberStaffTextField.text:(8==_selectedIndexPath.row?_numberDeviceTextField.text:_monthServesTimesTextField.text);
    NSInteger i = [self.dateArray indexOfObject:str]-1;
    if (-1==i) {
        i=0;
    }
    [self.pickView selectRow:i inComponent:0 animated:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, self.view.frame.size.height-180, self.view.frame.size.width, 180);
    } completion:^(BOOL finished) {
        //CGRectMake(0, _backView.frame.size.height-180, self.view.frame.size.width, 180)
    }];
}

#pragma mark - data
- (NSArray *)staffArray{
    if (!_staffArray) {
        _staffArray=@[@"",@"20人以下",@"20-50人",@"50-100人",@"100人以上"];
    }
    return _staffArray;
}

- (NSArray *)deviceArray{
    if (!_deviceArray) {
        _deviceArray=@[@"",@"20台以下",@"20-50台",@"50-100台",@"100台以上"];
    }
    return _deviceArray;
}

- (NSArray *)servicesArray{
    if (!_servicesArray) {
        _servicesArray=@[@"",@"1次及以下",@"2-4次",@"4次以上"];
    }
    return _servicesArray;
}

- (UIView *)backView{
    
    if (!_backView) {
        _backView=[[UIView alloc] initWithFrame:self.tableView.bounds];
        _backView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.15];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_backView addGestureRecognizer:tap];
        
        _selectView=[[UIView alloc] init];
        _selectView.backgroundColor=[UIColor whiteColor];
        _selectView.frame=CGRectMake(0, _backView.frame.size.height-180, self.view.frame.size.width, 180);
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
        
        _pickView=[[UIPickerView alloc] init];
        _pickView.frame=CGRectMake(0, 30, _selectView.frame.size.width, _selectView.frame.size.height-30);
        _pickView.showsSelectionIndicator=YES;
        _pickView.backgroundColor=[UIColor whiteColor];
        _pickView.delegate=self;
        _pickView.dataSource=self;
        [_selectView addSubview:_pickView];
    }
    return _backView;
}

@end
