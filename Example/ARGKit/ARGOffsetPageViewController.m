//
//  ARGOffsetPageViewController.m
//  ARGKit
//
//  Created by 吴哲 on 2017/8/17.
//  Copyright © 2017年 arcangelw. All rights reserved.
//

#import "ARGOffsetPageViewController.h"
#import "ARGOfsetTableViewController.h"
@interface ARGOffsetPageViewController ()

@end

@implementation ARGOffsetPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ARGOfsetTableViewController *table = [[ARGOfsetTableViewController alloc]init];
    table.title = @"offset demo";
    [self setViewControllers:@[table]];

}

@end
