//
//  HFHTextView.m
//  flashServes
//
//  Created by 002 on 16/5/15.
//  Copyright © 2016年 002. All rights reserved.
//

#import "HFHTextView.h"
#import "UIView+Extention.h"

//#define PADDING_RIGHT_REMAINEDWORDS 100 // 字数Label宽度

@interface HFHTextView ()<UITextViewDelegate>

@property(nonatomic,strong) UILabel *remainedWordsLabel; // 剩余可输入字数

@end

@implementation HFHTextView

- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder placeHoderPoint:(CGPoint)placeHoderPoint maxLength:(NSInteger)maxLength remainedWordsLabel:(UILabel *)remainWordsLabel {
    if (self = [super initWithFrame:frame]) {
        if (remainWordsLabel) {
        self.remainedWordsLabel = remainWordsLabel;
        }
        [self setup];
        self.placehoder = placeHolder;
        self.placeHoderPoint = placeHoderPoint;
        self.maxLength = maxLength;
    }
    return self;
}

+ (instancetype)textViewWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder placeHoderPoint:(CGPoint)placeHoderPoint maxLength:(NSInteger)maxLength remainedWordsLabel:(UILabel *)remainWordsLabel {
    HFHTextView *textView = [[HFHTextView alloc] initWithFrame:frame placeHolder:placeHolder placeHoderPoint:placeHoderPoint maxLength:maxLength remainedWordsLabel:remainWordsLabel];
    return textView;
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

#pragma mark - UITextViewDelegate
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
//    if (string.length > _maxLength) {
//        
//        textView.text = [string substringToIndex:_maxLength];
//        return  false;
//    }
//    
//    return  true;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{

    // 改变字体颜色
    textView.textColor = [UIColor blackColor];

    // 对输入字符限制的逻辑处理
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];

    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);

        if (offsetRange.location < self.maxLength) {
            return YES;
        }
        else
        {
            return NO;
        }
    }

    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];

    NSInteger caninputlen = self.maxLength - comcatstr.length;

    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};

        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {

                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }

                                          trimString = [trimString stringByAppendingString:substring];

                                          idx++;
                                      }];

                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            //            self.lbNums.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }

}

/**
 重写此方法目的是为了让输入文字能随时滚动到最后一行
 
 @param textView textView
 */
//- (void)textViewDidChange:(UITextView *)textView {
//    self.remainedWordsLabel.text = [NSString stringWithFormat:@"%zd/%zd",textView.text.length,self.maxLength];
//    // 让输入文字能随时滚动到最后一行
//    [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
//}

- (void)textViewDidChange:(UITextView *)textView
{
    // 让输入文字能随时滚动到最后一行
    [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];

    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }

    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;

    if (existTextNum > self.maxLength)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:self.maxLength];

        [textView setText:s];
    }
   self.remainedWordsLabel.text = [NSString stringWithFormat:@"%ld/%zd",textView.text.length,self.maxLength];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    [self becomeFirstResponder];
    
}

@end
