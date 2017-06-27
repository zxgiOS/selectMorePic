//
//  TestTableViewController.m
//  moreSelectPhoto
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TestTableViewController.h"
#import <Photos/Photos.h>
#import "PHKitCollectionViewController.h"

@interface TestTableViewController ()

@property (nonatomic,strong) PHFetchResult *smartAlbums;

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCell"];
    
    self.smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.smartAlbums.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        PHKitCollectionViewController *phkitVC = [self.storyboard instantiateViewControllerWithIdentifier:@"phkit"];
        phkitVC.collection = _smartAlbums[indexPath.row];
        phkitVC.a = [self loadArray];
        [self.navigationController pushViewController:phkitVC animated:YES];
    }
}

- (NSMutableArray *)loadArray{
    
     PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    NSMutableArray *mutArray = [NSMutableArray array];
        for (NSInteger i=0; i<smartAlbums.count; i++) {
    // 获取一个相册PHAssetCollection
    PHCollection *collection = smartAlbums[i];
    if ([collection isKindOfClass:[PHAssetCollection class]]) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        // 从一个相册中获取的PHFetchResult中包含的才是PHAsset
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        PHAsset *asset = nil;
        
        // 使用PHImageManager从PHAsset中请求图片
        PHImageManager *imageManager = [[PHImageManager alloc] init];
        for (int i=0; i<fetchResult.count; i++) {
            asset = fetchResult[i];
            [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                if (result) {
                    [mutArray addObject:result];
                }
            }];
        }
    } else {
        NSAssert1(NO, @"Fetch collection not PHCollection: %@", collection);
    }
        }

    
    return mutArray;
}



@end
