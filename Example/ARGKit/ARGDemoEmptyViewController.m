//
//  ARGDemoEmptyViewController.m
//  ARGKit
//
//  Created by 吴哲 on 2017/8/14.
//  Copyright © 2017年 arcangelw. All rights reserved.
//

#import "ARGDemoEmptyViewController.h"

@implementation ARGDemoEmptyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.f green:arc4random_uniform(255)/255.f blue:arc4random_uniform(255)/255.f alpha:1.f];
    self.contentInset = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(insert)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"-" style:UIBarButtonItemStyleDone target:self action:@selector(remove)];
    
    NSMutableArray *vs = @[].mutableCopy;
    for (NSInteger i=0 ; i < 9; i++) {
        UIViewController *v = [[UIViewController alloc]init];
        v.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.f green:arc4random_uniform(255)/255.f blue:arc4random_uniform(255)/255.f alpha:1.f];
//        v.view.backgroundColor = []
        v.title = @"pageViewController";
        [vs addObject:v];
    }
    self.viewControllers = vs.copy;
}

- (void)insert
{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.title = @"pageViewController";
    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.f green:arc4random_uniform(255)/255.f blue:arc4random_uniform(255)/255.f alpha:1.f];
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


@end
