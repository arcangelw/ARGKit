//
//  ARGPhotoGroupView.h
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import <UIKit/UIKit.h>
#import "ARGGroupCell.h"


@class ARGGroupView;

NS_ASSUME_NONNULL_BEGIN
@protocol ARGGroupViewDelegate <NSObject>

- (NSInteger)groupView:(ARGGroupView *)groupView numberOfRowsInSection:(NSInteger)section;

- (ARGGroupCell *)groupView:(ARGGroupView *)groupView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInGroupView:(ARGGroupView *)groupView;


- (void)groupView:(ARGGroupView *)groupView didScrollTo:(ARGGroupCell *)groupCell atIndexPath:(NSIndexPath *)indexPath;


- (void)groupView:(ARGGroupView *)groupView didDeceleratingAtIndexPath:(NSIndexPath *)indexPath;
- (void)groupView:(ARGGroupView *)groupView didEndDeceleratingAtIndexPath:(NSIndexPath *)indexPath;
- (void)groupView:(ARGGroupView *)groupView didEndDisplayingAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ARGGroupView : UIScrollView <UIScrollViewDelegate>
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
/// groupViewDelegate
@property(nonatomic ,weak ,nullable) id<ARGGroupViewDelegate> groupViewDelegate;
- (nullable __kindof ARGGroupCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
/// padding default 20.f
@property(nonatomic ,assign) CGFloat padding;
/// currentCell
- (nullable __kindof ARGGroupCell *)currentCell;
/// currentIndexPath
@property(nonatomic ,readonly ,nullable) NSIndexPath *currnetIndexPath;

- (void)reloadData;
- (void)cancelAllLoad;
- (void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
@end
NS_ASSUME_NONNULL_END
