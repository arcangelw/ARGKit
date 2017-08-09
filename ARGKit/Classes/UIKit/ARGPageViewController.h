//
//  ARGPageViewController.h
//  Pods
//
//  Created by 吴哲 on 2017/8/9.
//
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@interface ARGPageViewController : UIViewController

- (void)addChildViewController:(UIViewController *)childController UNAVAILABLE_ATTRIBUTE;
@property(nonatomic,readonly) NSArray<__kindof UIViewController *> *childViewControllers UNAVAILABLE_ATTRIBUTE;


/// contentInset
@property(nonatomic ,assign) UIEdgeInsets contentInset;

/// viewControllers
@property(nullable, nonatomic, copy) NSArray<__kindof UIViewController *> *viewControllers;

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewController atSelectedIndex:(NSUInteger)selectedIndex;

- (void)insertViewController:(nonnull UIViewController *)viewControllers atIndex:(NSUInteger)index;

- (void)removeAtIndex:(NSUInteger)index;
- (void)removeViewController:(nonnull UIViewController *)viewController;

/// selectedViewController
@property(nullable, nonatomic, assign) __kindof UIViewController *selectedViewController;

/// selectedIndex
@property(nonatomic) NSUInteger selectedIndex;

@end
NS_ASSUME_NONNULL_END
