//
//  ARGViewController.m
//  ARGPhotoBrowser
//
//  Created by arcangelw on 08/03/2017.
//  Copyright (c) 2017 arcangelw. All rights reserved.
//

#import "ARGViewController.h"
#import <ARGKit/ARGPhotoBrowser.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <ARGKit/UIView+ARGPhoto.h>

@interface ARGViewController ()
/// tabelView
@property(nonatomic ,strong) UIScrollView *scrollView;
/// groupItems
@property(nonatomic ,strong) NSArray<ARGPhotoGroupItem *> * groupItems;

@end

@implementation ARGViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView *zeroHeightView = [UIView new];
//    zeroHeightView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
//    [zeroHeightView setFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, 0.f)];
//    [self.view addSubview:zeroHeightView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502173366193&di=56a62a9c0e66a84ecb33ae24fb31fda9&imgtype=0&src=http%3A%2F%2Fwww.ai1mi.com%2Fdata%2Fuploads%2F2014%2F0830%2F17%2F1409390969252541.jpg"] options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (image) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
            
        }
    }];
    
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
    
    for (NSInteger i = 0; i < self.groupItems.count; i ++) {
        UIImageView *imageView = [UIImageView new];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        imageView.arg_top = 180.f * i;
        imageView.arg_left = 0.f;
        imageView.arg_height = 180.f;
        imageView.arg_width = self.view.arg_width;
        [self.scrollView addSubview:imageView];
        ARGPhotoGroupItem *item = self.groupItems[i];
        [imageView sd_setImageWithURL:item.largeImageURL];
        item.thumbView = imageView;
    }
    self.scrollView.contentSize = CGSizeMake(self.view.arg_width, 180.f * self.groupItems.count);
    NSLog(@"%@ viewDidLoad ",self.title);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear",self.title);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%@ viewWillDisappear",self.title);
}

- (void)tap:(UITapGestureRecognizer *)t
{
    [self presentPhotoBrowserWithGroupItems:self.groupItems fromView:t.view blurEffect:YES completion:nil];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}


- (NSArray<ARGPhotoGroupItem *> *)groupItems
{
    if (!_groupItems) {
        NSArray *arr = @[
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502173366196&di=10eec79b0f9df7264ed706eed4ef96d1&imgtype=0&src=http%3A%2F%2Fimg1.gtimg.com%2Fent%2Fpics%2Fhv1%2F157%2F84%2F2207%2F143531752.jpg",
                         @"http://c.hiphotos.baidu.com/zhidao/pic/item/1f178a82b9014a909461e9baa1773912b31bee5e.jpg",
                         @"http://b.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=ca1fd2eb054f78f0805e92f74c012663/bd3eb13533fa828b97ecd15cfb1f4134960a5a45.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502674329&di=7cc08986f0de16725a2f6527d3ea26d4&imgtype=jpg&er=1&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201607%2F05%2F20160705132040_i2sKU.thumb.700_0.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502681588&di=84080b6e37efc393ba9bd55e3507ba47&imgtype=jpg&er=1&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201605%2F11%2F163014tkjbn8bj8z7b2wk0.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502086869343&di=52fc85456969f6fd307624eeb041f57f&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201407%2F29%2F20140729000620_LBNea.jpeg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502176469816&di=45f1ca6ef9d31d9c62b6b41fddf8743d&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F018a97577cb81e0000018c1b08b395.gif",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502086869342&di=2e2cc14d4759ce15af5f73fc500b3c03&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201411%2F02%2F20141102213013_RuaFL.jpeg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502173366196&di=0dc7c2b803d9cbba062685a6929e3fcc&imgtype=0&src=http%3A%2F%2Fimg4q.duitang.com%2Fuploads%2Fitem%2F201411%2F05%2F20141105003804_hQFiB.jpeg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502173366195&di=939c1e54dfb456dc1be08be7cff31b72&imgtype=0&src=http%3A%2F%2Fimg4q.duitang.com%2Fuploads%2Fitem%2F201411%2F23%2F20141123072535_28aMM.jpeg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502173366193&di=56a62a9c0e66a84ecb33ae24fb31fda9&imgtype=0&src=http%3A%2F%2Fwww.ai1mi.com%2Fdata%2Fuploads%2F2014%2F0830%2F17%2F1409390969252541.jpg",
                         @"http://cdn.duitang.com/uploads/item/201410/05/20141005022416_Ac2HE.jpeg",
                         @"http://pic36.nipic.com/20131230/1081324_162448614138_2.jpg",
                         @"http://cdn.duitang.com/uploads/item/201409/20/20140920223231_zSUnZ.jpeg",
                         @"http://img5.duitang.com/uploads/item/201409/19/20140919025324_5NGx4.jpeg"
                         ];
        NSMutableArray *a = @[].mutableCopy;
        for (NSString *url in arr) {
            ARGPhotoGroupItem *item = [ARGPhotoGroupItem new];
            item.largeImageURL = [NSURL URLWithString:url];
            [a addObject:item];
        }
        _groupItems = a.copy;
    }
    return _groupItems;
}

@end
