//
//  WalletListFlowLayout.m
//  SECwallet
//
//  Created by 通证控股 on 2019/1/18.
//  Copyright © 2019 通证控股. All rights reserved.
//

#import "WalletListFlowLayout.h"

@implementation WalletListFlowLayout

-(void)prepareLayout{
    [super prepareLayout];
    //每个section的inset，用来设定最左和最右item距离边界的距离，此处设置在中间
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) /2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(void)updateData
{
    NSLog(@"%ld",[[AppDefaultUtil sharedInstance].defaultWalletIndex integerValue]);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[AppDefaultUtil sharedInstance].defaultWalletIndex integerValue] inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

//设置滑动停止时的collectionView的位置
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;//最终要停下来的X
    rect.size = self.collectionView.frame.size;
    
    //获得计算好的属性
    NSArray * original = [super layoutAttributesForElementsInRect:rect];
    NSArray * attsArray = [[NSArray alloc] initWithArray:original copyItems:YES];
    //计算collection中心点X
    //视图中心点相对于collectionView的content起始点的位置
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2;
    CGFloat minSpace = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in attsArray) {
        //找到距离视图中心点最近的cell，并将minSpace值置为两者之间的距离
        if (ABS(minSpace) > ABS(attrs.center.x - centerX)) {
            minSpace = attrs.center.x - centerX;        //各个不同的cell与显示中心点的距离
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x += minSpace;
    return proposedContentOffset;
}

@end
