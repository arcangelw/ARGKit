//
//  ARGPageViewController.m
//  Pods
//
//  Created by 吴哲 on 2017/8/9.
//
//

#import "ARGPageViewController.h"

#define PAGE_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))

#define ARGLock() dispatch_semaphore_wait(self->_arg_lock, DISPATCH_TIME_FOREVER)
#define ARGUnlock() dispatch_semaphore_signal(self->_arg_lock)

@interface ARGPageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>
{
    dispatch_semaphore_t _arg_lock;
}

/// pageController
@property(nonatomic ,strong) UIPageViewController *pageController;
/// tmpIndex
@property NSUInteger tmpIndex;
@property(nonatomic ,strong) NSLayoutConstraint *contraint1;
@property(nonatomic ,strong) NSLayoutConstraint *contraint2;
@property(nonatomic ,strong) NSLayoutConstraint *contraint3;
@property(nonatomic ,strong) NSLayoutConstraint *contraint4;

@end

@implementation ARGPageViewController
@synthesize selectedViewController = _selectedViewController;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arg_lock = dispatch_semaphore_create(1);
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
    self.contraint1 = [NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.contentInset.top];
    self.contraint2 = [NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.contentInset.left];
    self.contraint3 = [NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.contentInset.bottom];
    self.contraint4 = [NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.contentInset.right];
    //把约束添加到父视图上
    NSArray *array = [NSArray arrayWithObjects:self.contraint1, self.contraint2, self.contraint3, self.contraint4, nil];
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
    
    self.contraint1.constant = self.contentInset.top;
    self.contraint2.constant = self.contentInset.left;
    self.contraint3.constant = -self.contentInset.bottom;
    self.contraint4.constant = -self.contentInset.right;
}


#pragma mark - @private


- (void)updatePageViewControllerDisplayViewController:(UIViewController *)displayViewController animated:(BOOL)animated
{
    if (displayViewController) {
        [self.pageController setViewControllers:@[displayViewController] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:nil];
    }
}


- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    ARGLock();
    _viewControllers = viewControllers.copy;
    self.selectedIndex = 0;
    ARGUnlock();
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers atSelectedIndex:(NSUInteger)selectedIndex
{
    ARGLock();
    _viewControllers = viewControllers.copy;
    self.selectedIndex = selectedIndex;
    ARGUnlock();
}


- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    if (viewController) {
        [self insertViewControllers:@[viewController] atIndex:index];
    }
}

- (void)insertViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers atIndex:(NSUInteger)index
{
    ARGLock();
    NSMutableArray *tmpViewControllers = self.viewControllers.mutableCopy;
    index = PAGE_CLAMP(index, 0, tmpViewControllers.count);
    for (NSUInteger i = 0; i < viewControllers.count; i ++) {
        [tmpViewControllers insertObject:viewControllers[i] atIndex:index + i];
    }
    _viewControllers = tmpViewControllers.copy;
    if (index <= self.selectedIndex) {
        self.selectedIndex += 1;
        [self setSelectedIndex:self.selectedIndex + 1 animated:NO];
    }else{
        [self setSelectedIndex:self.selectedIndex animated:NO];
    }
    ARGUnlock();
}


- (void)removeAtIndex:(NSUInteger)index
{
    ///最后保留一个控制器
    if (self.viewControllers.count == 1) return;
    ARGLock();
    index = PAGE_CLAMP(index, 0, self.viewControllers.count - 1);
    NSMutableArray *viewControllers = self.viewControllers.mutableCopy;
    [viewControllers removeObjectAtIndex:index];
    _viewControllers = viewControllers.copy;
    if (index < self.selectedIndex) {
        self.selectedIndex -= 1;
    }else{
        self.selectedIndex = self.selectedIndex;
    }
    ARGUnlock();
}

- (void)removeViewController:(UIViewController *)viewController
{
    NSUInteger idx = [self.viewControllers indexOfObject:viewController];
    if (idx != NSNotFound) {
        [self removeAtIndex:idx];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:YES];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    if (!_viewControllers.count) return;
    
    if (selectedIndex < self.viewControllers.count){
        _selectedIndex = selectedIndex;
    }else{
        _selectedIndex = self.viewControllers.count - 1;
    }
    _selectedViewController = self.viewControllers[_selectedIndex];
    
    __weak typeof(&*self) wself = self;
    void(^updateViewController)() = ^() {
        __strong typeof(&*wself) sself = wself;
        if (!sself) return ;
        [sself updatePageViewControllerDisplayViewController:_selectedViewController animated:animated];
        [sself updateAppearance];
        [sself pageViewControllerDidTransition];
    };
    if ([NSThread isMainThread]) {
        updateViewController();
    }else{
        dispatch_async(dispatch_get_main_queue(), updateViewController);
    }
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
    NSInteger idx = [self.viewControllers indexOfObject:viewController];
    if (idx != NSNotFound) {
        if (idx - 1 < self.viewControllers.count) {
            return self.viewControllers[idx - 1];
        }
    }
    return nil;
}

/// 向后翻页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger idx = [self.viewControllers indexOfObject:viewController];
    if (idx != NSNotFound) {
        if (idx + 1 < self.viewControllers.count) {
            return self.viewControllers[idx + 1];
        }
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
    if (completed && self.tmpIndex != NSNotFound && self.tmpIndex < self.viewControllers.count) {
        _selectedIndex = self.tmpIndex;
        _selectedViewController = self.viewControllers[_selectedIndex];
        [self updateAppearance];
    }
    
    [self pageViewControllerDidTransition];
}


- (void)pageViewControllerDidTransition
{
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
