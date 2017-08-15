//
//  ARGKit_ExampleUITests.m
//  ARGKit_ExampleUITests
//
//  Created by 吴哲 on 2017/8/14.
//  Copyright © 2017年 arcangelw. All rights reserved.
//

#import <XCTest/XCTest.h>


typedef void (^callback)(void);
/// 随机执行
void(^randomDone)(int maxRandomCount ,callback callback) = ^(int maxRandomCount ,callback callback) {
    for (int i = 0; i < arc4random_uniform(maxRandomCount); i ++) {
        if (callback) {
            callback();
        }
    }
};

void(^maxDone)(int maxCount ,callback callback) = ^(int maxCount ,callback callback) {
    for (int i = 0; i < maxCount; i ++) {
        if (callback) {
            callback();
        }
    }
};

NSUInteger randomRemainder(int remainderBase){
    return arc4random_uniform(remainderBase) % remainderBase;
}

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
    
    for (NSUInteger i = 0; i < 200; i ++) {
        if (randomRemainder(3) == 0) {
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
    
    
    for (NSUInteger i = 0; i < 20; i++) {
        
        XCUIElementQuery *scrollViewsQuery0 = app.scrollViews;
        
        XCUIElement *scrollView0 = [scrollViewsQuery0 elementBoundByIndex:0];
        
        if (randomRemainder(2) == 0) {
            randomDone(4 ,^(){
                [scrollView0 swipeUp];
            });
        }else{
            randomDone(2 ,^(){
                [scrollView0 swipeDown];
            });
        }
        
        XCUIElementQuery *imageViewQuery = [scrollViewsQuery0 childrenMatchingType:XCUIElementTypeImage];
        NSUInteger imageViewCount = imageViewQuery.count - 1;
        NSUInteger imageViewIdx = arc4random_uniform((int)imageViewCount);
        XCUIElement *imageView = [imageViewQuery elementBoundByIndex:imageViewIdx];
        [imageView tap];
        
        
        XCUIElementQuery *scrollViewsQuery1 = app.scrollViews;
        XCUIElement *scrollView1 = [scrollViewsQuery1 elementBoundByIndex:0];
        XCUIElement *(^photo)() = ^XCUIElement*() {
            return [app.scrollViews elementBoundByIndex:1];
        };
        XCUIElement *scrollView2 = photo();
        
        switch (randomRemainder(4)) {
            case 0:
            {
                randomDone(4,^(){
                    [scrollView1 swipeRight];
                });
                maxDone(2,^(){
                    [scrollView2 doubleTap];
                });
                randomDone(4,^(){
                    [scrollView1 swipeLeft];
                });
                [scrollView2 tap];
            }
                break;
            case 1:
            {
                randomDone(4,^(){
                    [scrollView1 swipeLeft];
                });
                randomDone(4,^(){
                    [scrollView1 swipeRight];
                });
                randomDone(4,^(){
                    [scrollView1 swipeLeft];
                });
                switch (randomRemainder(3)) {
                    case 0:
                        [scrollView2 tap];
                        break;
                    case 1:
                        [scrollView2 swipeDown];
                        break;
                    case 2:
                        [scrollView2 swipeUp];
                        break;
                    default:
                        break;
                }
            }
                break;
            case 2:
            {
                randomDone(4,^(){
                    [scrollView1 swipeRight];
                });
                maxDone(2,^(){
                    [scrollView2 doubleTap];
                });
                randomDone(4,^(){
                    [scrollView1 swipeLeft];
                });
                [scrollView1 swipeUp];
            }
                break;
            case 3:
            {
                randomDone(4,^(){
                    [scrollView1 swipeRight];
                });
                maxDone(2,^(){
                    [scrollView2 doubleTap];
                });
                randomDone(4,^(){
                    [scrollView1 swipeLeft];
                });
                [scrollView1 swipeDown];
            }
                break;
            default:
                break;
        }
    }

}




@end
