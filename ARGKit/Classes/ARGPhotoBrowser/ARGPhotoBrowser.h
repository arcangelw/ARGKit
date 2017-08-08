//
//  ARGPhotoBrowser.h
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import <UIKit/UIKit.h>
#import "ARGPhotoGroupItem.h"


@class ARGPhotoBrowser;


NS_ASSUME_NONNULL_BEGIN

///浏览器将要弹出通知
UIKIT_EXTERN NSString *const kARGPhotoGroupViewWillActivation;

@interface UIViewController (ARGPhoto)
/**
 *  @brief 弹出图片浏览器
 *
 *  @param groupItems                   图片信息
 *  @param fromView                     跳转来源 做跳转动画
 *  @param blurEffectBackground         是否需要模糊背景 不设置默认不显示
 *  @param completion                   跳转完成回调
 */
- (nonnull instancetype)presentPhotoBrowserWithGroupItems:(NSArray<ARGPhotoGroupItem *> *)groupItems fromView:(UIView *)fromView blurEffect:(BOOL)blurEffectBackground completion:(void (^ __nullable)(void))completion;
- (nonnull instancetype)presentPhotoBrowserWithGroupItems:(NSArray<ARGPhotoGroupItem *> *)groupItems fromView:(UIView *)fromView completion:(void (^ __nullable)(void))completion;


@end

@interface ARGPhotoBrowser : UIViewController

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)initWithGroupItems:(NSArray<ARGPhotoGroupItem*> *)groupItems fromView:(UIView *)fromView;

/// Default is YES
@property (nonatomic, assign) BOOL blurEffectBackground;

/// longPress
@property(nonatomic ,copy ,nullable) void(^longPressBlock)(UIImage *image);

@end
NS_ASSUME_NONNULL_END
