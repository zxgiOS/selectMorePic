//
//  ViewController.m
//  moreSelectPhoto
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ShowPhotoViewController.h"
#import "ImagesCollectionViewController.h"
#import "PHKitCollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (IBAction)openPhoto:(UIButton *)sender {
    UIViewController *vc = [[NSClassFromString(@"ShowPhotoViewController") alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (IBAction)selMore:(UIButton *)sender {
    ImagesCollectionViewController *iamgesVC = [[ImagesCollectionViewController alloc] init];    [self.navigationController pushViewController:iamgesVC animated:YES];
    
}
- (IBAction)openPHkit:(UIButton *)sender {
    PHKitCollectionViewController *phkitVC = [self.storyboard instantiateViewControllerWithIdentifier:@"phkit"];
    [self.navigationController pushViewController:phkitVC animated:YES];
}

@end
