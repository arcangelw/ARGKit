//
//  ARGPageViewController.h
//  Pods
//
//  Created by 吴哲 on 2017/8/9.
//
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@class ARGPageViewController;
@protocol ARGPageViewControllerSubclassing<NSObject>
/// 若子类遵循协议 必需实现协议方法
@required
/**
 *  @brief  分页控制器将要滑动到指定页
 *
 *  @param pageViewController 分页控制器
 *  @param viewController     将要显示的页面
 *  @param index              将要显示页面的索引
 *  @param progress           滑动进度  小于0大于等于-1 向左滑动 大于0小于等于1 向右滑动
 */
- (void)pageViewController:(nonnull ARGPageViewController *)pageViewController willTransitionToViewController:(nonnull UIViewController *)viewController index:(NSUInteger)index progress:(CGFloat)progress;

/**
 *  @brief 分页控制器已经滑动到指定页
 *
 *  @param pageViewController 分页控制器
 *  @param viewController     当前页面
 *  @param index              当前页面索引
 */
- (void)pageViewController:(nonnull ARGPageViewController *)pageViewController didTransitionToViewController:(nonnull UIViewController *)viewController index:(NSUInteger)index;

@end

@interface ARGPageViewController : UIViewController

- (void)addChildViewController:(UIViewController *)childController UNAVAILABLE_ATTRIBUTE;
@property(nonatomic,readonly) NSArray<__kindof UIViewController *> *childViewControllers UNAVAILABLE_ATTRIBUTE;

/// contentInset
@property(nonatomic ,assign) UIEdgeInsets contentInset;

/// viewControllers
@property(nullable, nonatomic, copy) NSArray<__kindof UIViewController *> *viewControllers;

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewController atSelectedIndex:(NSUInteger)selectedIndex;


- (void)insertViewController:(nonnull UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)insertViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers atIndex:(NSUInteger)index;


- (void)removeAtIndex:(NSUInteger)index;
- (void)removeViewController:(nonnull UIViewController *)viewController;

/// selectedViewController
@property(nullable, nonatomic, readonly, assign) __kindof UIViewController *selectedViewController;

/// selectedIndex
@property(nonatomic) NSUInteger selectedIndex;
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

@end
NS_ASSUME_NONNULL_END
