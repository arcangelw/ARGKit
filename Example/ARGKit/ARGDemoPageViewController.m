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
    NSMutableArray *vs = @[].mutableCopy;
    for (NSInteger i=0 ; i < 10; i++) {
        ARGViewController *v = [[ARGViewController alloc]init];
        v.title = [NSString stringWithFormat:@"浏览器%@",@(i)];
        [vs addObject:v];
    }
    [self setViewControllers:vs atSelectedIndex:6];
    
    
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
