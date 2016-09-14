//
//  UIImage+KYSAddition.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/24.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KYSAddition)

#pragma mark - create
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//填充mask利用mask不透明部分创建纯色图片
//如果maskImage为空就相当于添加纯色蒙板
+ (UIImage*)imageWithColor:(UIColor*)color
             tintBlendMode:(CGBlendMode)tintBlendMode
                 maskImage:(UIImage*)maskImage;

+ (BOOL)isAnimatedGIFData:(NSData *)data;

+ (BOOL)isAnimatedGIFFile:(NSString *)path;;

+ (UIImage *)imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale;

#pragma mark - resize
//生成其他尺寸图片
- (UIImage *)imageByResizeToSize:(CGSize)size;

//裁剪某一区域并生成图片
- (UIImage *)imageByClipToRect:(CGRect)clipRect;

- (UIImage *)imageByCropToRect:(CGRect)rect;

//压缩图片的质量
- (UIImage *)imageByCompressionQuality:(CGFloat)compressionQuality;

#pragma mark - 水印
- (UIImage *) imageWithWaterMark:(UIImage*)mark
                      pointArray:(NSArray *)pointArray;

//高亮与非高亮图片size要相同
- (UIImage *) imageWithWaterMark:(UIImage*)mark
              highlightWaterMark:(UIImage *)highMark
                      pointArray:(NSArray *)pointArray
                  highlightArray:(NSArray *)highlightArray;

#pragma mark - rotate flip
- (UIImage *)imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

- (UIImage *)imageByFlipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical;

- (UIImage *)imageByRotateLeft90;

- (UIImage *)imageByRotateRight90;

- (UIImage *)imageByRotate180;

- (UIImage *)imageByFlipVertical;

- (UIImage *)imageByFlipHorizontal;


#pragma mark - blur saturation mark
//毛玻璃与饱和度
/**
 @param blurRadius 0无毛玻璃效果.
 @param saturation 以1为基准
 */
- (UIImage *)imageByBlurRadius:(CGFloat)blurRadius saturation:(CGFloat)saturation;

- (UIImage *)imageByGray;//灰色

- (UIImage *)imageBySoft;

- (UIImage *)imageByLight;

- (UIImage *)imageByExtraLight;

- (UIImage *)imageByDark;

@end
