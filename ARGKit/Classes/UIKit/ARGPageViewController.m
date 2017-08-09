//
//  ARGPageViewController.m
//  Pods
//
//  Created by 吴哲 on 2017/8/9.
//
//

#import "ARGPageViewController.h"

@interface ARGPageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

/// pageController
@property(nonatomic ,strong) UIPageViewController *pageController;
@end

@implementation ARGPageViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedIndex = 0;
        _contentInset = UIEdgeInsetsZero;
        [super addChildViewController:self.pageController];
        [self.pageController didMoveToParentViewController:self];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.pageController.view];
    [self.pageController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.contentInset.top];
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.contentInset.left];
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.contentInset.bottom];
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.contentInset.right];
    //把约束添加到父视图上
    NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, nil];
    [self.view addConstraints:array];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    NSArray *constrains = self.view.constraints;
    
    for (NSLayoutConstraint* constraint in constrains) {
        if ([constraint.firstItem isEqual:self.pageController.view]) {
            if (constraint.firstAttribute == NSLayoutAttributeTop) {
                constraint.constant = self.contentInset.top;
            }
            else if (constraint.firstAttribute == NSLayoutAttributeLeft){
                constraint.constant = self.contentInset.left;
            }
            else if (constraint.firstAttribute == NSLayoutAttributeBottom){
                constraint.constant = -self.contentInset.bottom;
            }
            else if (constraint.firstAttribute == NSLayoutAttributeRight){
                constraint.constant = -self.contentInset.right;
            }
        }
    }
}


#pragma mark - @private
- (void)addChildViewController:(UIViewController *)childController
{
    NSMutableArray *viewControllers = self.viewControllers.mutableCopy;
    [viewControllers addObject:childController];
    self.viewControllers = viewControllers.copy;
}

- (NSArray<UIViewController *> *)childViewControllers
{
    return self.viewControllers;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    _viewControllers = viewControllers.copy;
    
    self.selectedIndex = self.selectedIndex;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers atSelectedIndex:(NSUInteger)selectedIndex
{
    _viewControllers = viewControllers.copy;
    self.selectedIndex = selectedIndex;
}


- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    NSMutableArray *viewControllers = self.viewControllers.mutableCopy;
    [viewControllers insertObject:viewController atIndex:index];
    _viewControllers = viewControllers;
    if (index >self.selectedIndex) {
        self.selectedIndex = self.selectedIndex;
    }else{
        self.selectedViewController = self.selectedViewController;
    }
}


- (void)removeAtIndex:(NSUInteger)index
{
    if (index < self.viewControllers.count) {
        [self removeViewController:self.viewControllers[index]];
    }
}

- (void)removeViewController:(UIViewController *)viewController
{
    NSMutableArray *viewControllers = self.viewControllers.mutableCopy;
    [viewControllers removeObject:viewController];
    _viewControllers = viewControllers;
    if ([viewController isEqual:viewController]) {
        self.selectedIndex = self.selectedIndex;
    }else{
        self.selectedViewController = self.selectedViewController;
    }
}


- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController
{
    _selectedViewController = selectedViewController;
    if (_selectedViewController) {
        [self.pageController setViewControllers:@[_selectedViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        _selectedIndex = [self.viewControllers indexOfObject:_selectedViewController];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex < self.viewControllers.count){
        _selectedIndex = selectedIndex;
    }else{
        _selectedIndex = self.viewControllers.count - 1;
    }
    self.selectedViewController = self.viewControllers[_selectedIndex];
}
#pragma mark - setter

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - getter

- (UIPageViewController *)pageController
{
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.dataSource = self;
        _pageController.delegate = self;
    }
    return _pageController;
}

#pragma mark - <##>UIPageViewControllerDataSource

/// 向前翻页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger idx = [self.viewControllers indexOfObject:viewController] - 1;
    if (idx>= 0) {
        return self.viewControllers[idx];
    }
    return nil;
}

/// 向后翻页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger idx = [self.viewControllers indexOfObject:viewController] + 1;
    if (idx < self.viewControllers.count) {
        return self.viewControllers[idx];
    }
    return nil;
}

#pragma mark - <##>UIPageViewControllerDelegate


@end
