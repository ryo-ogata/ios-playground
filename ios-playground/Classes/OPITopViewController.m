//
//  ViewController.m
//  ios-playground
//
//  Created by ogata on 2015/08/27.
//  Copyright (c) 2015年 oganity. All rights reserved.
//

#import "OPITopViewController.h"

typedef enum : NSUInteger {
    OPIMenuCollectionViewLayout,
    OPIMenuLimit,
} OPIMenuItem;

@interface OPITopViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OPITopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return OPIMenuLimit;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case OPIMenuCollectionViewLayout: {
            cell.textLabel.text = @"UICollectionViewFlowLayout";
        } break;
        default: {
            
        } break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case OPIMenuCollectionViewLayout: {
            vc = [sb instantiateViewControllerWithIdentifier:@"UICollectionViewFlowLayoutViewController"];
        } break;
        default: {
            
        } break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
