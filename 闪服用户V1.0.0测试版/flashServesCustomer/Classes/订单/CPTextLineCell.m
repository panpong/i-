//
//  CPTextLineCell.m
//  flashServes
//
//  Created by yjin on 16/4/25.
//  Copyright © 2016年 002. All rights reserved.
//

// 28
#import "CPTextLineCell.h"
#import "UIView+Extention.h"
@interface CPTextLineCell ()
// 提示文字
@property (nonatomic, strong)UILabel *labelHint;

// 文字内容
@property  (nonatomic, strong)UILabel *labelContent;



@end


@implementation CPTextLineCell

- (UILabel *)labelContent {
    
    if (_labelContent == nil) {
        
        _labelContent  = [[UILabel alloc] init];
        [self addSubview:_labelContent];
    }
    return _labelContent;
    
}

- (UILabel *)labelHint {
    
    if (_labelHint == nil) {
        
        _labelHint = [[UILabel alloc] init];
        [self addSubview:_labelHint];
    }
    return _labelHint;
    
}

- (void)awakeFromNib {
    

    
}

- (void)setLineHint:(NSString *)hint content:(NSString *)content type:(CPLineCellType )type {
    
    
    self.labelContent.text = content;
    self.labelContent.font = [UIFont systemFontOfSize:15];
    if (hint.length == 0 || content.length == 0 ) {
        
        for(NSLayoutConstraint *constraint in self.constraints) {
            
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                
                constraint.constant = 0;
                
            }
        }
    
    }else {
        
    // 对地址换行 进行处理
        if (type == CPLineCellTypeConmentTextAddress) {
            
            for(NSLayoutConstraint *constraint in self.constraints) {
                
                if (constraint.firstAttribute == NSLayoutAttributeHeight && [self heightContent] > 28) {
                    
                      constraint.constant = [self heightContentLayout];
                }
                
            }
   
        }
        
    }
     
    self.labelHint.text = hint;
    self.labelHint.font = [UIFont systemFontOfSize:15];
    self.labelHint.textColor = kColorTextGrey;
    self.labelContent.textColor = KColorTextBlack;
    
    [self.labelHint sizeToFit];
    self.labelHint.height = 28;
    self.labelHint.x = 0;
    self.labelHint.y = 0;
    
    self.labelContent.y = 0;
    [self.labelContent sizeToFit];
    self.labelContent.height = 28;
    self.labelContent.width = ScreenWidth - 30 - 84;
    self.labelContent.x = ScreenWidth - 30 - self.labelContent.width;
    self.labelContent.textAlignment = NSTextAlignmentRight;
    
    if (type == CPLineCellTypeHintText || type == CPLineCellTypeConmentTextAddress) {
        
        self.labelContent.textAlignment = NSTextAlignmentLeft;
        self.labelHint.frame = CGRectMake(0, 0, 84, 28);
        
        self.labelContent.x = 84;
        self.labelContent.y = 0;
         self.labelContent.height = 28;
        if (type == CPLineCellTypeConmentTextAddress &&   [self heightContent] > 28)  {
            
            self.labelHint.height = 20;
            self.labelHint.y = 5;
            self.labelContent.y = 5;
            self.labelContent.numberOfLines = 0;
            self.labelContent.preferredMaxLayoutWidth = self.labelContent.width;
            self.labelContent.height = [self heightContent];
        }
        
    }else if (type == CPLineCellTypeConmentTextLeftRight) {

        self.labelHint.textColor = KColorTextBlack;
        
    }

    
 
}

- (CGFloat)heightContent {
    
    CGSize size = CGSizeMake(ScreenWidth - 30 - 84, 80);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:_labelContent.font forKey:NSFontAttributeName];
    
    CGRect rect = [_labelContent.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return rect.size.height ;
}

- (CGFloat)heightContentLayout {
    
    return  [self heightContent] + 11;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
