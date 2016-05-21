//
//  CXWaterfallLayout.h
//  瀑布流
//
//  Created by betterman on 16/5/20.
//  Copyright © 2016年 betterman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXWaterfallLayout;

@protocol CXWaterfallLayoutDelegate <NSObject>

@required
/** 每个item的高度 */
- (CGFloat)waterfallLayout:(CXWaterfallLayout *)waterfallLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/** 总共有几列 */
-(CGFloat) columnCountInWaterfallLayout:(CXWaterfallLayout *)waterfallLayout;
/** 列间距 */
-(CGFloat) columnMarginInWaterfallLayout:(CXWaterfallLayout *)waterfallLayout;
/** 行间距 */
-(CGFloat) rowMarginInWaterfallLayout:(CXWaterfallLayout *)waterfallLayout;
/** 上下左右间距 */
-(UIEdgeInsets) edgeInsetsInWaterfallLayout:(CXWaterfallLayout *)waterfallLayout;

@end

@interface CXWaterfallLayout : UICollectionViewLayout

/** 代理 */
@property (nonatomic, weak) id <CXWaterfallLayoutDelegate> delegate;


@end
