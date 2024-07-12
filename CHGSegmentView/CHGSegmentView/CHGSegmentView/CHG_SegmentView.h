//
// CHG_SegmentView.h
// ChatBird
//
// Created by 嘉爸爸 on 2024/5/18.
//

#import <UIKit/UIKit.h>
#define kSegmentViewH 38

NS_ASSUME_NONNULL_BEGIN

@protocol CHG_SegmentViewDelegate <NSObject>
- (void)segmentedControlDidSelectIndex:(NSInteger)index;
@end

@interface CHG_SegmentView : UIView

@property (nonatomic, strong) UIColor *selectedLabelColor;
@property (nonatomic, strong) UIColor *unselectedLabelColor;
@property (nonatomic, weak) id<CHG_SegmentViewDelegate> delegate;
@property (nonatomic, assign) CGFloat titleSpacing; // 新增属性: title之间的间距
@property (nonatomic, assign) CGFloat sidePadding; // 新增属性: 第一个和最后一个title距离左右侧的间距

- (void)setButtonTitles:(NSArray<NSString *> *)titles;
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
- (void)moveIndicatorToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)setbgColor:(UIColor *)color;
- (void)setSelectedLabelColor:(UIColor *)selectedColor unselectedLabelColor:(UIColor *)unselectedColor indicatorCenterColor:(UIColor *)indicatorColor;

@end

NS_ASSUME_NONNULL_END
