//
//  CPSkillView.m
//  flashServes
//
//  Created by yjin on 16/3/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPSkillView.h"
//#import "CPDateModal.h"
#import "UIView+Extention.h"
#define colorOrigin [UIColor colorWithRed:255/255.0 green:168/255.0 blue:65/255.0 alpha:1]
#import "UIImageView+Extention.h"
@interface CPSkillView()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *imageView;


@end

@implementation CPSkillView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
       
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:@"完善资料-认证V"]];
        _imageView = imageView;
        [_imageView sizeToFit];
        
        
    }
    return self;
}

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:colorOrigin];
        [_titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        _titleLabel.layer.borderWidth=1.0;
        _titleLabel.layer.borderColor= colorOrigin.CGColor;
        _titleLabel.layer.cornerRadius=2.0;
        _titleLabel.layer.masksToBounds=YES;
        
        [self addSubview:_titleLabel];
        [self addSubview:_imageView];
    }
    
    return _titleLabel;
    
}


- (void)setModal:(NSDictionary *)modal {
    
    _modal = modal;
    
    [self.titleLabel setText:modal[@"name"]];
    [self.titleLabel sizeToFit];
    self.titleLabel.width = self.titleLabel.width > (ScreenWidth - 24 - 30) ?  ScreenWidth - 24 - 30 :  self.titleLabel.width;
    
    
//    self.bounds = CGRectMake(0, 0, (self.titleLabel.width + 12 + 12), 30);
    
    self.titleLabel.frame = CGRectMake(0, _imageView.height * 0.5, self.titleLabel.width + 24, 30);
    
    self.bounds = _titleLabel.bounds;
    self.height = self.height + 10;
    _imageView.x = self.width - _imageView.width;
    _imageView.y = 0;
    
    if ([modal[@"type"] integerValue] == 0) {
        _imageView.hidden = YES;
    }else {
        _imageView.hidden = NO;
    }
    
    
}




//- (void)setHasSelected:(BOOL)hasSelected{
//    if (hasSelected) {
//        _titleLabel.backgroundColor=[UIColor colorWithRed:255/255.0 green:168/255.0 blue:65/255.0 alpha:1];
//        _titleLabel.textColor=[UIColor whiteColor];
//    }else{
//        _titleLabel.backgroundColor=[UIColor whiteColor];
//        _titleLabel.textColor=[UIColor colorWithRed:255/255.0 green:168/255.0 blue:65/255.0 alpha:1];
//    }
//    _hasSelected=hasSelected;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

