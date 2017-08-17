//
//  ARGAppDelegate.m
//  ARGKit
//
//  Created by arcangelw on 08/08/2017.
//  Copyright (c) 2017 arcangelw. All rights reserved.
//

#import "ARGAppDelegate.h"
#import "ARGViewController.h"
#import "ARGDemoPageViewController.h"
#import "ARGDemoEmptyViewController.h"
#import "ARGOffsetPageViewController.h"

@interface ARGNavigationBar : UINavigationBar

@end
@implementation ARGNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.barTintColor = [UIColor yellowColor];
    }
    return self;
}

@end


@implementation ARGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ARGDemoPageViewController *page = [[ARGDemoPageViewController alloc]init];
    UINavigationController *nav0  = [[UINavigationController alloc]initWithNavigationBarClass:[ARGNavigationBar class] toolbarClass:nil];
    [nav0 addChildViewController:page];
//    [nav0.navigationBar setTranslucent:NO];
    [nav0.navigationBar setBarStyle:UIBarStyleBlack];
    
    ARGDemoEmptyViewController *empty = [[ARGDemoEmptyViewController alloc]init];
    empty.title = @"pageViewController";
    UINavigationController *nav1  = [[UINavigationController alloc]initWithRootViewController:empty];
    [nav1.navigationBar setTranslucent:NO];
    
    ARGViewController *photo = [[ARGViewController alloc]init];
    photo.title = @"图片浏览器";
    UINavigationController *nav2  = [[UINavigationController alloc]initWithRootViewController:photo];
    [nav2.navigationBar setTranslucent:NO];
    [nav2.navigationBar setHidden:YES];
    
    
    ARGOffsetPageViewController *offset = [[ARGOffsetPageViewController alloc]init];
    offset.title = @"offset demo";
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:offset];
    [nav3.navigationBar setHidden:YES];
    
    
    UITabBarController *tabbar = [[UITabBarController alloc]init];
    [tabbar addChildViewController:nav0];
    [tabbar addChildViewController:nav1];
    [tabbar addChildViewController:nav2];
    [tabbar addChildViewController:nav3];
    [tabbar.tabBar setTranslucent:NO];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
