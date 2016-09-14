//
//  ABAboutMeViewController.m
//  flashServes
//
//  Created by Liu Zhao on 16/6/13.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABAboutMeViewController.h"
#import "UIViewController+CustomNavigationBar.h"

@interface ABAboutMeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImageViewTop;

@end

@implementation ABAboutMeViewController

+ (ABAboutMeViewController *)getAboutMeViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Me" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ABAboutMeViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarItem:@"关于我们" leftButtonIcon:@"返回" rightButtonTitle:nil];
    
    if (iPhone5) {
        _ImageViewTop.constant=_ImageViewTop.constant/3*2;
    }
    
    _imageView.layer.cornerRadius=10;
    _imageView.layer.masksToBounds=YES;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text=[NSString stringWithFormat:@"V%@",app_Version];
    
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] init];
    {
        NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                            NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString *str=[[NSAttributedString alloc] initWithString:@"联系电话 " attributes:dic];
        [attStr appendAttributedString:str];
    }
    {
        NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                            NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1]};
        NSAttributedString *str=[[NSAttributedString alloc] initWithString:SERVICE_PHONE_NUM attributes:dic];
        [attStr appendAttributedString:str];
    }
    _mobileLabel.attributedText=attStr;
}

- (IBAction)tap:(id)sender {
    NSLog(@"%@",SERVICE_PHONE_NUM);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",SERVICE_PHONE_NUM];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


@end
