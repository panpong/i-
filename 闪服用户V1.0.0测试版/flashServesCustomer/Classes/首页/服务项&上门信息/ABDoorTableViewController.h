//
//  ABDoorTableViewController.h
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABLocation;

////登录手机号
//#define MOBILE [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]
//
//#define CONTACT_MSG [NSString stringWithFormat:@"%@.door.msg",MOBILE]
//#define CONTACT_MAN @"contact.man"
//#define CONTACT_NUM @"contact.num"

#define DOOR_DATE_TIME @"yyyy-MM-dd EEEE HH:mm"
#define DOOR_DATE @"yyyy-MM-dd EEEE"
#define DOOR_TIME @"HH:mm"


@protocol ABDoorTableViewControllerDelegate <NSObject>

- (void)showDatePicker;
- (void)getSelectedDate:(NSDate *)date;

@end

@interface ABDoorTableViewController : UITableViewController

@property(nonatomic,weak)__weak id<ABDoorTableViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *serverAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *serverTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactsTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UITextView *desTextView;

@property (nonatomic,strong)NSMutableArray *imageArray;

@property (weak, nonatomic) IBOutlet UITextView *regionTextView;

@property (nonatomic,strong)ABLocation *location;

@property(nonatomic,strong) NSMutableArray *photoIdsArrayM;  // 上传图片的id数组

+ (ABDoorTableViewController *)getDoorTableViewController;

@end
