//
//  ViewController.m
//  CHGSegmentView
//
//  Created by 嘉爸爸 on 2024/7/12.
//

#import "ViewController.h"
#import "CHG_SegmentView.h"

@interface ViewController ()<UIScrollViewDelegate, CHG_SegmentViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CHG_SegmentView *oc_segmentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *albumTitles = @[@"全部", @"付费", @"免费"];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * albumTitles.count, self.scrollView.frame.size.height);
    
    for (NSInteger i = 0; i < albumTitles.count; i++) {
        UIViewController *testVc = [[UIViewController alloc] init];
        testVc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        testVc.view.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:testVc.view];
        [self addChildViewController:testVc];
        [testVc didMoveToParentViewController:self]; // 可以在这个方法中更新子控制器的布局，执行一些清理操作，或者在控制器移动到新的父控制器中时执行一些初始化操作
    }
    
    self.oc_segmentView = [[CHG_SegmentView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, kSegmentViewH)];
    self.oc_segmentView.titleSpacing = 90; // 设置title之间的间距为90
    self.oc_segmentView.sidePadding = 15; // 设置第一个和最后一个title距离左右侧的间距为15
    [self.oc_segmentView setButtonTitles:albumTitles];
    self.oc_segmentView.delegate = self;
    [self.view addSubview:self.oc_segmentView];
}

#pragma mark <UIScrollViewDelegate>
/**
 * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger pageIndex = lround(fractionalPage);
    
    [self.oc_segmentView setSelectedIndex:pageIndex animated:YES];
}

#pragma mark - delegate
- (void)segmentedControlDidSelectIndex:(NSInteger)index {
    // 滚动到指定的控制器
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.view.frame.size.width * index;
    [self.scrollView setContentOffset:offset animated:YES];
}

@end
