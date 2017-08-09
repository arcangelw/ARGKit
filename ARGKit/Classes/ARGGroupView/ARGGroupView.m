//
//  ARGPhotoGroupView.m
//  Pods
//
//  Created by 吴哲 on 2017/8/3.
//
//

#import "ARGGroupView.h"
#import "UIView+ARGPhoto.h"



@interface ARGGroupView()
{
    @private
    NSInteger _maxSectionCount;
    NSDictionary *_sectionRowCountTmp;
    NSInteger _groupViewMaxRowCount;
}
/// cacheCells
@property(nonatomic ,strong) NSMutableDictionary *cacheCells;
/// Sections
@property(nonatomic ,assign) NSInteger maxSectionCount;
/// sectionRowTmp
@property(nonatomic ,strong) NSDictionary *scetionRowCountTmp;
/// Sections
@property(nonatomic ,assign) NSInteger groupViewMaxRowCount;
/// currentIndexPath
@property(nonatomic ,strong) NSIndexPath *currnetIndexPath;
@end
@implementation ARGGroupView 
@synthesize maxSectionCount;
@synthesize scetionRowCountTmp;
@synthesize groupViewMaxRowCount;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllLoad];
    [self.cacheCells removeAllObjects];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self reloadData];
}

- (void)commonInit
{
    _maxSectionCount = 0;
    _groupViewMaxRowCount = 0;
    _sectionRowCountTmp = @{}.copy;
    _cacheCells = @{}.mutableCopy;
    self.padding = 20.f;
    self.delegate = self;
    self.scrollsToTop = NO;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    if ([self isEqual:delegate]) {
        [super setDelegate:self];
    }
}

- (void)setAlwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal
{
    if (self.alwaysBounceHorizontal != alwaysBounceHorizontal) {
        [super setAlwaysBounceHorizontal:alwaysBounceHorizontal];
    }
}

#pragma mark - private

- (void)reloadMaxSectionCount
{
    if (self.groupViewDelegate && [self.groupViewDelegate respondsToSelector:@selector(numberOfSectionsInGroupView:)]) {
        _maxSectionCount = [self.groupViewDelegate numberOfSectionsInGroupView:self];
    }else{
        _maxSectionCount = 1;
    }
    
    [self reloadSectionCountRowTmpAndMaxRowCount];
}

- (void)reloadSectionCountRowTmpAndMaxRowCount
{
    _groupViewMaxRowCount = 0;
    _sectionRowCountTmp = [NSDictionary dictionary];
    if (self.groupViewDelegate && [self.groupViewDelegate respondsToSelector:@selector(groupView:numberOfRowsInSection:)]) {
        NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
        for (NSInteger i = 0 ; i < _maxSectionCount; i ++) {
            NSInteger row = [self.groupViewDelegate groupView:self numberOfRowsInSection:i]?:0;
            _groupViewMaxRowCount += row;
            tmp[[@(i) stringValue]] = [@(row) stringValue];
        }
        _sectionRowCountTmp = [NSDictionary dictionaryWithDictionary:tmp];
        
    }
}

- (NSInteger)rowCountInSection:(NSInteger)section
{
    if (section < 0 && section >= self.maxSectionCount) {
        return 0;
    }
    NSString *rowCountS = self.scetionRowCountTmp[[@(section) stringValue]]?:@"0";
    return rowCountS.integerValue;
}


- (NSIndexPath *)indexPathInGroupViewPage:(NSInteger)page
{
    NSInteger rowPlus = 0;
    NSInteger bRowPlus = 0;
    for (NSInteger i = 0; i < self.maxSectionCount; i++) {
        rowPlus += [self rowCountInSection:i];
        bRowPlus += [self rowCountInSection:i - 1];
        if (page >= bRowPlus && page < rowPlus) {
            return [NSIndexPath indexPathForRow:page - bRowPlus inSection:i];
        }
    }
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (NSInteger)groupPageAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger page = indexPath.row?:0;
    for (NSInteger i = 0; i < indexPath.section; i++) {
        page += [self rowCountInSection:i];
    }
    return page;
}


- (NSInteger)maxSectionCount
{
   return _maxSectionCount;
}

- (NSDictionary *)scetionRowCountTmp
{
    return _sectionRowCountTmp;
}

- (NSInteger)groupViewMaxRowCount
{
    return _groupViewMaxRowCount;
}


- (ARGGroupCell * )currentCell
{
    return [self cellForIndexPath:self.currnetIndexPath];
}


- (ARGGroupCell * )getCellForIndexPath:(NSIndexPath *)indexPath
{
    ARGGroupCell * cell = [self cellForIndexPath:indexPath];;
    if (!cell && self.groupViewDelegate && [self.groupViewDelegate respondsToSelector:@selector(groupView:cellForRowAtIndexPath:)]) {
        cell = [self.groupViewDelegate groupView:self cellForRowAtIndexPath:indexPath];
        cell.indexPath = indexPath;
        NSMutableArray *cells = self.cacheCells[cell.reuseIdentifier];
        if (!cells) {
            cells = @{}.mutableCopy;
        }
        if (![cells containsObject:cell]) {
            [cells addObject:cell];
        }
        self.cacheCells[cell.reuseIdentifier] = cells;
    }
    if (!cell.superview) {
        [self addSubview:cell];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCellsForReuse];
    CGFloat floatPage = scrollView.contentOffset.x / scrollView.arg_width;
    NSInteger page = scrollView.contentOffset.x / scrollView.arg_width;
    self.alwaysBounceHorizontal = self.groupViewMaxRowCount > 1;
    for (NSInteger i = page - 1; i <= page + 1; i++) {
        if (i >= 0 && i < self.groupViewMaxRowCount) {
            NSIndexPath *indexPath = [self indexPathInGroupViewPage:i];
            ARGGroupCell *cell  = [self getCellForIndexPath:indexPath];
            cell.arg_top = 0.f;
            cell.arg_left = self.arg_width * i;
            cell.arg_size = scrollView.arg_size;
        }
    }
    
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= self.groupViewMaxRowCount ? self.groupViewMaxRowCount - 1 : intPage;

    self.currnetIndexPath = [self indexPathInGroupViewPage:intPage];
    
    [self paddingLayout];
}

