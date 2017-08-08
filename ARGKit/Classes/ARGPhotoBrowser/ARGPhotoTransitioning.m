//
//  ARGPhotoTransitioning.m
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import "ARGPhotoTransitioning.h"
#import "ARGPhotoBrowser.h"
#import "ARGGroupView.h"
#import "ARGPhotoGroupCell.h"
#import "UIView+ARGPhoto.h"

NS_ASSUME_NONNULL_BEGIN
@interface ARGPhotoBrowser()
/// item
@property(nonatomic ,readonly ,strong ,nullable) ARGPhotoGroupItem *item;
/// imageView
@property(nonatomic ,readonly ,strong ,nullable) ARGPhotoGroupCell *groupCell;
/// groupView
@property(nonatomic ,readonly , strong ,nonnull) ARGGroupView *groupView;
/// pageController
@property(nonatomic ,readonly , strong ,nonnull) UIPageControl *pageController;
/// containerView
@property(nonatomic ,readonly , strong ,nonnull) UIView *containerView;
- (void)scrollToFrom;
@end
NS_ASSUME_NONNULL_END

@interface ARGPhotoPresentAnimatedTransitioning:NSObject <UIViewControllerAnimatedTransitioning>
@end
@implementation ARGPhotoPresentAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ARGPhotoBrowser *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ARGPhotoGroupItem *item = to.item;
    UIView *from = item.thumbView;
    if (from) {
        return 0.5f;
    }
    return 0.05f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    ARGPhotoBrowser *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ARGPhotoGroupItem *item = to.item;
    UIView *from = item.thumbView;
    ARGPhotoGroupCell *cell = to.groupCell;
    to.view.frame = containerView.bounds;
    [containerView addSubview:to.view];
    [to scrollToFrom];
    if (!from || !cell) {
        [transitionContext completeTransition:YES];
        return;
    }
    
    if (item.thumbClippedToTop) {
        CGRect fromFrame = [from convertRect:from.bounds toView:cell];
        CGRect originFrame = cell.containerView.frame;
        CGFloat scale = fromFrame.size.width / cell.containerView.arg_width;
        
        cell.containerView.arg_centerX = CGRectGetMidX(fromFrame);
        cell.containerView.arg_height = fromFrame.size.height / scale;
        [cell.containerView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
        cell.imageView.arg_centerY = CGRectGetMidY(fromFrame);
        
        NSTimeInterval oneTime =  0.5f;
        
        to.containerView.alpha = 0.f;
        from.hidden = YES;
        [UIView animateWithDuration:oneTime delay:0.f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            to.containerView.alpha = 1.f;
        } completion:^(BOOL finished) {
            from.hidden = NO;
        }];
        
        to.view.userInteractionEnabled = NO;
        to.groupView.userInteractionEnabled = NO;
        to.pageController.alpha = 0.f;
        [UIView animateWithDuration:oneTime delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [cell.containerView.layer setValue:@(1.f) forKeyPath:@"transform.scale"];
            cell.containerView.frame = originFrame;
            to.pageController.alpha = 1.f;
        } completion:^(BOOL finished) {
            to.pageController.alpha = 0.f;
            to.view.userInteractionEnabled = YES;
            to.groupView.userInteractionEnabled = YES;
            [transitionContext completeTransition:finished];
        }];
        
    }else{
        CGRect fromFrame = [from convertRect:from.bounds toView:cell.containerView];
        
        cell.containerView.clipsToBounds = NO;
        cell.imageView.frame = fromFrame;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        NSTimeInterval oneTime = 0.5f/2.f;
        
        to.containerView.alpha = 0.f;
        from.alpha = 0.f;
        [UIView animateWithDuration:oneTime * 2.f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            to.containerView.alpha = 1.f;
        } completion:^(BOOL finished) {
            from.alpha = 1.f;
        }];
        
        to.view.userInteractionEnabled = NO;
        to.groupView.userInteractionEnabled = NO;
        to.pageController.alpha = 0.f;
        [UIView animateWithDuration:oneTime delay:0.f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageView.frame = cell.containerView.bounds;
            [cell.imageView.layer setValue:@(1.01f) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:oneTime delay:0.f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
                [cell.imageView.layer setValue:@(1.f) forKeyPath:@"transform.scale"];
                to.pageController.alpha = 1.f;
            } completion:^(BOOL finished) {
                to.pageController.alpha = 0.f;
                to.view.userInteractionEnabled = YES;
                to.groupView.userInteractionEnabled = YES;
                [transitionContext completeTransition:finished];
            }];
        }];
    }
}

