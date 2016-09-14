//
//  ABServerItemCollectionReusableView.m
//  flashServesCustomer
//
//  Created by Liu Zhao on 16/4/23.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServerItemCollectionReusableView.h"
//#import "ABCollectionConfig.h"

@interface ABServerItemCollectionReusableView()

@property(nonatomic,strong)UIImageView *titleImageView;

@end


@implementation ABServerItemCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        self.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];;
        
        UIView *backView=[[UIView alloc] init];
        backView.frame=CGRectMake(0, 10, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-10);
        backView.backgroundColor=[UIColor whiteColor];
        [self addSubview:backView];
        
        UIImage *titleImage=[UIImage imageNamed:@"服务项-服务类型"];
        _titleImageView=[[UIImageView alloc] init];
        _titleImageView.image=titleImage;
        _titleImageView.contentMode=UIViewContentModeCenter;
        _titleImageView.backgroundColor=backView.backgroundColor;
        _titleImageView.frame=CGRectMake(15, 0, titleImage.size.width, CGRectGetHeight(backView.frame));
        [backView addSubview:_titleImageView];
        
        _titleLabel=[[UILabel alloc] init];
        _titleLabel.frame=CGRectMake(15+titleImage.size.width+15, 0, CGRectGetWidth(backView.frame), CGRectGetHeight(backView.frame));
        _titleLabel.backgroundColor=backView.backgroundColor;
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.font=[UIFont systemFontOfSize:15.0];
        [backView addSubview:_titleLabel];
        
        UIView *lineView=[[UIView alloc] init];
        lineView.frame=CGRectMake(0, CGRectGetHeight(backView.frame)-1, CGRectGetWidth(backView.frame), 1);
        lineView.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [backView addSubview:lineView];
    }
    return self;
}


@end
