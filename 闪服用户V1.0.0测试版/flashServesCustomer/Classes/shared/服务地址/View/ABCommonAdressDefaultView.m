//
//  ABCommonAdressDefaultView.m
//  flashServes
//
//  Created by 002 on 16/4/7.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABCommonAdressDefaultView.h"

@interface ABCommonAdressDefaultView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label1TopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label2TopConstraint;


@end

@implementation ABCommonAdressDefaultView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (iPhone5) {
        self.label1TopConstraint.constant = self.label1TopConstraint.constant / 3 * 2;
        self.label2TopConstraint.constant = self.label2TopConstraint.constant / 3 * 2;
    }
    
    return self;
}

@end
