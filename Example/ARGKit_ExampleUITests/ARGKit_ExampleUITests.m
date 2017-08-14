//
//  ARGKit_ExampleUITests.m
//  ARGKit_ExampleUITests
//
//  Created by 吴哲 on 2017/8/14.
//  Copyright © 2017年 arcangelw. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ARGKit_ExampleUITests : XCTestCase
/// app
@property(nonatomic ,strong) XCUIApplication *app;
@end

@implementation ARGKit_ExampleUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    self.app = [[XCUIApplication alloc] init];
    
    [self.app launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results
}


- (void)testEmptyPageViewControllerInsertAndRemove
{
    XCUIApplication *app = self.app;
    [app.tabBars.buttons[@"pageViewController"] tap];
    XCUIElement *pageviewcontrollerNavigationBar = app.navigationBars[@"pageViewController"];
    XCUIElement *button = pageviewcontrollerNavigationBar.buttons[@"+"];
    XCUIElement *button2 = pageviewcontrollerNavigationBar.buttons[@"-"];
    [button2 tap];
    
    for (NSUInteger i = 0; i < 200; i ++) {
        NSInteger random = arc4random_uniform(3);
        if (random % 3 == 0) {
            [button tap];
        }else{
            [button2 tap];
        }
    }
}

- (void)testEmptyPageViewControllerSwipe
{
    XCUIApplication *app = self.app;
    [app.tabBars.buttons[@"pageViewController"] tap];
    XCUIElement *element = [[[[[[[[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    for (NSUInteger i = 0; i < 200; i ++) {
        NSInteger random = arc4random_uniform(2);
        if (random % 2 == 0) {
            [element swipeLeft];
        }else{
            [element swipeRight];
        }
    }
}

- (void)testPhotoBrower
{
    
    
    XCUIApplication *app = self.app;
    [app.tabBars.buttons[@"\u56fe\u7247\u6d4f\u89c8\u5668"] tap];
    
    
    for (NSUInteger i  =  0; i < 20; i ++) {
        XCUIElementQuery *scrollViewsQuery0 = app.scrollViews;
        XCUIElement *scrollView0 = [scrollViewsQuery0 elementBoundByIndex:0];
        
        XCUIElementQuery *imageVeiwQuery = [scrollViewsQuery0 childrenMatchingType:XCUIElementTypeImage];
        NSUInteger imageViewCount = imageVeiwQuery.count - 1;
        NSInteger _double = arc4random_uniform(2);
        if (_double % 2 == 0) {
            [scrollView0 swipeUp];
        }else{
            [scrollView0 swipeDown];
        }
         XCUIElement *imageView = [imageVeiwQuery elementBoundByIndex:arc4random_uniform((int)imageViewCount)];
        [imageView tap];
        
        NSInteger _four = arc4random_uniform(4);
        
        XCUIElementQuery *scrollViewsQuery1 = app.scrollViews;
        XCUIElement *scrollView1 = [scrollViewsQuery1 elementBoundByIndex:1];
        
        
        switch (_four % 4) {
            case 0:
                [scrollView1 swipeRight];
                [scrollView1 swipeRight];
                [scrollView1 swipeRight];
                [scrollView1 swipeLeft];
                [scrollView1 swipeLeft];
                [scrollView1 tap];
                break;
            case 1:
                [scrollView1 swipeLeft];
                [scrollView1 swipeRight];
                [scrollView1 swipeRight];
                [scrollView1 swipeLeft];
                [scrollView1 doubleTap];
                break;
            case 2:
                [scrollView1 swipeRight];
                [scrollView1 swipeRight];
                [scrollView1 doubleTap];
                [scrollView1 swipeLeft];
                [scrollView1 swipeLeft];
                [scrollView1 tap];
                break;
            case 3:
                
                [scrollView1 swipeLeft];
                [scrollView1 swipeRight];
                [scrollView1 swipeRight];
                [scrollView1 swipeRight];
                [scrollView1 doubleTap];
                [scrollView1 doubleTap];
                [scrollView1 swipeLeft];
                [scrollView1 tap];
                break;
            default:
                break;
        }
        
    }
    
}




@end
