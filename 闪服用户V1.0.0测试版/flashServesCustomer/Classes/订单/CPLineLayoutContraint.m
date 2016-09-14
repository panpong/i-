//
//  AB.m
//  flashServes
//
//  Created by yjin on 16/3/24.
//  Copyright © 2016年 002. All rights reserved.
//

#import "CPLineLayoutContraint.h"

@implementation CPLineLayoutContraint


-(void) awakeFromNib

{
    
    [super awakeFromNib];
    
    if(self.constant==1) {
        self.constant=1/[UIScreen mainScreen].scale;
    }
    
}
@end
