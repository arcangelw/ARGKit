//
//  ARGDemoPageViewController.m
//  ARGKit
//
//  Created by 吴哲 on 2017/8/9.
//  Copyright © 2017年 arcangelw. All rights reserved.
//

#import "ARGDemoPageViewController.h"
#import "ARGViewController.h"
@interface ARGDemoPageViewController ()<ARGPageViewControllerSubclassing>

@end

@implementation ARGDemoPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(insert)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"-" style:UIBarButtonItemStyleDone target:self action:@selector(remove)];
    
    NSMutableArray *vs = @[].mutableCopy;
    for (NSInteger i=0 ; i < 5; i++) {
        ARGViewController *v = [[ARGViewController alloc]init];
        v.title = [NSString stringWithFormat:@"浏览器%@",@(i)];
        [vs addObject:v];
    }
    
    [self setViewControllers:vs atSelectedIndex:0];
}

- (void)insert
{
    ARGViewController *vc = [[ARGViewController alloc]init];
    vc.title = [NSString stringWithFormat:@"insert 浏览器%@",@(self.viewControllers.count)];
    NSUInteger idx = arc4random_uniform((uint32_t)self.viewControllers.count);
    [self insertViewController:vc atIndex:idx];
//    NSMutableArray *vs = @[].mutableCopy;
//    for (NSInteger i=0 ; i < 2; i++) {
//        ARGViewController *v = [[ARGViewController alloc]init];
//        v.title = [NSString stringWithFormat:@"insert 浏览器%@",@(i)];
//        [vs addObject:v];
//    }
//    [self insertViewControllers:vs atIndex:2];
}

- (void)remove
{
    NSUInteger idx = arc4random_uniform((uint32_t)self.viewControllers.count);
    [self removeAtIndex:idx];
}



- (void)pageViewController:(ARGPageViewController *)pageViewController willTransitionToViewController:(UIViewController *)viewController index:(NSUInteger)index progress:(CGFloat)progress
{
    NSLog(@"pageViewController will to indx : %lu  progress : %f",(unsigned long)index , progress);
}

- (void)pageViewController:(ARGPageViewController *)pageViewController didTransitionToViewController:(UIViewController *)viewController index:(NSUInteger)index
{
    NSLog(@"pageViewController did to indx :%lu",(unsigned long)index);
}

@end
