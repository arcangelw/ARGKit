//
//  ARGPhotoGroupItem.m
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import "ARGPhotoGroupItem.h"
#import "UIView+ARGPhoto.h"

@implementation ARGPhotoGroupItem
- (id)copyWithZone:(NSZone *)zone
{
    return [self.class new];
}

- (UIImage *)thumbImage
{
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view
{
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.arg_width < 1 || view.arg_height < 1) return NO;
    return imageSize.height / imageSize.width > view.arg_width / view.arg_height;
}

- (BOOL)thumbClippedToTop
{
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1.f) {
            return YES;
        }
    }
    return NO;
}
@end
