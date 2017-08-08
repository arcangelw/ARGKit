//
//  UIView+ARGPhoto.m
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import "UIView+ARGPhoto.h"

@implementation UIView (ARGPhoto)
- (CGFloat)arg_left {
    return self.frame.origin.x;
}

- (void)setArg_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)arg_top {
    return self.frame.origin.y;
}

- (void)setArg_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)arg_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setArg_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)arg_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setArg_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)arg_width {
    return self.frame.size.width;
}

- (void)setArg_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)arg_height {
    return self.frame.size.height;
}

- (void)setArg_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)arg_centerX {
    return self.center.x;
}

- (void)setArg_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)arg_centerY {
    return self.center.y;
}

- (void)setArg_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)arg_origin {
    return self.frame.origin;
}

- (void)setArg_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)arg_size {
    return self.frame.size;
}

- (void)setArg_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
@end
