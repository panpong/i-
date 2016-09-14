//
//  ABTabBarViewController.m
//  TransportationCommittee
//
//  Created by yjin on 15/7/6.
//  Copyright (c) 2015年 pchen. All rights reserved.
//

#import "ABTabBarViewController.h"
#import "ABTabBar.h"

NSString *notificationNextScrollerVC  = @"notificationNextScrollerVC";
NSString *notificationNextScrollerVCKey = @"notificationNextScrollerVCKey";


@interface ABTabBarViewController ()<UIScrollViewDelegate,tabBarProtocol>

@property (strong, nonatomic)  UIScrollView *scrollerViewContent;

@property (nonatomic, strong) NSArray *arrayTabBars;

@end

@implementation ABTabBarViewController


- (instancetype)initWithArrayChilds:(NSArray *)childs tabBars:(NSArray *)tabBars {
    
    if (self = [super init]) {
        _arrayTabBars = tabBars;
        
        self.tabBar = [[ABTabBar alloc] init];
       
        self.tabBar.delegate = self;
        [self.view addSubview:self.tabBar];
        
        self.scrollerViewContent = [[UIScrollView alloc] init];
        self.scrollerViewContent.delegate = self;
        [self.scrollerViewContent setBackgroundColor:kColorBackground];
        
        for (UIViewController *childVC in childs) {
            [self addChildViewController:childVC];
            
        }
        
        [self.view addSubview:self.scrollerViewContent];
        [self setScrollerview];
        
    }
    
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.arrayTab = self.arrayTabBars;
    self.tabBar.delegate = self;

    [self setScrollerview];
}


- (void)setScrollerview {
    
    [self.scrollerViewContent setShowsHorizontalScrollIndicator:NO];
    [self.scrollerViewContent setShowsVerticalScrollIndicator:NO];
    
    self.scrollerViewContent.delegate = self;
    
    UIViewController *firstVC = [self.childViewControllers firstObject];
    firstVC.view.frame = self.scrollerViewContent.bounds;
    [self.scrollerViewContent addSubview:firstVC.view];
    
    NSLog(@"%@",NSStringFromCGRect(self.scrollerViewContent.bounds));
    
    CGFloat contentSizeWidth = ScreenWidth * self.childViewControllers.count;
    
    // 注意事项高度为 0，表示神马
    [self.scrollerViewContent setContentSize:CGSizeMake(contentSizeWidth, 0)];
    
    [self.scrollerViewContent setPagingEnabled:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources th at can be recreated.
}


#pragma mark scrollView 的代理方法


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    UIViewController *vc = self.childViewControllers[self.currentIndex];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationNextScrollerVC object:nil userInfo:@{notificationNextScrollerVCKey:vc}];
    
    
}



/**
 *  在scrollView动画结束时调用(添加子控制器的view到self.contentsScrollView)
 *  self.contentsScrollView == scrollView
 *  用户手动触发的动画结束，不会调用这个方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得当前需要显示的子控制器的索引
    self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[self.currentIndex];
    
    [self.tabBar cutViewWithIndex:self.currentIndex];
//    [[NSNotificationCenter defaultCenter] postNotificationName:notificationNextScrollerVC object:nil userInfo:@{notificationNextScrollerVCKey:vc}];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"MoreWebViewLoadAgainNotification" object:[NSString stringWithFormat:@"%ld",(long)self.currentIndex]];
    
    // 如果子控制器的view已经在上面，就直接返回
    if (vc.view.superview) return;
    
    // 添加
    CGFloat vcW = scrollView.frame.size.width;
    CGFloat vcH = scrollView.frame.size.height;
    CGFloat vcX = self.currentIndex * vcW;
    CGFloat vcY = 0;
    vc.view.frame = CGRectMake(vcX, vcY, vcW, vcH);
    
    [scrollView addSubview:vc.view];
}

/**
 *  当scrollView停止滚动时调用这个方法（用户手动触发的动画停止，会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
   

}

- (void)tabClick:(ABTabBar *)tabBar withIndex:(NSInteger)index {
    
    self.currentIndex = index;
    CGFloat offsetX = index * self.scrollerViewContent.frame.size.width;
    // 设置偏移量
    CGPoint offset = CGPointMake(offsetX, self.scrollerViewContent.contentOffset.y);
    [self.scrollerViewContent setContentOffset:offset animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoreWebViewLoadAgainNotification" object:[NSString stringWithFormat:@"%ld",(long)index]];
    
    
    UIViewController *vc = self.childViewControllers[self.currentIndex];
    
    [self.tabBar cutViewWithIndex:index];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationNextScrollerVC object:nil userInfo:@{notificationNextScrollerVCKey:vc}];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
       [self.tabBar setFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    self.scrollerViewContent.frame = CGRectMake(0, 45, ScreenWidth, ScreenHeight-45);
    

}



@end
