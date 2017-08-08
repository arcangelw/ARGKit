//
//  ARGPhotoBrowser.m
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import "ARGPhotoBrowser.h"

#import "UIView+ARGPhoto.h"

#import "ARGGroupView.h"
#import "ARGPhotoGroupCell.h"

#import "ARGPhotoTransitioning.h"


NSString *const kARGPhotoGroupViewWillActivation = @"kARGPhotoGroupViewWillActivation";

#define AG_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))

@implementation UIViewController (ARGPhoto)

- (nonnull instancetype)presentPhotoBrowserWithGroupItems:(NSArray<ARGPhotoGroupItem *> *)groupItems fromView:(UIView *)fromView blurEffect:(BOOL)blurEffectBackground completion:(void (^ __nullable)(void))completion
{
    ARGPhotoBrowser *browser = [[ARGPhotoBrowser alloc]initWithGroupItems:groupItems fromView:fromView];
    browser.blurEffectBackground = blurEffectBackground;
    [self presentViewController:browser animated:YES completion:completion];
    return browser;
}
- (nonnull instancetype)presentPhotoBrowserWithGroupItems:(NSArray<ARGPhotoGroupItem *> *)groupItems fromView:(UIView *)fromView completion:(void (^ __nullable)(void))completion
{
    return [self presentPhotoBrowserWithGroupItems:groupItems fromView:fromView blurEffect:NO completion:completion];
}

@end


@interface ARGPhotoBrowser ()<ARGGroupViewDelegate,UIGestureRecognizerDelegate>
/// transitioning
@property(nonatomic ,strong) ARGPhotoTransitioning *transitioning;
/// fromView
@property(nonatomic ,weak) UIView *fromView;
@property(nonatomic ,weak) UIView *from;
/// panGestureBeginPoint
@property(nonatomic ,assign) CGPoint panGestureBeginPoint;
/// cachePreferredStatusBarStyle
@property(nonatomic ,assign) UIStatusBarStyle cachePreferredStatusBarStyle;
/// groupItems
@property(nonatomic ,strong) NSArray<ARGPhotoGroupItem*> * groupItems;
/// groupView
@property(nonatomic ,strong) ARGGroupView *groupView;
/// pageController
@property(nonatomic ,strong) UIPageControl *pageController;
/// blurEffect
@property(nonatomic ,strong) UIVisualEffectView *blurEffect;
/// containerView
@property(nonatomic ,strong) UIView *containerView;
@end

@implementation ARGPhotoBrowser

- (instancetype)initWithGroupItems:(NSArray<ARGPhotoGroupItem*> *)groupItems fromView:(UIView *)fromView;
{
    self = [super init];
    if (self) {
        self.blurEffectBackground = NO;
        [self transitioning];
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.transitioningDelegate = _transitioning;
        self.groupItems = groupItems.copy;
        self.fromView = fromView;
        self.from = fromView;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)loadView
{
    [super loadView];
    if (self.blurEffectBackground) {
        self.containerView = self.blurEffect;
    }else{
        self.containerView = [UIView new];
        self.containerView.backgroundColor = [UIColor colorWithWhite:0.f alpha:1.f];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    self.containerView.frame = self.view.bounds;
    [self.view addSubview:self.containerView];

    self.groupView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    self.groupView.frame = self.view.bounds;
    [self.view addSubview:self.groupView];
    
    self.pageController.arg_width = self.view.arg_width = 36.f;
    self.pageController.arg_height = 10.f;
    self.pageController.arg_centerX = self.view.arg_width / 2.f;
    self.pageController.arg_bottom = self.view.arg_height - 20.f;
    [self.view addSubview:self.pageController];
    self.pageController.numberOfPages = self.groupItems.count;
    [self addGesture];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kARGPhotoGroupViewWillActivation object:self];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.cachePreferredStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:self.cachePreferredStatusBarStyle animated:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self scrollToFrom];
}

- (void)scrollToFrom
{
    if (self.from) {
        for (ARGPhotoGroupItem *item in self.groupItems) {
            if ([item.thumbView isEqual:self.from]) {
                NSUInteger idx = [self.groupItems indexOfObject:item];
                [self.groupView scrollToIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO];
                self.pageController.currentPage = idx;
                self.from = nil;
            }
        }
    }
}


- (void)addGesture
{
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap0.delegate = self;
    [self.view addGestureRecognizer:tap0];
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    tap1.delegate = self;
    tap1.numberOfTapsRequired = 2;
    [tap0 requireGestureRecognizerToFail:tap1];
    [self.view addGestureRecognizer:tap1];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)];
    press.delegate = self;
    [self.view addGestureRecognizer:press];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doubleTap:(UITapGestureRecognizer *)tap
{
    ARGPhotoGroupCell *cell = [self.groupView currentCell];
    if (cell) {
        if (cell.scrollView.zoomScale > 1.f) {
            [cell.scrollView setZoomScale:1.f animated:YES];
        }else{
            CGPoint touchPoint = [tap locationInView:cell.imageView];
            CGFloat newZoomScal = cell.scrollView.maximumZoomScale;
            CGFloat xSize = self.view.arg_width / newZoomScal;
            CGFloat ySize = self.view.arg_height / newZoomScal;
            [cell.scrollView zoomToRect:CGRectMake(touchPoint.x - xSize / 2.f, touchPoint.y - ySize / 2.f, xSize, ySize) animated:YES];
        }
    }
}

