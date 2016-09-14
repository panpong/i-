
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 Chen All rights reserved.
//

#import "CPTextView.h"

@interface CPTextView() <UITextViewDelegate>

@end

@implementation CPTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
        
        
    }
    return self;
}

/**
 * 初始化
 */
- (void)setup
{
    // 文字发生改变,就调用[self setNeedsDisplay],刷新界面,重新调用drawRect:(CGRect)rect
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:UITextViewTextDidChangeNotification object:self];
    
    
    [self setAutoresizingMask:UIViewAutoresizingNone];
    
    self.delegate = self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    _placehoder = [placehoder copy];
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (self.text.length == 0) {
        
        [self.imageViewIcon setImage:[UIImage imageNamed:@"+"]];
        
    }else {
        
        [self.imageViewIcon setImage:[UIImage imageNamed:@"编辑-bi"]];
        
    }
    self.labelTint.text = [NSString stringWithFormat:@"%d/500",text.length];
    
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    // 文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    if (self.font) {
        attrs[NSFontAttributeName] = self.font;
    }
    
    CGRect placehoderRect;
    if (!self.hasText)  {
    // 画文字
  
    placehoderRect.origin = CGPointMake(5, 7);
    CGFloat w = rect.size.width - 2 * placehoderRect.origin.x;
    CGFloat h = rect.size.height;
    placehoderRect.size = CGSizeMake(w, h);
    [self.placehoder drawInRect:placehoderRect withAttributes:attrs];
        
    }
    
//    placehoderRect.origin = CGPointMake(rect.size.width - 60 , rect.size.height - 30);
//    placehoderRect.size = CGSizeMake(60, 40);
//    NSString *stringNumber = [NSString stringWithFormat:@"%lu/300",(unsigned long)self.text.length];
//    [stringNumber  drawInRect:placehoderRect withAttributes:attrs];
    
}

#pragma mark 代理方法

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSMutableString *string = [NSMutableString stringWithFormat:@"%@%@",textView.text,text];
    
   
    if ([text length] == 0) {
        
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {
        
        
    }
    
    if (string.length >=KMaxLength) {
        
        textView.text = [string substringToIndex:KMaxLength];
        return  false;
    }
    
    return  true;
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.labelTint.text =  [NSString stringWithFormat:@"%lu/500",(unsigned long)textView.text.length];
    
    if (textView.text.length == 0) {
        
        [self.imageViewIcon setImage:[UIImage imageNamed:@"+"]];
        
    }else {
        
        [self.imageViewIcon setImage:[UIImage imageNamed:@"编辑-bi"]];
        
    }
    
}



- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    [self becomeFirstResponder];
    
}



@end
