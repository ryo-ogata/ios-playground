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
    // セルの横幅
    CGFloat _cellWidth;
    // セルの縦幅
    CGFloat _cellHeight;
    // 左右のビューをはみださせる距離
    CGFloat _offsetHorizontal;
    // コレクションビューの横幅
    CGFloat _pageWidth;
    // コレクションビューの縦幅
    CGFloat _pageHeight;
    // レイアウト情報
    // rectInfos[section][row]の2次元配列
    NSArray *_rectInfos;
    // コレクションビューのコンテンツサイズ
    // すべてのアイテムが収まりきるサイズを指定する。
    CGSize _contentSize;
}
@end

@implementation CustomCollectionViewFlowLayout

/*
 描画するレイアウト情報を事前に作る
 */
-(void) prepareLayout {
    // 実際に表示するセルのクラスからサイズを取得する
    // 今回はすべて同じサイズのセルをつかう
    _cellWidth = [CustomCollectionViewCell cellWidth];
    _cellHeight = [CustomCollectionViewCell cellHeight];
    _pageWidth = CGRectGetWidth(self.collectionView.bounds);
    _pageHeight = CGRectGetHeight(self.collectionView.bounds);
    // collectionViewの横幅と_itemWidthの差分の半分が左(右)マージン
    _offsetHorizontal = (_pageWidth - _cellWidth) * 0.5;
    // セルの位置情報を作る
    CGFloat currentPosition = _offsetHorizontal;
    NSMutableArray *sectionRects = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int section = 0; section < sectionCount; section++) {
        NSMutableArray *rowRects = [NSMutableArray array];
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:section]; i++) {
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
            attr.center = CGPointMake(currentPosition + _cellWidth * 0.5, _cellHeight * 0.5);
            attr.size = CGSizeMake(_cellWidth, _cellHeight);
            [rowRects addObject:attr];
            currentPosition += _cellWidth + self.minimumLineSpacing + self.minimumInteritemSpacing;
        }
        [sectionRects addObject:rowRects];
    }
    // 最後に右マージンを追加する
    currentPosition += _offsetHorizontal;
    _contentSize = CGSizeMake(currentPosition, _pageHeight);
    _rectInfos = sectionRects;
    // 親クラスの持つプロパティをセットする
    self.minimumInteritemSpacing = 0.f;
    self.minimumLineSpacing = 0.f;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(_cellWidth, _cellHeight);
    self.sectionInset = UIEdgeInsetsMake(0, _offsetHorizontal, 0, _offsetHorizontal);
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

/*
 _rectInfosの各レイアウト情報のうち引数rectとヒットするものを配列で取得する
 */
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArray = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int section = 0; section < sectionCount; section++) {
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:section]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            // 2つのrectが重なっているかどうか
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
                                 withScrollingVelocity:(CGPoint)velocity {
    // 調整後スクロール位置
    CGFloat offsetAdjustment = MAXFLOAT;
    // 現在のスクロール位置（端の部分を加算する）
    CGFloat targetX = proposedContentOffset.x + self.minimumInteritemSpacing + _offsetHorizontal;
    // 画面に表示している矩形を取得する（現在のスクロール位置X座標を基点としたcollectionViewのサイズ）
    CGFloat proposedContentOffsetX = proposedContentOffset.x;
    // 加速度が一定以上ある場合にはその方向へずらす
    if (fabs(velocity.x) > [self flickVelocity]) {
        proposedContentOffsetX += MAX(0, MIN(_contentSize.width, _pageWidth * velocity.x));
    }
    CGRect targetRect = CGRectMake(proposedContentOffsetX, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    // オーバーライドしたメソッドを利用するためselfでの呼び出し
    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];
    for(UICollectionViewLayoutAttributes *layoutAttributes in array) {
        if(layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            // 表示されている矩形の中にあるセルのうち最も距離の近いものにあわせてoffsetAdjustmentを調整する
            CGFloat itemX = layoutAttributes.frame.origin.x;
            if (ABS(itemX - targetX) < ABS(offsetAdjustment)) {
                offsetAdjustment = itemX - targetX;
            }
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

/*
 加速度補正を行うかどうかの閾値
 */
- (CGFloat)flickVelocity {
    return 0.5;
}

@end
