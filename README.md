# CXWaterfallLayout
Waterfall FlowLayout
根据UICollectionViewLayout写的布局类瀑布流
重写了它内部实现布局的的四个方法
```
/**  初始化*/
- (void)prepareLayout;

/** 决定item的排布 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;

/**
 *  返回indexPath对应的cell的布局属性
 *  @param indexPath cell对应的位置
 *  @return 布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

	//在这个方法中计算每个item的位置信息；
    //找到每一列高度最小的，下一个item就将放入该列；
}
- (CGSize)collectionViewContentSize;
```