- (void)paddingLayout
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ARGGroupCell class]]) {
            NSIndexPath *indexPath = ((ARGGroupCell *)view).indexPath;
            NSInteger page = [self groupPageAtIndexPath:indexPath];
            NSInteger currentPage = [self groupPageAtIndexPath:self.currnetIndexPath];
            if (page < currentPage) {
                view.arg_left = self.arg_width * page - self.padding;
            }else if (currentPage < page){
                view.arg_left = self.arg_width * page + self.padding;
            }else{
                view.arg_left = self.arg_width * page;
            }
        }
    }
}



- (void)setCurrnetIndexPath:(NSIndexPath *)currnetIndexPath
{
    if (_currnetIndexPath == currnetIndexPath) return;
    _currnetIndexPath = currnetIndexPath;
    
    if (self.groupViewDelegate && [self.groupViewDelegate respondsToSelector:@selector(groupView:didEndDisplayingAtIndexPath:)]) {
        [self.groupViewDelegate groupView:self didEndDisplayingAtIndexPath:_currnetIndexPath];
    }
#if DEBUG
    NSInteger i = 0;
    for (NSArray *cells in self.cacheCells.allValues) {
        i += cells.count;
    }
    NSLog(@"缓存池 cells : %@",[@(i) stringValue]);
#endif
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.groupViewDelegate && [self.groupViewDelegate respondsToSelector:@selector(groupView:didDeceleratingAtIndexPath:)]) {
        [self.groupViewDelegate groupView:self didDeceleratingAtIndexPath:self.currnetIndexPath];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.groupViewDelegate && [self.groupViewDelegate respondsToSelector:@selector(groupView:didDeceleratingAtIndexPath:)]) {
        [self.groupViewDelegate groupView:self didDeceleratingAtIndexPath:self.currnetIndexPath];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.groupViewDelegate && [self.groupViewDelegate respondsToSelector:@selector(groupView:didEndDeceleratingAtIndexPath:)]) {
        [self.groupViewDelegate groupView:self didEndDeceleratingAtIndexPath:self.currnetIndexPath];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (decelerate&&self.groupViewDelegate && [self.groupViewDelegate respondsToSelector:@selector(groupView:didDeceleratingAtIndexPath:)]) {
        [self.groupViewDelegate groupView:self didDeceleratingAtIndexPath:self.currnetIndexPath];
    }
    if (!decelerate&&self.groupViewDelegate && [self.groupViewDelegate respondsToSelector:@selector(groupView:didEndDeceleratingAtIndexPath:)]) {
        [self.groupViewDelegate groupView:self didEndDeceleratingAtIndexPath:self.currnetIndexPath];
    }
}


- (void)reloadData
{
    [self reloadMaxSectionCount];
    self.contentSize = CGSizeMake(self.arg_width * self.groupViewMaxRowCount, self.arg_height);
    [self scrollViewDidScroll:self];
}

- (void)cancelAllLoad
{
    for (NSArray *cells in self.cacheCells.allValues) {
        for (ARGGroupCell *cell in cells) {
            if (cell.superview) {
                [cell removeFromSuperview];
            }
            [cell dequeueReusable];
        }
    }
}

- (void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(self.arg_width * [self groupPageAtIndexPath:indexPath], 0.f) animated:animated];
}

- (void)updateCellsForReuse
{
    
    for (NSArray *cells in self.cacheCells.allValues) {
        for (ARGGroupCell *cell in cells) {
            if (cell.superview) {
                ///优化计算 保证缓存池中缓存cell数量最小
                if (cell.arg_left >= self.contentOffset.x + self.arg_width + self.padding || cell.arg_right <= self.contentOffset.x - self.arg_width - self.padding) {
                    [cell dequeueReusable];
                    [cell removeFromSuperview];
                }
            }
        }
    }
}

- (ARGGroupCell * )cellForIndexPath:(NSIndexPath *)indexPath
{
    
    for (NSArray *cells in self.cacheCells.allValues) {
        for (ARGGroupCell *cell in cells) {
            //缓存的cell必然绑定indexPath
            if ([cell.indexPath compare:indexPath] == NSOrderedSame) {
                return cell;
            }
        }
    }
    return nil;
}


- (ARGGroupCell * )dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    if (identifier == nil || identifier.length == 0) {
        identifier = NSStringFromClass([ARGGroupCell class]);
    }
    NSArray *cells = self.cacheCells[identifier];
    if (cells) {
        for (ARGGroupCell *cell in cells) {
            ///从缓存中取出未加载的视图的缓存view
            if (!cell.superview) {
                return cell;
            }
        }
    }else{
        self.cacheCells[identifier] = @[].mutableCopy;
    }
    return nil;
}

@end
