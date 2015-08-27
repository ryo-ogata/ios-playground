//
//  UICollectionViewFlowLayoutViewController.m
//  ios-playground
//
//  Created by ogata on 2015/08/27.
//  Copyright (c) 2015年 oganity. All rights reserved.
//

#import "UICollectionViewFlowLayoutViewController.h"
#import "CustomCollectionView.h"
#import "CustomCollectionViewCell.h"

@interface UICollectionViewFlowLayoutViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    __weak IBOutlet CustomCollectionView *_customCollectionView;
    NSArray *_models;
    NSArray *_bgColors;
}

@end

@implementation UICollectionViewFlowLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _models = @[
                @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"
                ];
    _bgColors = @[
                  [UIColor blueColor],
                  [UIColor yellowColor],
                  [UIColor brownColor],
                  [UIColor purpleColor]
                  ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [_models objectAtIndex:indexPath.row];
    cell.backgroundColor = [_bgColors objectAtIndex:indexPath.row % _bgColors.count];
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
@end
