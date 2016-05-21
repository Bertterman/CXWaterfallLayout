//
//  CXWaterfallLayout.m
//  瀑布流
//
//  Created by betterman on 16/5/20.
//  Copyright © 2016年 betterman. All rights reserved.
//

#import "CXWaterfallLayout.h"

/** 默认的列数 */
static const NSInteger CXDefaultColumnCount = 3;
/** 每一列默认的间距 */
static const CGFloat CXDefaultColumnMargin = 10;
/** 每一行默认的间距 */
static const CGFloat CXDefaultRowMargin = 10;
/** 边缘的间距 */
static const UIEdgeInsets CXDefaultEdgeInsets = {10,10,10,10};

@interface CXWaterfallLayout()

/** 所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存放每一列最小高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

-(CGFloat)rowMargin;
-(CGFloat)columnMargin;
-(NSInteger)columnCount;
-(UIEdgeInsets)edgeInsets;

@end


@implementation CXWaterfallLayout

#pragma mark - 代理方法处理
/** 行间距 */
-(CGFloat)rowMargin{

    // 如果代理方法实现，就用传过来的值
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterfallLayout:)]) {
        
        return [self.delegate rowMarginInWaterfallLayout:self];
    }else{
        return  CXDefaultRowMargin;
    }
}
/** 列间距 */
-(CGFloat)columnMargin{
    
    // 如果代理方法实现，就用传过来的值
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterfallLayout:)]) {
        
        return [self.delegate columnMarginInWaterfallLayout:self];
    }else{
        return  CXDefaultColumnMargin;
    }
}
/** 列数 */
-(NSInteger)columnCount{
    
    // 如果代理方法实现，就用传过来的值
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterfallLayout:)]) {
        
        return [self.delegate columnCountInWaterfallLayout:self];
    }else{
        return  CXDefaultColumnCount;
    }
}
/** 上下左右间距 */
-(UIEdgeInsets)edgeInsets{
    
    // 如果代理方法实现，就用传过来的值
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterfallLayout:)]) {
        
        return [self.delegate edgeInsetsInWaterfallLayout:self];
    }else{
        return  CXDefaultEdgeInsets;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)columnHeights {

    if (_columnHeights == nil) {
        
        _columnHeights = [NSMutableArray array];
    }

    return _columnHeights;
}


- (NSMutableArray *)attrsArray {

    if (_attrsArray == nil) {
        
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

/**
 *  初始化,
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    // 刷新高度数组里的数据
    [self.columnHeights removeAllObjects];
    
    for (NSInteger i = 0; i < self.columnCount; i++) {
        
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    

    // 每次刷新都会调用prepareLayout这个方法，self.attrsArray装得东西会越来越多，每次刷新先清空这个数组
    [self.attrsArray removeAllObjects];
    
    
    // 开始创建每一个cell的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i= 0; i < count; i++) {
        
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        //获取indexPath位置的cell对应的布局属性
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attr];
        
    }
    
}


/**
 *  决定cell的排布
 *
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    return self.attrsArray;
}

/**
 *  返回indexPath对应的cell的布局属性
 *
 *  @param indexPath cell对应的位置
 *
 *  @return 布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    // 创建布局属性
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collectionView的高度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    //设置布局属性的frame
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1)*self.columnMargin)/self.columnCount;
    CGFloat h = [self.delegate waterfallLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    //找出高度最小的那一列
//    __block NSInteger destColumn = 0;
//    __block CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
//    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *columnHeightNumber, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        CGFloat columnHeight = [columnHeightNumber doubleValue];
//        if (minColumnHeight > columnHeight) {
//            minColumnHeight = columnHeight;
//            destColumn = idx;
//        }
//        
//    }];
    
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0]doubleValue];;
    for (NSInteger i = 1; i < self.columnCount; i++) {
        
        //取出第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (self.columnMargin + w);
    
   
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        
        y += self.rowMargin;
       
    }
    attr.frame = CGRectMake(x, y, w, h);

    //更新高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attr.frame));
    // 计算内容的总高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }

    return attr;
}



- (CGSize)collectionViewContentSize {

//    CGFloat maxColumnHeight = [self.columnHeights[0]doubleValue];
//    for (NSInteger i = 1; i < self.columnCount; i++) {
//        
//        //取出第i列的高度
//        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
//        if (maxColumnHeight < columnHeight) {
//            maxColumnHeight = columnHeight;
//        }
//    }
    
    return  CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}



@end
