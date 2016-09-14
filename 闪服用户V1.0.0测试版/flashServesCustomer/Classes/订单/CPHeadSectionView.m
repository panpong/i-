//
//  CPHeadSectionView.m
//  flashServesCustomer
//
//  Created by yjin on 16/4/26.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPHeadSectionView.h"
@interface CPHeadSectionView()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelText;

@property (weak, nonatomic) IBOutlet UILabel *labelText2;

@end


@implementation CPHeadSectionView

+ (instancetype)headSectionView {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CPHeadSectionView" owner:nil options:nil];
    // Find the view among nib contents (not too hard assuming there is only one view in it).
    CPHeadSectionView *plainView = [nibContents lastObject];
    
    return plainView;
    
}

- (void)settingHeadSection:(NSString *)imageString title:(NSString *)title {
    
    _labelText.text = title;
    _imageViewIcon.image = [UIImage imageNamed:imageString];
    _labelText2.hidden = YES;
    _labelText.font = [UIFont boldSystemFontOfSize:15];
    
}

- (void)settingHeadSection:(NSString *)imageString title:(NSString *)title text2:(NSString *)text2 {
    _labelText.text = title;
    _imageViewIcon.image = [UIImage imageNamed:imageString];
    
    _labelText.font = [UIFont boldSystemFontOfSize:15];
    
    _labelText2.text = text2;
    _labelText2.textColor = kColorOrange;
    _labelText2.font = [UIFont boldSystemFontOfSize:14];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
