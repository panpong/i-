//
//  CPOrderQustionImageCell.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPOrderQustionImageCell.h"
#import <UIImageView+WebCache.h>
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface CPOrderQustionImageCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UIImageView *imageView3;


@property (weak, nonatomic) IBOutlet UILabel *labelText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTextMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLine;




@end


@implementation CPOrderQustionImageCell


+ (instancetype)CPOrderQustionImageCell
:(UITableView *)table {
    
    // 要和xib 中 cell 的reuse 一样
    static NSString * const reuseID = @"CPOrderQustionImageCell";
    CPOrderQustionImageCell * cell = [table dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        [table registerNib:[UINib nibWithNibName:@"CPOrderQustionImageCell" bundle:nil] forCellReuseIdentifier:reuseID];
        cell = [table dequeueReusableCellWithIdentifier:reuseID];
     

    }
    cell.imageView1.userInteractionEnabled = YES;
    cell.imageView2.userInteractionEnabled = YES;
    cell.imageView3.userInteractionEnabled = YES;
    if ([cell.imageView1 subviews].count == 0) {
        
        [cell addButtonWith:cell.imageView1 tag:0];
        [cell addButtonWith:cell.imageView2 tag:1];
        [cell addButtonWith:cell.imageView3 tag:2];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:cell selector:@selector(notificationImage:) name:@"imageViewClickNotification" object:nil];
    return cell;
}


- (void)addButtonWith:(UIImageView *)imageView tag:(int)index {
    
    UIButton *button = [[UIButton alloc] init];
    
    button.frame = CGRectMake(0, 0, [self  imageWidthHeight], [self  imageWidthHeight]);
    button.tag = index;
    [button addTarget:self action:@selector(imageViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
}
- (void)imageViewButtonClick:(UIButton *)button {
    
    [self settingBrowser:button.tag];
}


- (void)notificationImage:(NSNotification *)notification {
    
    NSDictionary *userDic = notification.userInfo;
    [self settingBrowser:[userDic[@"key"] integerValue]];
    

}

- (void)settingBrowser:(NSInteger)index {

    NSArray *arrayPhotos = [_modal.failurePhotos componentsSeparatedByString:@"|"];

    NSArray *arrayImage = @[_imageView1,_imageView2,_imageView3];
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < arrayPhotos.count; i++) {

        NSString *url = arrayPhotos[i];
        MJPhoto *photo = [[MJPhoto alloc] init];

        photo.srcImageView = arrayImage[i];

        if (url.length == 0) {

            NSString *stringPath = [[NSBundle mainBundle] pathForResource:@"ios-站点实景图@2x.png" ofType:nil];

            photo.url =  [NSURL fileURLWithPath:stringPath];


        }else {

            photo.url = [NSURL URLWithString:url]; // 图片路径
        }


        [photos addObject:photo];
    }

    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];

}


- (void)setModal:(CPModalOrder *)modal {
    
    _modal = modal;
    _labelText.text = modal.failureDesc;
    
    if (_modal.failureDesc.length == 0 && _modal.failurePhotos.length != 0) {
        
        [self hideTextFailure];
       
    }
    
    if (_modal.failureDesc.length != 0 && _modal.failurePhotos.length == 0  ) {
        
        [self hideImageFailre];
    }
    
    if (_modal.failurePhotos.length != 0) {
        NSArray *imageArray = @[_imageView1,_imageView2,_imageView3];
        NSArray *array = [_modal.failurePhotos componentsSeparatedByString:@"|"];
        for (int i = 0 ; i < array.count; i++) {
            NSString *url = array[i];
            UIImageView *iamge = imageArray[i];
            [iamge sd_setImageWithURL:[NSURL URLWithString:url]];
            
        }
    }
  
    
}

- (CGFloat)cellHeight {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:_labelText.font forKey:NSFontAttributeName];
    CGSize size = CGSizeMake(ScreenWidth - 15 - 15, 300);
    
    if (_modal.failureDesc.length == 0 && _modal.failurePhotos.length != 0) {
        
        return [self showOnlyImage];
    }
   
    CGRect stringBound = [_modal.failureDesc boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
   
    if (_modal.failureDesc.length != 0 && _modal.failurePhotos.length != 0) {
        
        return [self AllShow:stringBound];
    }

    if (_modal.failureDesc.length != 0 && _modal.failurePhotos.length == 0  ) {
        
        return [self showOnlyText:stringBound];
    }
  
    return 0;
 }

- (CGFloat)AllShow:(CGRect)rect {
    
    
    return 10 + 18 + 8 +  rect.size.height + 8 + [self imageWidthHeight] + 10;
}

-(CGFloat)showOnlyText:(CGRect)rect {
  
    return 10 + 18 + 8 +  rect.size.height + 10;
}

- (CGFloat)showOnlyImage {
    

    return 10 + 18 + 8 + [self imageWidthHeight ] + 10 ;
}


- (CGFloat)imageWidthHeight {
    
    if (iPhone4 || iPhone5) {
        
       return 75;
        
    }else {
        
       return 90;
    }
    
}


- (void)awakeFromNib {
    // Initialization code

    _imageWidth.constant = [self imageWidthHeight];
 
}


// 隐藏各个部位
- (void)hideTextFailure {
    _imageViewTextMargin.constant = 0;
    
}

- (void)hideImageFailre {
    
    _imageWidth.constant = 0;
    _heightLine.constant = 0;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
