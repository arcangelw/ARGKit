//
//  ARGGroupCell.m
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import "ARGGroupCell.h"
#pragma mark - private
@interface ARGGroupCell()
/// reuseIdentifier
@property(nonatomic ,readwrite ,copy) NSString * reuseIdentifier;
@end
@implementation ARGGroupCell
@synthesize reuseIdentifier = _reuseIdentifier;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _reuseIdentifier = NSStringFromClass([self class]);
    }
    return self;
}

- (NSString *)reuseIdentifier
{
    return _reuseIdentifier;
}

- (void)dequeueReusable
{
}
@end
