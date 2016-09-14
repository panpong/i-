//
//  HFHTextField.m
//  HFHTextField
//
//  Created by 002 on 15/12/26.
//  Copyright © 2015年 002. All rights reserved.
//  

#import "HFHTextField.h"

@interface HFHTextField ()

@end

@implementation HFHTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification"
                                                     object:self];
    }
    
    return self;
}

+ (instancetype)textFieldWithPlaceHolder:(NSString *)placeHolder placeHolderSize:(CGFloat)fontSize placeHolderPadding:(NSInteger)padding leftViewImageName:(NSString *)imageName {
    
    HFHTextField *textField = [[HFHTextField alloc] init];
    if (placeHolder && ![@"" isEqualToString:placeHolder]) {
        textField.placeholder = placeHolder;
        textField.font = [UIFont systemFontOfSize:fontSize];
        textField.placeHolderPadding = padding;
    }
    
    if (imageName && ![@"" isEqualToString:imageName]) {
        textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return textField;
}

+ (instancetype)textFieldWithPlaceHolder:(NSString *)placeHolder placeHolderSize:(CGFloat)fontSize placeHolderPadding:(NSInteger)padding placeHolderColor:(UIColor *)placeColor leftViewImageName:(NSString *)imageName {
    
    HFHTextField *textField = [[HFHTextField alloc] init];
    if (placeHolder && ![@"" isEqualToString:placeHolder]) {
        textField.placeholder = placeHolder;
        textField.font = [UIFont systemFontOfSize:fontSize];
        textField.placeHolderPadding = padding;
    }
    if (placeColor) {
        [textField setValue:placeColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    if (imageName && ![@"" isEqualToString:imageName]) {
        textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return textField;
}

// 控制placeHolder的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, self.placeHolderPadding, 0);
}

// 控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, self.placeHolderPadding, 0);
    
}

// 控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, self.placeHolderPadding , 0 );
}

// 修改placeHolder的颜色
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    [self setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
}

// 修改placeHolder的字体大小
- (void)setPlaceHolderFontSize:(NSInteger)placeHolderFontSize {
    [self setValue:[UIFont systemFontOfSize:placeHolderFontSize] forKeyPath:@"_placeholderLabel.font"];
}

#pragma mark - 输入字符限制
-(void)textFiledEditChanged:(NSNotification *)obj
{
    // 未设置输入字数则退出此方法
    if (!self.limitLength) {
        return ;
    }
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        // 获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > self.limitLength)
            {
                textField.text = [toBeString substringToIndex:self.limitLength];
            }
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > self.limitLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.limitLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:self.limitLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limitLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

@end
