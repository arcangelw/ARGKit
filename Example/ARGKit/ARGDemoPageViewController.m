//
//  ARGDemoPageViewController.m
//  ARGKit
//
//  Created by 吴哲 on 2017/8/9.
//  Copyright © 2017年 arcangelw. All rights reserved.
//

#import "ARGDemoPageViewController.h"
#import "ARGViewController.h"
@interface ARGDemoPageViewController ()

@end

@implementation ARGDemoPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSelectedIndex:6];
    self.contentInset = UIEdgeInsetsMake(64.f, 0.f, 0.f, 0.f);
    NSMutableArray *vs = @[].mutableCopy;
    for (NSInteger i=0 ; i < 10; i++) {
        ARGViewController *v = [[ARGViewController alloc]init];
        v.title = [NSString stringWithFormat:@"浏览器%@",@(i)];
        [vs addObject:v];
    }
    [self setViewControllers:vs atSelectedIndex:6];
    
    
}

@end
