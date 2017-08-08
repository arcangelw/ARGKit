//
//  UIView+ARGPhoto.h
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import <UIKit/UIKit.h>

#define arg_isnan(x)                                                         \
( sizeof(x) == sizeof(float)  ? __inline_isnanf((float)(x))          \
: sizeof(x) == sizeof(double) ? __inline_isnand((double)(x))         \
: __inline_isnanl((long double)(x)))


@interface UIView (ARGPhoto)
@property (nonatomic) CGFloat arg_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat arg_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat arg_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat arg_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat arg_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat arg_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat arg_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat arg_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint arg_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  arg_size;        ///< Shortcut for frame.size.

@end
