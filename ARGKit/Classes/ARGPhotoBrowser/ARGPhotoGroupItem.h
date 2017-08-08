//
//  ARGPhotoGroupItem.h
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface ARGPhotoGroupItem : NSObject <NSCopying>
/// thumbView
@property(nonatomic ,strong ,nullable) UIView *thumbView;
/// largeImageURL
@property(nonatomic ,strong ,nonnull) NSURL *largeImageURL;
/// thumbImage
@property(nonatomic ,readonly ,nullable) UIImage *thumbImage;

@property(nonatomic, readonly) BOOL thumbClippedToTop;
@end
NS_ASSUME_NONNULL_END
