//
//  ABServesProgressScrollView.m
//  flashServesCustomer
//
//  Created by 002 on 16/4/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABServesProgressScrollView.h"
#import "UIImageView+Extention.h"
#import "UIView+Extention.h"

#define SIZE_HEIGHT_PROGRESSVIEW 75   // 流程图的高度
#define SIZE_HEIGHT_PROGRESSVIEW_IPHONE5 (75 / 11 * 9)   // 流程图的高度
#define SIZE_HEIGHT_PROGRESSVIEW_IPHONE6PLUS 92.5   // 流程图的高度
//#define SIZE_WIDTH_PROGRESSVIEW 110   // 流程图的宽度
#define PADDING_BETWEENT_PROGRESSVIEW 10   // 两张‘流程图’之间的间距
#define PADDING_BETWEENT_PROGRESSVIEW_IPHONE5 (PADDING_BETWEENT_PROGRESSVIEW / 4 * 3)   // IPHONE5下两张‘流程图’之间的间距
#define SIZE_WIDTH_PROGRESSVIEW ((ScreenWidth - 2 * PADDING_30PX - 2 * PADDING_BETWEENT_PROGRESSVIEW) / 3)  // 流程图的宽度
#define SIZE_WIDTH_PROGRESSVIEW_IPHONE5 ((ScreenWidth - 2 * (PADDING_30PX / 4 * 3) - 2 * (PADDING_BETWEENT_PROGRESSVIEW / 4 * 3)) / 3)  // 流程图的宽度

@interface ABServesProgressScrollView ()

@property(nonatomic,strong) UIImageView *progressImageView1;
@property(nonatomic,strong) UIImageView *progressImageView2;
@property(nonatomic,strong) UIImageView *progressImageView3;

@property(nonatomic,strong) NSArray *imagesName;

@end

@implementation ABServesProgressScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    // 1. 添加控件
    [self addSubview:self.progressImageView1];
    [self addSubview:self.progressImageView2];
    [self addSubview:self.progressImageView3];
    
    // 2. 布局
    self.progressImageView1.width = SIZE_WIDTH_PROGRESSVIEW;
    if (iPhone5) {
        self.progressImageView1.width = SIZE_WIDTH_PROGRESSVIEW_IPHONE5;
    }
    if (iPhone5) {
        self.progressImageView1.height = SIZE_HEIGHT_PROGRESSVIEW;
        self.progressImageView1.y = 10 / 4 * 3;
        self.progressImageView1.x = PADDING_30PX / 4 * 3;
    } else if(iPhone6Plus) {
        self.progressImageView1.height = SIZE_HEIGHT_PROGRESSVIEW_IPHONE6PLUS;
        self.progressImageView1.y = 10;
        self.progressImageView1.x = PADDING_30PX;

    }else {
        self.progressImageView1.height = SIZE_HEIGHT_PROGRESSVIEW;
        self.progressImageView1.y = PADDING_30PX;
        self.progressImageView1.x = PADDING_30PX;
    }
    
    self.progressImageView2.width = self.progressImageView1.width;
    if (iPhone5) {
        self.progressImageView2.height = self.progressImageView1.height;
        self.progressImageView2.y = self.progressImageView1.y;
        self.progressImageView2.x = self.progressImageView1.right + PADDING_BETWEENT_PROGRESSVIEW / 4 * 3;
    } else if(iPhone6Plus) {
        self.progressImageView2.height = self.progressImageView1.height;
        self.progressImageView2.y = self.progressImageView1.y;
        self.progressImageView2.x = self.progressImageView1.right + PADDING_BETWEENT_PROGRESSVIEW;
    } else {
        self.progressImageView2.height = self.progressImageView1.height;
        self.progressImageView2.y = self.progressImageView1.y;
        self.progressImageView2.x = self.progressImageView1.right + PADDING_BETWEENT_PROGRESSVIEW;
    }
    
    self.progressImageView3.width = self.progressImageView1.width;
    if (iPhone5) {
        self.progressImageView3.height = self.progressImageView1.height;
        self.progressImageView3.x = self.progressImageView2.right + PADDING_BETWEENT_PROGRESSVIEW / 4 * 3;
        self.progressImageView3.y = self.progressImageView1.y;
    } else if(iPhone6Plus) {
        self.progressImageView3.height = self.progressImageView1.height;
        self.progressImageView3.x = self.progressImageView2.right + PADDING_BETWEENT_PROGRESSVIEW;
        self.progressImageView3.y = self.progressImageView1.y;
    }else {
        self.progressImageView3.height = self.progressImageView1.height;
        self.progressImageView3.x = self.progressImageView2.right + PADDING_BETWEENT_PROGRESSVIEW;
        self.progressImageView3.y = self.progressImageView1.y;
    }
}

#pragma mark - 懒加载
- (UIImageView *)progressImageView1 {
    if (!_progressImageView1) {
        _progressImageView1 = [UIImageView imageName:self.imagesName[0]];
        _progressImageView1.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _progressImageView1;
}

- (UIImageView *)progressImageView2 {
    if (!_progressImageView2) {
        _progressImageView2 = [UIImageView imageName:self.imagesName[1]];
        _progressImageView2.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _progressImageView2;
}

- (UIImageView *)progressImageView3 {
    if (!_progressImageView3) {
        _progressImageView3 = [UIImageView imageName:self.imagesName[2]];
        _progressImageView3.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _progressImageView3;
}

- (NSArray *)imagesName {
    if (!_imagesName) {
        _imagesName = [NSArray arrayWithObjects:@"首页-响应急速",@"首页-过程安全",@"首页-价格透明", nil];
    }
    return _imagesName;
}

@end