@end


@interface ARGPhotoDismissAnimatedTransitioning:NSObject <UIViewControllerAnimatedTransitioning>
@end
@implementation ARGPhotoDismissAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ARGPhotoBrowser *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ARGPhotoGroupItem *item = from.item;
    UIView *to = item.thumbView;
    if (to) {
        return 0.35f;
    }
    return 0.05f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    ARGPhotoBrowser *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ARGPhotoGroupItem *item = from.item;
    UIView *to = item.thumbView;
    ARGPhotoGroupCell *cell = from.groupCell;
    
    if (!to || !cell) {
//        [containerView bringSubviewToFront:from.view];
        [transitionContext completeTransition:YES];
        return;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (item.thumbClippedToTop) {
        CGRect frame = cell.containerView.frame;
        cell.containerView.layer.anchorPoint = CGPointMake(0.5f, 0.f);
        cell.containerView.frame = frame;
    }
    cell.progressLayer.hidden = YES;
    [CATransaction commit];

    if (item.thumbClippedToTop) {
        CGPoint off = cell.scrollView.contentOffset;
        off.y = 0 - cell.scrollView.contentInset.top;
        [cell.scrollView setContentOffset:off animated:NO];
    }

    to.hidden = YES;
    [containerView bringSubviewToFront:from.view];
    cell.imageView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        from.pageController.alpha = 0.f;
        from.containerView.alpha = 0.f;
        if (item.thumbClippedToTop) {
            CGRect toFrame = [to convertRect:to.bounds toView:cell];
            CGFloat scale = toFrame.size.width / cell.containerView.arg_width * cell.scrollView.zoomScale;
            CGFloat height = toFrame.size.height / toFrame.size.width * cell.containerView.arg_width;
            height = arg_isnan(height);
            cell.containerView.arg_height = height;
            cell.containerView.center = CGPointMake(CGRectGetMidX(toFrame), CGRectGetMidY(toFrame));
            [cell.containerView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
        }else{
            CGRect toFrame = [to convertRect:to.bounds toView:cell.imageView];
            cell.containerView.clipsToBounds = NO;
            cell.imageView.contentMode = to.contentMode;
            cell.imageView.frame = toFrame;
        }
    } completion:^(BOOL finished) {
        to.hidden = YES;
        [UIView animateWithDuration:0.15f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
            from.containerView.alpha = 0.f;
        } completion:^(BOOL finished) {
            to.hidden = NO;
            cell.containerView.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
            [transitionContext completeTransition:finished];
        }];
    }];
    
}

@end


@interface ARGPhotoTransitioning ()
/// presentAnimated
@property(nonatomic ,strong) ARGPhotoPresentAnimatedTransitioning *presentAnimated;
/// dismissAnimated
@property(nonatomic ,strong) ARGPhotoDismissAnimatedTransitioning *dismissAnimated;
@end
@implementation ARGPhotoTransitioning

- (instancetype)init
{
    self = [super init];
    if (self) {
        _presentAnimated = [ARGPhotoPresentAnimatedTransitioning new];
        _dismissAnimated = [ARGPhotoDismissAnimatedTransitioning new];
    }
    return self;
}
/// present
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentAnimated;
}


/// dismiss
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimated;
}


@end
