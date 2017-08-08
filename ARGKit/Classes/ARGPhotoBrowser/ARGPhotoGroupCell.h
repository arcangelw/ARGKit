//
//  ARGPhotoGroupCell.h
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import "ARGGroupCell.h"


@class ARGPhotoGroupItem;
@class ARGGroupView;

NS_ASSUME_NONNULL_BEGIN
@interface ARGPhotoGroupCell : ARGGroupCell

+ (nullable instancetype)cellForGroupView:(ARGGroupView *)groupView;

/// scrollView
@property(nonatomic ,readonly ,strong ,nonnull) UIScrollView * scrollView;
/// containerView
@property(nonatomic ,readonly ,strong ,nonnull) UIView *containerView;
/// imageView
@property(nonatomic ,readonly ,strong ,nonnull) UIImageView * imageView;
/// progressLayer
@property(nonatomic ,readonly ,strong ,nonnull) CAShapeLayer *progressLayer;
/// item
@property(nonatomic ,strong, nullable) ARGPhotoGroupItem * item;
/// page
@property(nonatomic ,assign) NSInteger page;
/// image
@property(nonatomic ,readonly ,nullable) UIImage *image;

- (void)resizeSubviewSize;
@end
NS_ASSUME_NONNULL_END
