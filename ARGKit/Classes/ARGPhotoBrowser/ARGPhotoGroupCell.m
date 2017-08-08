//
//  ARGPhotoGroupCell.m
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import "ARGPhotoGroupCell.h"
#import "ARGGroupView.h"
#import "ARGPhotoGroupItem.h"

#import "UIView+ARGPhoto.h"

#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>


#define _arg_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

@interface ARGPhotoGroupCell ()<UIScrollViewDelegate>
/// scrollView
@property(nonatomic ,strong) UIScrollView *scrollView;
/// containerView
@property(nonatomic ,strong) UIView *containerView;
/// imageView
@property(nonatomic ,strong) UIImageView *imageView;
/// progress
@property(nonatomic ,assign) CGFloat progress;
/// progressLayer
@property(nonatomic ,strong) CAShapeLayer *progressLayer;
/// itemDidLoad
@property(nonatomic ,assign) BOOL itemDidLoad;
/// containerViewSize
//@property(nonatomic, assign) CGSize containerViewSize;
@end
@implementation ARGPhotoGroupCell
@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;
@synthesize imageView = _imageView;
@synthesize progressLayer = _progressLayer;

+ (instancetype)cellForGroupView:(ARGGroupView *)groupView
{
    ARGPhotoGroupCell *cell = [groupView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [ARGPhotoGroupCell new];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)dequeueReusable
{
    [self.imageView sd_cancelCurrentImageLoad];
}

- (void)commonInit
{
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    _scrollView.bouncesZoom = YES;
    _scrollView.minimumZoomScale = 0.5f;
    _scrollView.maximumZoomScale = 3.f;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    [self addSubview:_scrollView];
    
    _containerView = [UIView new];
    _containerView.clipsToBounds = YES;
    [_scrollView addSubview:_containerView];
    
    
    _imageView = [UIImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    [_containerView addSubview:_imageView];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = CGRectMake(0.f, 0.f, 40.f, 40.f);
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.200].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 11, 11) cornerRadius:9];
    // 默认一点进度
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 18;
    _progressLayer.lineCap = kCALineCapButt;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    _progressLayer.borderWidth = 1;
    _progressLayer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.layer addSublayer:_progressLayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
    CGRect frame = _progressLayer.frame;
    frame.origin.x = self.arg_width / 2.f - frame.size.width * 0.5;
    frame.origin.y = self.arg_height / 2.f - frame.size.height * 0.5;
    _progressLayer.frame = frame;
    [self resizeSubviewSize];
}


- (UIImage *)image
{
    if (_imageView) {
        return _imageView.image;
    }
    return nil;
}

- (void)setItem:(ARGPhotoGroupItem *)item
{
    if (_item == item) return;
    _item = item;
    
    _itemDidLoad = NO;
    self.scrollView.minimumZoomScale = 1.f;
    self.scrollView.maximumZoomScale = 1.f;
    [self.scrollView setZoomScale:1.f animated:YES];
    
    [_imageView sd_cancelCurrentImageLoad];
    
    [_imageView.layer removeAnimationForKey:@"arg.fade"];
    
    _progressLayer.hidden = YES;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_item) {
        _imageView.image = nil;
        return;
    }
    
    __weak typeof(&*self) wself = self;
    [_imageView sd_setImageWithURL:item.largeImageURL placeholderImage:item.thumbImage options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        __strong typeof(&*wself) sself = wself;
        if (!sself) return ;
        CGFloat progress = receivedSize / (CGFloat)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        if (arg_isnan(progress)) progress = 0;
        _arg_dispatch_main_async_safe(^{
            sself.progressLayer.hidden = NO;
            sself.progressLayer.strokeEnd = progress;
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __strong typeof(&*wself) sself = wself;
        if (!sself) return ;
        _arg_dispatch_main_async_safe(^{
            sself.progressLayer.hidden = YES;
            sself.scrollView.minimumZoomScale = 0.5;
            sself.scrollView.maximumZoomScale = 3;
            if (image) {
                sself->_itemDidLoad = YES;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.1f;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                transition.type = kCATransitionFade;
                [sself.imageView.layer addAnimation:transition forKey:@"arg.fade"];
                [sself setNeedsLayout];
            }
        });
    }];
    [self setNeedsLayout];
}


- (void)resizeSubviewSize {
    _containerView.arg_origin = CGPointZero;
    _containerView.arg_width = self.arg_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.arg_height / self.arg_width) {
        _containerView.arg_height = floor(image.size.height / (image.size.width / self.arg_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.arg_width;
        if (height < 1 || arg_isnan(height)) height = self.arg_height;
        height = floor(height);
        _containerView.arg_height = height;
        _containerView.arg_centerY = self.arg_height / 2;
    }
    if (_containerView.arg_height > self.arg_height && _containerView.arg_height - self.arg_height <= 1) {
        _containerView.arg_height = self.arg_height;
    }
    self.scrollView.contentSize = CGSizeMake(self.arg_width, MAX(_containerView.arg_height, self.arg_height));
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];

    if (_containerView.arg_height <= self.arg_height) {
        self.scrollView.alwaysBounceVertical = NO;
    } else {
        self.scrollView.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _containerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _containerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


@end
