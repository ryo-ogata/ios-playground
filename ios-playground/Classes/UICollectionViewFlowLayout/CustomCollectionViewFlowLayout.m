//
//  CustomCollectionViewFlowLayout.m
//  ios-playground
//
//  Created by ogata on 2015/08/27.
//  Copyright (c) 2015年 oganity. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"
#import "CustomCollectionViewCell.h"

@interface CustomCollectionViewFlowLayout() {
    CGFloat _itemWidth;
    CGFloat _itemHeight;
    CGFloat _pageWidth;
    CGFloat _pageHeight;
    CGFloat _offsetHorizontal;
    NSArray *_rectInfos; //rectInfos[section][row]の2次元配列
    CGSize _contentSize;
}
@end

@implementation CustomCollectionViewFlowLayout

-(void) prepareLayout {
    self.minimumInteritemSpacing = 0.f;
    self.minimumLineSpacing = 0.f;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 実際に表示するセルのクラスからサイズを取得する
    _itemWidth = [CustomCollectionViewCell cellWidth];
    _itemHeight = [CustomCollectionViewCell cellHeight];
    self.itemSize = CGSizeMake(_itemWidth, _itemHeight);
    _pageWidth = CGRectGetWidth(self.collectionView.bounds);
    _pageHeight = CGRectGetHeight(self.collectionView.bounds);
    // collectionViewの横幅と_itemWidthの差分の半分が左(右)マージン
    _offsetHorizontal = (_pageWidth - _itemWidth) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, _offsetHorizontal, 0, _offsetHorizontal);
    // セルの位置情報を定義
    CGFloat currentPosition = _offsetHorizontal;
    NSMutableArray *sectionRects = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int section = 0; section < sectionCount; section++) {
        NSMutableArray *rowRects = [NSMutableArray array];
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:section]; i++) {
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
            attr.center = CGPointMake(currentPosition + _itemWidth * 0.5, _itemHeight * 0.5);
            attr.size = CGSizeMake(_itemWidth, _itemHeight);
            [rowRects addObject:attr];
            currentPosition += _itemWidth + self.minimumLineSpacing + self.minimumInteritemSpacing;
        }
        [sectionRects addObject:rowRects];
    }
    // 最後に右マージンを追加
    currentPosition += _offsetHorizontal;
    _contentSize = CGSizeMake(currentPosition, _pageHeight);
    _rectInfos = sectionRects;
}


- (CGSize)collectionViewContentSize {
    return _contentSize;
}

- (void)invalidateLayout {
    [super invalidateLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArray = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int section = 0; section < sectionCount; section++) {
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:section]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [attributesArray addObject:attributes];
            }
        }
    }
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (UICollectionViewLayoutAttributes *) _rectInfos[indexPath.section][indexPath.row];
}

-(CGPoint) targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat targetX = proposedContentOffset.x + self.minimumInteritemSpacing + self.sectionInset.left;
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for(UICollectionViewLayoutAttributes *layoutAttributes in array) {
        
        if(layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            CGFloat itemX = layoutAttributes.frame.origin.x;
            
            if (ABS(itemX - targetX) < ABS(offsetAdjustment)) {
                offsetAdjustment = itemX - targetX;
            }
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}


@end
