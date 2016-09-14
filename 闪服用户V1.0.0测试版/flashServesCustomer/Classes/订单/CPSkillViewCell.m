//
//  CPSkillViewCell.m
//  flashServes
//
//  Created by yjin on 16/3/21.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPSkillViewCell.h"
#import "CPSkillView.h"
#import "UIView+Extention.h"
#define marginX 15
#define marginY 5
#define marginViewX 20
#define marginViewY 8
@interface CPSkillViewCell ()

@property (nonatomic, assign)CGFloat lastX;
@property (nonatomic, assign)CGFloat lastY;

@end

@implementation CPSkillViewCell

- (void)setArrayKill:(NSArray<NSDictionary *> *)arrayKill {
    
    if ([_arrayKill isEqualToArray:arrayKill]) {
        
        return;
    }
    
    _arrayKill = arrayKill;
    
    for (UIView *subView in self.subviews) {
        
        if ([subView isKindOfClass:[CPSkillView class]]) {
            
            [subView removeFromSuperview];
        }
    }
    
    self.lastY = 0;
    self.lastX = 0;
    for (int i = 0 ; i < arrayKill.count ; i++) {
        
        NSDictionary *stringKill = arrayKill[i];
        CPSkillView *sillView = [[CPSkillView alloc] init];
        [sillView setModal:stringKill];
    
        if (sillView.width + self.lastX + marginViewX + marginX > ScreenWidth || self.lastX == marginX || i == 0) { // 比较少
            
            sillView.x = marginX;
            if (self.lastY == 0) { // 第一次
                
                sillView.y = marginY;
            }else {
                
                sillView.y = self.lastY + marginViewY + sillView.height;
            }
        } else {
            
            if (self.lastY == 0) { // 第一次
                
                sillView.y = marginY;
            }else {
                
                sillView.y = self.lastY ;
            }
 
            sillView.x = self.lastX + marginX ;
            
        }

        self.lastX = CGRectGetMaxX(sillView.frame);
        self.lastY = sillView.y;
        self.heightView = self.lastY + marginY + marginY + sillView.height;
        [self addSubview:sillView];
    }

}

+ (instancetype)skillViewCellWith:(UITableView *)tableView  {
    
    
    CPSkillViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CPSkillViewCell"];
    if (cell == nil) {
    
        cell = [[CPSkillViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPSkillViewCell"];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
