//
//  CPChoicePhoto.m
//  flashServes
//
//  Created by yjin on 16/3/17.
//  Copyright © 2016年 002. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CPChoicePhoto.h"
#import "AppDelegate.h"
@interface CPChoicePhoto()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)UIActionSheet *sheet;
@property (nonatomic, strong)void(^ choiceImage)(UIImage *choiceImage) ;


@property (nonatomic, strong)UIImagePickerController *pickerController;

@end
@implementation CPChoicePhoto

- (instancetype)init {
    
    
    if (self = [super init]) {
        
        self.isOriginImage = YES;
    }
    return self;
    
}


- (void)showPhotoChoicesWith:(void (^)(UIImage *))choiceImage {
    
    self.sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择照片",@"拍照" ,nil];
  
    self.choiceImage = choiceImage;
    if (self.isOriginImage) {
        self.pickerController.allowsEditing = NO;
    }else {
        
        self.pickerController.allowsEditing = YES;
    }
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [self.sheet showInView:delegate.window];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  
    UIImagePickerControllerSourceType sourceType ;
    
    if (buttonIndex == 2) { // 取消
        
        return;
    }
    
    if (buttonIndex == 1) {
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else {
        
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
     //初始化
    self.pickerController.delegate = self;
//    _pickerController.allowsEditing = NO;//设置可编辑
    _pickerController.sourceType = sourceType;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:_pickerController animated:YES completion:nil];
    
   
}

- (UIImagePickerController *)pickerController {
    
    if (_pickerController == nil) {
        
        _pickerController = [[UIImagePickerController alloc] init];
    }
    return _pickerController;
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    UIImage *image = nil;
    if (self.isOriginImage) {
        
        image = info[@"UIImagePickerControllerOriginalImage"];
        
        
    }else {
        
        image = info[@"UIImagePickerControllerEditedImage"];
    }
    
   
    self.choiceImage(image);
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [delegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
    _pickerController = nil;
}

// 点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
 
    [delegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
