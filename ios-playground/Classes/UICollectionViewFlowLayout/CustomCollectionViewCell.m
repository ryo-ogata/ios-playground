//
//  CustomCollectionViewCell.m
//  ios-playground
//
//  Created by ogata on 2015/08/27.
//  Copyright (c) 2015年 oganity. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

+ (CGFloat)cellWidth {
    // Window横幅の80%
    CGFloat windowWidth = CGRectGetWidth([[UIApplication sharedApplication] keyWindow].bounds);
    return windowWidth * 0.8;
}

@end
