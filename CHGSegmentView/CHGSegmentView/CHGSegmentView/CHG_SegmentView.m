//
// CHG_SegmentView.m
// ChatBird
//
// Created by 嘉爸爸 on 2024/5/18.
//

#import "CHG_SegmentView.h"

@interface CHG_SegmentView ()
@property (nonatomic, strong) NSMutableArray<UILabel *> *labels;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIView *indicatorCenterView;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation CHG_SegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        
        _labels = [NSMutableArray array];
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = [UIColor clearColor];

        _indicatorCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 4)];
        _indicatorCenterView.backgroundColor = [UIColor colorWithHue:0.64 saturation:0.73 brightness:1 alpha:0.6];
        _indicatorCenterView.layer.cornerRadius = 2;
        _indicatorCenterView.layer.masksToBounds = YES;
        [_indicatorView addSubview:_indicatorCenterView];
        
        // 默认标题和容器左右间距
        _titleSpacing = 10;
        _sidePadding = 15;
    }
    return self;
}

- (void)setButtonTitles:(NSArray<NSString *> *)titles {
    
    [self.labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.labels removeAllObjects];
    
    NSMutableArray<NSNumber *> *titleWidths = [NSMutableArray array];
    CGFloat totalTitleWidth = 0;
    
    for (NSString *title in titles) {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = [UIFont systemFontOfSize:16];
        [label sizeToFit];
        [titleWidths addObject:@(label.bounds.size.width)];
        totalTitleWidth += label.bounds.size.width;
    }
    
    CGFloat totalSpacingWidth = _titleSpacing * (titles.count - 1);
    CGFloat totalContentWidth = totalTitleWidth + totalSpacingWidth;
    
    if (totalContentWidth < self.bounds.size.width) {
        _sidePadding = (self.bounds.size.width - totalContentWidth) / 2;
    }
    
    CGFloat titleX = _sidePadding;
    
    for (NSUInteger i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        [label sizeToFit];

        // 设置label的frame
        CGRect frame = label.frame;
        frame.origin.x = titleX;
        frame.origin.y = 0;
        frame.size.height = self.bounds.size.height - 4;
        label.frame = frame;

        titleX += frame.size.width + _titleSpacing; // 加上间距

        label.tag = i;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
        [label addGestureRecognizer:tapGesture];

        [self addSubview:label];
        [self.labels addObject:label];
    }

    UILabel *firstLabel = self.labels.firstObject;
    if (firstLabel) {
        self.indicatorView.frame = CGRectMake(firstLabel.frame.origin.x, self.bounds.size.height - 4, firstLabel.frame.size.width, 4);
        _indicatorCenterView.center = CGPointMake(firstLabel.frame.size.width / 2, 2); // Adjust the center view position within the indicator view
        [self addSubview:self.indicatorView];
    }

    [self setSelectedIndex:0 animated:NO];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    if (index >= 0 && index < self.labels.count) {
        _selectedIndex = index;
        [self moveIndicatorToIndex:index animated:animated];
    }
}

- (void)moveIndicatorToIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < 0 || index >= self.labels.count) {
        return;
    }

    UILabel *selectedLabel = self.labels[index];
    CGRect frame = self.indicatorView.frame;
    frame.origin.x = selectedLabel.frame.origin.x;
    frame.size.width = selectedLabel.frame.size.width;

    for (NSUInteger i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        if (i == index) {
            label.textColor = self.selectedLabelColor ?: [UIColor whiteColor];
        } else {
            label.textColor = self.unselectedLabelColor ?: [UIColor colorWithWhite:1.0 alpha:0.9];
        }
    }

    if (animated) {
        [UIView animateWithDuration:0.15 animations:^{
            self.indicatorView.frame = frame;
        }];
    } else {
        self.indicatorView.frame = frame;
    }
}

- (void)labelTapped:(UITapGestureRecognizer *)gesture {
    NSInteger index = gesture.view.tag;
    if (index != self.selectedIndex) {
        [self setSelectedIndex:index animated:YES];
        if ([self.delegate respondsToSelector:@selector(segmentedControlDidSelectIndex:)]) {
            [self.delegate segmentedControlDidSelectIndex:index];
        }
    }
}

- (void)setbgColor:(UIColor *)color {
    self.backgroundColor = color;
}

- (void)setSelectedLabelColor:(UIColor *)selectedColor unselectedLabelColor:(UIColor *)unselectedColor indicatorCenterColor:(UIColor *)indicatorColor {
    self.selectedLabelColor = selectedColor;
    self.unselectedLabelColor = unselectedColor;
    self.indicatorCenterView.backgroundColor = indicatorColor;

    // 更新当前选中的标签颜色
    for (NSUInteger i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        if (i == self.selectedIndex) {
            label.textColor = self.selectedLabelColor ?: [UIColor whiteColor];
        } else {
            label.textColor = self.unselectedLabelColor ?: [UIColor colorWithWhite:1.0 alpha:0.9];
        }
    }
}

@end
