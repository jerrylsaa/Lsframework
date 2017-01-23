//
//  MineCollectionFlowLayout.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MineCollectionFlowLayout.h"

@implementation MineCollectionFlowLayout


/**
 * 用来做布局的初始化操作
 */
- (void)prepareLayout
{
    [super prepareLayout];
//    // 水平滚动
//    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    // 设置内边距
//    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
//    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用 layoutAttributesForElementsInRect:方法
 */
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;//最终要停下来的X
    rect.size = self.collectionView.frame.size;
    
//    WSLog(@"%@",NSStringFromCGRect(rect));
    
    //获得计算好的属性
    NSArray *attsArray = [super layoutAttributesForElementsInRect:rect];
    //计算collection中心点X
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2;
    WSLog(@"%g&&&&&%g*****%g",proposedContentOffset.x,self.collectionView.frame.size.width / 2.0,centerX);
    CGFloat minSpace = MAXFLOAT;
    UICollectionViewLayoutAttributes* currentAttrs = nil;
    
    if(proposedContentOffset.x == 0){
        minSpace = 40;
    }else{
        for (UICollectionViewLayoutAttributes *attrs in attsArray) {
            //        WSLog(@"%@",NSStringFromCGPoint(attrs.center));
//            WSLog(@"***%g===%g",attrs.center.x,attrs.center.x - centerX);
            if (ABS(minSpace) > ABS(attrs.center.x - centerX)) {
                minSpace = attrs.center.x - centerX;
                currentAttrs = attrs;
                //            minSpace = attrs.frame.origin.x;
                WSLog(@"====%g",attrs.center.x - centerX);
            }
        }
        minSpace = currentAttrs.frame.origin.x;


    }
    
    


    
    
    
    
    // 修改原有的偏移量
//    proposedContentOffset.x += minSpace;
//    proposedContentOffset.x = 0;
    
    proposedContentOffset.x = minSpace - 40;
    
//    WSLog(@"%g****%g",minSpace,proposedContentOffset.x);

    
    return proposedContentOffset;
    
}





@end