- (void)longPress
{
    ARGPhotoGroupCell *cell = [self.groupView currentCell];
    UIImage *image = cell.image;
    if (self.longPressBlock) {
        self.longPressBlock(image);
    }else{
        if (image) {
            UIActivityViewController *ac = [[UIActivityViewController alloc]initWithActivityItems:@[image] applicationActivities:nil];
            if ([ac respondsToSelector:@selector(popoverPresentationController)]) {
                ac.popoverPresentationController.sourceView = self.view;
            }
            [self presentViewController:ac animated:YES completion:nil];
        }
    }
}

- (void)pan:(UIPanGestureRecognizer *)g
{
    __weak typeof(&*self) wself = self;
    switch (g.state) {
        case UIGestureRecognizerStateBegan:
        {
            _panGestureBeginPoint = [g locationInView:self.view];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (_panGestureBeginPoint.x == 0 || _panGestureBeginPoint.y == 0) return;
            CGPoint p = [g locationInView:self.view];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            self.groupView.arg_top = deltaY;
            CGFloat alphaDelta = 160.f;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50.f ) / alphaDelta;
            alpha = AG_CLAMP(alpha, 0.f, 1.f);
            [UIView animateWithDuration:0.1f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveLinear animations:^{
                __strong typeof(&*wself) sself = wself;
                if (!sself) return ;
                sself.containerView.alpha = alpha;
                sself.pageController.alpha = alpha;
            } completion:nil];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (_panGestureBeginPoint.x == 0 || _panGestureBeginPoint.y == 0) return;
            CGPoint v = [g velocityInView:self.view];
            CGPoint p = [g locationInView:self.view];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000.f || fabs(deltaY) > 120.f) {
                [self.groupView cancelAllLoad];
                BOOL moveToTop = v.y < -50.f || (v.y < 50.f && deltaY < 0.f);
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1.f;
                CGFloat duration = (moveToTop ? self.groupView.arg_bottom : self.view.arg_height - self.groupView.arg_top) / vy;
                duration *= 0.8f;
                duration = AG_CLAMP(duration, 0.05f, 0.25f);
                [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState animations:^{
                    __strong typeof(&*wself) sself = wself;
                    if (!sself) return ;
                    sself.containerView.alpha = 0.f;
                    sself.pageController.alpha = 0.f;
                    if (moveToTop) {
                        sself.groupView.arg_bottom = 0.f;
                    }else{
                        sself.groupView.arg_top = sself.view.arg_height;
                    }
                } completion:^(BOOL finished) {
                    __strong typeof(&*wself) sself = wself;
                    if (!sself) return ;
                    [sself dismissViewControllerAnimated:NO completion:nil];
                }];
            }else{
                [UIView animateWithDuration:0.25f delay:0.f usingSpringWithDamping:0.9f initialSpringVelocity:v.y / 1000.f options:UIViewAnimationOptionCurveEaseInOut |UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState  animations:^{
                    __strong typeof(&*wself) sself = wself;
                    if (!sself) return ;
                    sself.groupView.arg_top = 0.f;
                    sself.containerView.alpha = 1.f;
                    sself.pageController.alpha = 1.f;
                } completion:nil];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            self.groupView.arg_top = 0.f;
            self.containerView.alpha = 1.f;
            self.pageController.alpha = 1.f;
        }
            break;
        default:
            break;
    }
}





#pragma mark - ARGGroupViewDelegate
- (NSInteger)groupView:(ARGGroupView *)groupView numberOfRowsInSection:(NSInteger)section
{
    return self.groupItems.count;
}

- (ARGGroupCell *)groupView:(ARGGroupView *)groupView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARGPhotoGroupCell *cell = [ARGPhotoGroupCell cellForGroupView:groupView];
    NSLog(@"cell Row :%@",[@(indexPath.row) stringValue]);
    cell.item = self.groupItems.count <= indexPath.row?nil:self.groupItems[indexPath.row];
    return cell;
}

- (void)groupView:(ARGGroupView *)groupView didDeceleratingAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(&*self) wself = self;
    self.pageController.currentPage = indexPath.row;
    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
         __strong typeof(&*wself) sself = wself;
        if (!sself) return ;
        sself.pageController.alpha = 1.f;
    } completion:nil];
}

- (void)groupView:(ARGGroupView *)groupView didEndDeceleratingAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(&*self) wself = self;
    self.pageController.currentPage = indexPath.row;
    [UIView animateWithDuration:0.25f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        __strong typeof(&*wself) sself = wself;
        if (!sself) return ;
        sself.pageController.alpha = 0.f;
    } completion:nil];
    
    self.fromView = self.groupItems.count <= indexPath.row?nil:[self.groupItems[indexPath.row] thumbView];
}


#pragma mark - getters
- (ARGPhotoTransitioning *)transitioning
{
    if (!_transitioning) {
        _transitioning = [ARGPhotoTransitioning new];
    }
    return _transitioning;
}

- (UIVisualEffectView *)blurEffect
{
    if (!_blurEffect) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffect = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _blurEffect;
}

- (ARGGroupView *)groupView
{
    if (!_groupView) {
        _groupView = [ARGGroupView new];
        _groupView.groupViewDelegate = self;
    }
    return _groupView;
}

- (UIPageControl *)pageController
{
    if (!_pageController) {
        _pageController = [UIPageControl new];
        _pageController.hidesForSinglePage = YES;
        _pageController.userInteractionEnabled = YES;
        _pageController.alpha = 0.f;
    }
    return _pageController;
}

#pragma mark - private
- (ARGPhotoGroupItem *)item
{
    for (ARGPhotoGroupItem *item in self.groupItems) {
        if ([item.thumbView isEqual:self.fromView]) {
            return item;
        }
    }
    return nil;
}

- (ARGPhotoGroupCell *)groupCell
{
    return [self.groupView currentCell];
}

@end
