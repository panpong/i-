//
//  ABNewFeatureViewController.m 引导图控制器（即新特性）
//  LoveTourGuide
//
//  Created by 002 on 16/1/6.
//  Copyright © 2016年 fhhe. All rights reserved.
//

#import "ABNewFeatureViewController.h"
#import "ABNewFeatureViewCell.h"

@interface ABNewFeatureViewController ()

{
    CGFloat _righMargin;
    CGFloat _topMargin;
    NSString *_jumpButtonName;
    NSString *_startExperienceName;
    CGFloat _mutiple;
    BOOL _isShown;    
}

@property(nonatomic,strong) NSArray<NSString *> *images;    // 图片名称数组

@end

@implementation ABNewFeatureViewController

// 可重用cell的ID
static NSString * const ABNewFeatureCellReuseIdentifier = @"ABNewFeatureCellReuseIdentifier";

#pragma mark - 初始化
- (instancetype)initWithImages:(NSArray<NSString *> *)images {
    
    self.images = images.copy;
    
    // 创建collectionView的布局样式
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self = [super initWithCollectionViewLayout:layout];
    
    self.collectionView.pagingEnabled = true;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[ABNewFeatureViewCell class] forCellWithReuseIdentifier:ABNewFeatureCellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 状态栏处理
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 状态栏处理
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // +1，比图片数量多1张，使得滑动到图片最后一张继续滑动的时候切换控制器
    return self.images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ABNewFeatureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ABNewFeatureCellReuseIdentifier forIndexPath:indexPath];
        
    [cell setJumpButton:_jumpButtonName multipliedByBottom:_mutiple];
    [cell setStartExperienceButton:_startExperienceName rightMargin:_righMargin topMargin:_topMargin];
    [cell setupUI];
    [cell setImageIndex:indexPath.item images:self.images];
    
    return cell;
}

#pragma mark - <UIScrollViewDelegate>
// ScrollView 停止滚动方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 最后一页显示 ‘开始按钮’
    // 根据 ‘contentoffset’ 计算页数
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 判断是否 ‘引导图’的最后一页
    if (page != (self.images.count - 1)) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
    
    ABNewFeatureViewCell *cell = (ABNewFeatureViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    [cell showButtonAnim:_isShown];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    ABLog(@"开始拖动%lf",(scrollView.contentOffset.x));
    
    // 滑动到最后一张继续滑动的时候立马切换为 ‘主控制器’
    if (scrollView.contentOffset.x > (2 * ScreenWidth)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ABSwitchRootViewControllerNotification object:@"ABHomeViewController"];
    }
}

- (void)setJumpButton:(NSString *)name multipliedByBottom:(CGFloat)mutiple {
    _mutiple = mutiple;
    _jumpButtonName = name;
}

- (void)setStartExperienceButton:(NSString *)name rightMargin:(CGFloat)rightMargin topMargin:(CGFloat)topMargin {
    _startExperienceName = name;
    _righMargin = rightMargin;
    _topMargin = topMargin;
}


- (void)setStartButtonAnimateShown:(BOOL)isShown {
    _isShown = isShown;
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden {

    return YES;
}

@end
