//
//  KYSAlignmentLeftCollectionViewFlowLayout.m
//  KTSCollectionTest
//
//  Created by Liu Zhao on 16/3/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSAlignmentLeftCollectionViewFlowLayout.h"
#import "ABCollectionConfig.h"

@implementation KYSAlignmentLeftCollectionViewFlowLayout

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

/**
 * 准备操作：一般在这里设置一些初始化参数
 */
- (void)prepareLayout
{
    // 必须要调用父类(父类也有一些准备操作)
    [super prepareLayout];
    //ABLog(@"prepareLayout");
}

/**
 * 决定了cell怎么排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //ABLog(@"%@",NSStringFromCGRect(rect));
    // 调用父类方法拿到默认的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
//    ABLog(@"223344:%lu",(unsigned long)array.count);
//    ABLog(@"%f",self.minimumInteritemSpacing);
//    ABLog(@"%@",NSStringFromUIEdgeInsets(self.sectionInset));
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    int width=KYS_SPACE;
    NSInteger section=-1;
    for (int i=0;i<array.count;i++) {
        UICollectionViewLayoutAttributes *attrs=array[i];
//        ABLog(@"%@",NSStringFromCGSize(attrs.size));
//        ABLog(@"%@",attrs.indexPath);
//        ABLog(@"%lu",(unsigned long)attrs.representedElementCategory);
//        ABLog(@"%@",attrs.representedElementKind);
        if (UICollectionElementCategoryCell==attrs.representedElementCategory) {
            //ABLog(@"%@  size:%@",attrs.indexPath,NSStringFromCGSize(attrs.size));
            //每个section换行
            if (section != attrs.indexPath.section) {
                width=KYS_SPACE;
                section=attrs.indexPath.section;
            }
            int nextWidth = width+(attrs.size.width+KYS_SPACE);
            //ABLog(@"%d",nextWidth);
            if (nextWidth<=self.collectionView.frame.size.width) {
                attrs.center=CGPointMake(width+attrs.size.width/2, attrs.center.y);
                width=nextWidth;
            }else{
                //新一行
                //ABLog(@"新一行:%d  width:%f",i,attrs.size.width);
                width=KYS_SPACE;
                i--;
            }
        }
    }
#pragma clang diagnostic pop
    return array;
}

//控制何时刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    //ABLog(@"%@",NSStringFromCGRect(newBounds));
    //ABLog(@"%d",[super shouldInvalidateLayoutForBoundsChange:newBounds]);
    //return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}


@end
