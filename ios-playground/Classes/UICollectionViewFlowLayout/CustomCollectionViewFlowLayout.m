//
//  CustomCollectionViewFlowLayout.m
//  ios-playground
//
//  Created by ogata on 2015/08/27.
//  Copyright (c) 2015年 oganity. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"
#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewFlowLayout

-(void) prepareLayout {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = [CustomCollectionViewCell cellWidth];
    CGSize size = self.collectionView.frame.size;
    CGFloat collectionViewWidth = size.width;
    CGFloat collectionViewPadding = (collectionViewWidth - itemWidth) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, collectionViewPadding, 0, collectionViewPadding);
    self.minimumInteritemSpacing = 0.f;
    self.minimumLineSpacing = 0.f;
    self.itemSize = CGSizeMake(itemWidth, size.height);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    //NSLog(@"attributes.count=%ld, rect=%@", attributes.count, NSStringFromCGRect(rect));
    return attributes;
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
