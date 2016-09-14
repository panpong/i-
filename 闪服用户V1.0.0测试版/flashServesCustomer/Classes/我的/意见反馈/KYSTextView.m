//
//  KYSTextView.m
//  flashServes
//
//  Created by Liu Zhao on 16/3/17.
//  Copyright © 2016年 002. All rights reserved.
//

#import "KYSTextView.h"

@interface KYSTextView() <UITextViewDelegate>

//@property(nonatomic,strong) UILabel *remainWords;   // 剩余字数标签

@end

@implementation KYSTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.maxLength = 10;
        self.placeHoderPoint =  CGPointMake(5, 7);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
        self.maxLength = 10;
        self.placeHoderPoint =  CGPointMake(5, 7);
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
    
    //    self.remainWords.text = [NSString stringWithFormat:@"%f",self.maxLength];
    
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
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:1.0];
    if (self.font) {
        attrs[NSFontAttributeName] = self.font;
    }
    
    CGRect placehoderRect;
    if (!self.hasText)  {
        // 画文字
        CGPoint point = CGPointMake(2, 5);
        point.x = 10;
        
        
        
        
        placehoderRect.origin = self.placeHoderPoint;
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

- (void)textViewDidChange:(UITextView *)textView{
    NSString *string = textView.text;
    if (string.length >=_maxLength) {
        textView.text = [string substringToIndex:_maxLength];
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    NSMutableString *string = [NSMutableString stringWithFormat:@"%@%@",textView.text,text];
//    
//    if ([text length] == 0) {
//        
//        return YES;
//    }
//    
//    if ([text isEqualToString:@"\n"]) {
//        
//        
//    }
//    
//    if (string.length >=_maxLength) {
//        
//        textView.text = [string substringToIndex:_maxLength];
//        return  false;
//    }
//    
//    return  true;
//    
//}




- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    [self becomeFirstResponder];
    
}

/**
 重写此方法目的是为了让输入文字能随时滚动到最后一行
 
 @param textView textView
 */
//- (void)textViewDidChange:(UITextView *)textView {
//    // 让输入文字能随时滚动到最后一行
//    [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
//}

//- (UILabel *)remainWords {
//    if (!_remainWords) {
//        CGFloat x = CGRectGetMaxX(self.frame) - 15;
//        CGFloat y = CGRectGetMaxY(self.frame) - 15;
//        _remainWords = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
//        [self addSubview:_remainWords];
//        _remainWords.textColor = CPColor(160, 160, 160);
//    }
//    return _remainWords;
//}

@end
