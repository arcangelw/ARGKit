//
//  ARGCustomPageViewController.m
//  Pods
//
//  Created by 吴哲 on 2017/8/18.
//
//

#import "ARGCustomPageViewController.h"
#define PAGE_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))

#define ARGLock() dispatch_semaphore_wait(self->_arg_lock, DISPATCH_TIME_FOREVER)
#define ARGUnlock() dispatch_semaphore_signal(self->_arg_lock)


@interface ARGCustomPageContentView : UICollectionViewCell
@end
@implementation ARGCustomPageContentView

@end

@interface ARGCustomPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    dispatch_semaphore_t _arg_lock;
}

/// pageCollectionView
@property(nonatomic ,copy) UICollectionView *pageCollectionView;
/// pageCollectionViewLayout
@property(nonatomic ,copy) UICollectionViewFlowLayout *pageCollectionViewLayout;
/// tmpViewControllers
@property(nullable, nonatomic, copy) NSArray<__kindof UIViewController *> *tmpViewControllers;
/// tmpIndex
@property NSUInteger tmpIndex;
/// isDrag
@property BOOL isDrag;
@property(nonatomic ,strong) NSLayoutConstraint *contraint1;
@property(nonatomic ,strong) NSLayoutConstraint *contraint2;
@property(nonatomic ,strong) NSLayoutConstraint *contraint3;
@property(nonatomic ,strong) NSLayoutConstraint *contraint4;
@end

@implementation ARGCustomPageViewController
@synthesize selectedViewController = _selectedViewController;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arg_lock = dispatch_semaphore_create(1);
        _selectedIndex = 0;
        _contentInset = UIEdgeInsetsZero;
        _tmpViewControllers = @[].copy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     * https://stackoverflow.com/questions/18967859/ios7-uiscrollview-offset-in-uinavigationcontroller
     */
    UIView *zeroHeightView = [UIView new];
    zeroHeightView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    [zeroHeightView setFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, 0.f)];
    [self.view addSubview:zeroHeightView];
    
    [self.view addSubview:self.pageCollectionView];
    [self.pageCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.contraint1 = [NSLayoutConstraint constraintWithItem:self.pageCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.contentInset.top];
    self.contraint1.priority = UILayoutPriorityRequired;
    self.contraint2 = [NSLayoutConstraint constraintWithItem:self.pageCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.contentInset.left];
    self.contraint2.priority = UILayoutPriorityRequired;
    self.contraint3 = [NSLayoutConstraint constraintWithItem:self.pageCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.contentInset.bottom];
    self.contraint3.priority = UILayoutPriorityRequired;
    self.contraint4 = [NSLayoutConstraint constraintWithItem:self.pageCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.contentInset.right];
    self.contraint4.priority = UILayoutPriorityRequired;
    //把约束添加到父视图上
    NSArray *array = [NSArray arrayWithObjects:self.contraint1, self.contraint2, self.contraint3, self.contraint4, nil];
    [self.view addConstraints:array];
    
    self.pageCollectionViewLayout.itemSize = UIEdgeInsetsInsetRect(self.view.bounds, self.contentInset).size;
}


- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;
    self.contraint1.constant = self.contentInset.top;
    self.contraint2.constant = self.contentInset.left;
    self.contraint3.constant = -self.contentInset.bottom;
    self.contraint4.constant = -self.contentInset.right;
    
    self.pageCollectionViewLayout.itemSize = UIEdgeInsetsInsetRect(self.view.bounds, self.contentInset).size;
    [self.pageCollectionView setCollectionViewLayout:self.pageCollectionViewLayout animated:NO];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.viewControllers.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARGCustomPageContentView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ARGCustomPageContentView.class) forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - UIScrollViewDelegate



#pragma mark - getter

- (UICollectionView *)pageCollectionView
{
    if (!_pageCollectionView) {
        _pageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.pageCollectionViewLayout];
        _pageCollectionView.backgroundColor = [UIColor clearColor];
        _pageCollectionView.delegate  = self;
        _pageCollectionView.dataSource = self;
        _pageCollectionView.pagingEnabled = YES;
        [_pageCollectionView registerClass:[ARGCustomPageContentView class] forCellWithReuseIdentifier:NSStringFromClass(ARGCustomPageContentView.class)];
    }
    return _pageCollectionView;
}

- (UICollectionViewFlowLayout *)pageCollectionViewLayout
{
    if (!_pageCollectionViewLayout) {
        _pageCollectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
        _pageCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _pageCollectionViewLayout.minimumLineSpacing = 0.f;
        _pageCollectionViewLayout.minimumInteritemSpacing = 0.f;
    }
    return _pageCollectionViewLayout;
}


@end
