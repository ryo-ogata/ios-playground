//
//  CustomCollectionView.m
//  ios-playground
//
//  Created by ogata on 2015/08/27.
//  Copyright (c) 2015年 oganity. All rights reserved.
//

#import "CustomCollectionView.h"

@implementation CustomCollectionView

# pragma mark - View lifecycle methods

- (void)awakeFromNib {
    // Initialization code
    self.showsHorizontalScrollIndicator = NO;
    self.scrollEnabled = YES;
    self.pagingEnabled = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
//    self.backgroundColor = [UIColor clearColor];
//    self.backgroundView.backgroundColor = [UIColor clearColor];
}

@end
