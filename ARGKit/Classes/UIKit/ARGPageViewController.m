//
//  ARGPageViewController.m
//  Pods
//
//  Created by 吴哲 on 2017/8/9.
//
//

#import "ARGPageViewController.h"

#define PAGE_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))

@interface ARGPageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>

/// pageController
@property(nonatomic ,strong) UIPageViewController *pageController;
/// tmpIndex
@property(nonatomic ) NSUInteger tmpIndex;
@end

@implementation ARGPageViewController
@synthesize selectedViewController = _selectedViewController;

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
    
    ///监听滑动
    for (UIView *view in self.pageController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delegate = self;
            break;
        }
    }
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


- (void)updatePageViewControllerDisplayViewController:(UIViewController *)displayViewController
{
    [self.pageController setViewControllers:@[displayViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}


- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    _viewControllers = viewControllers.copy;
    
    self.selectedIndex = 0;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers atSelectedIndex:(NSUInteger)selectedIndex
{
    _viewControllers = viewControllers.copy;
    
    self.selectedIndex = selectedIndex;
}

/**
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
*/

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (!_viewControllers.count) return;
    if (selectedIndex < self.viewControllers.count){
        _selectedIndex = selectedIndex;
    }else{
        _selectedIndex = self.viewControllers.count - 1;
    }
    _selectedViewController = self.viewControllers[_selectedIndex];
    
    [self updatePageViewControllerDisplayViewController:_selectedViewController];
    
    [self updateAppearance];
}


- (UIViewController *)selectedViewController
{
    return _selectedViewController;
}

#pragma mark - setter

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;

    [self.view setNeedsUpdateConstraints];
}


- (void)updateAppearance
{
    [self setNeedsFocusUpdate];
    [self setNeedsStatusBarAppearanceUpdate];
    self.title = self.title;
    self.tabBarItem = self.tabBarItem;
}

#pragma mark -

- (BOOL)becomeFirstResponder
{
    if (self.selectedViewController) {
        return [self.selectedViewController becomeFirstResponder];
    }
    return  [super becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    if (self.selectedViewController) {
        return [self.selectedViewController canBecomeFirstResponder];
    }
    return [super canBecomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.selectedViewController) {
         return [self.selectedViewController preferredStatusBarStyle];
    }
    return [super preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    if (self.selectedViewController) {
         return [self.selectedViewController prefersStatusBarHidden];
    }
    return [super prefersStatusBarHidden];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    if (self.selectedViewController) {
        return [self.selectedViewController preferredStatusBarUpdateAnimation];
    }
    return [super preferredStatusBarUpdateAnimation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (self.selectedViewController) {
        return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    return [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate
{
    if (self.selectedViewController) {
        return self.selectedViewController.shouldAutorotate;
    }
    return [super shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.selectedViewController) {
        return self.selectedViewController.supportedInterfaceOrientations;
    }
    return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.selectedViewController) {
        return self.selectedViewController.preferredInterfaceOrientationForPresentation;
    }
    return [super preferredInterfaceOrientationForPresentation];
}

- (nullable UIView *)rotatingHeaderView
{
    if (self.selectedViewController) {
        return self.selectedViewController.rotatingHeaderView;
    }
    return [super rotatingHeaderView];
}

- (nullable UIView *)rotatingFooterView
{
    if (self.selectedViewController) {
        return self.selectedViewController.rotatingFooterView;
    }
    return [super rotatingFooterView];
}


- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action
                                      fromViewController:(UIViewController *)fromViewController
                                              withSender:(id)sender
{
    if (self.selectedViewController) {
        return [self.selectedViewController viewControllerForUnwindSegueAction:action
                                                            fromViewController:fromViewController
                                                                    withSender:sender];
    }
    return [super viewControllerForUnwindSegueAction:action
                                                       fromViewController:fromViewController
                                                               withSender:sender];
}

- (BOOL)hidesBottomBarWhenPushed
{
    if (self.selectedViewController) {
        return self.selectedViewController.hidesBottomBarWhenPushed;
    }
    return [super hidesBottomBarWhenPushed];
}

- (NSString *)title
{
    if (self.selectedViewController) {
         return self.selectedViewController.title;
    }
    return [super title];
}

- (UITabBarItem *)tabBarItem
{
    if (self.selectedViewController) {
        return self.selectedViewController.tabBarItem;
    }
    return  [super tabBarItem];
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
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger idx = [self.viewControllers indexOfObject:viewController] - 1;
    if (idx>= 0 && idx != NSNotFound) {
        return self.viewControllers[idx];
    }
    return nil;
}

/// 向后翻页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger idx = [self.viewControllers indexOfObject:viewController] + 1;
    if (idx < self.viewControllers.count && idx != NSNotFound) {
        return self.viewControllers[idx];
    }
    return nil;
}

#pragma mark - <##>UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    UIViewController *next = pendingViewControllers.firstObject;
    self.tmpIndex = [self.viewControllers indexOfObject:next];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        _selectedIndex = self.tmpIndex;
        _selectedViewController = self.viewControllers[_selectedIndex];
        [self updateAppearance];
    }
    
    if ([self conformsToProtocol:@protocol(ARGPageViewControllerSubclassing)]) {
        id<ARGPageViewControllerSubclassing> class = (id)self;
        [class pageViewController:self didTransitionToViewController:self.selectedViewController index:self.selectedIndex];
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = round(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame)) - 1 + _selectedIndex;
    
    NSUInteger idx = PAGE_CLAMP(index, 0, self.viewControllers.count - 1);
    
    CGFloat progress = 2 * (scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame) - 1.f);
    progress = PAGE_CLAMP(progress, -1.f, 1.f);
    
    if ((self.selectedIndex == 0 && progress <= 0) || (self.selectedIndex == self.viewControllers.count - 1 && progress >= 0)) {
        return;
    }
    if ([self conformsToProtocol:@protocol(ARGPageViewControllerSubclassing)]) {
        id<ARGPageViewControllerSubclassing> class = (id)self;
        [class pageViewController:self willTransitionToViewController:self.viewControllers[idx] index:idx progress:progress];
    }
}

@end
