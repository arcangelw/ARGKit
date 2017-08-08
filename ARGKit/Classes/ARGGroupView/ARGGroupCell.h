//
//  ARGGroupCell.h
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface ARGGroupCell : UITableViewCell
/// reuseIdentifier
@property(nonatomic ,readonly ,copy ,nonnull) NSString * reuseIdentifier;
/// indexPath
@property(nonatomic ,strong ,nullable) NSIndexPath * indexPath;

/// 离开视图队列
- (void)dequeueReusable;

@end
NS_ASSUME_NONNULL_END
