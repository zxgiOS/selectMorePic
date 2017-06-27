//
//  ImagesCollectionViewController.m
//  moreSelectPhoto
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ImagesCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "imagesCollectionViewCell.h"
#import "ViewController.h"
#import "ShowPhotoViewController.h"

@interface ImagesCollectionViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,strong) NSMutableArray *selectImages;

@property (nonatomic,strong) NSMutableArray *onceSelectArray;

@end

@implementation ImagesCollectionViewController

static NSString * const reuseIdentifier = @"imageCell";

- (instancetype)init
{
    // 1.创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 2.设置每个格子的尺寸
    layout.itemSize = CGSizeMake(70, 70);
    // 3.设置整个collectionView的内边距
    CGFloat paddingY = 20;
    CGFloat paddingX = 20;
    layout.sectionInset = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
    // 4.设置每一行之间的间距
    layout.minimumLineSpacing = paddingY;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(sendArray:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
     
    self.imageCount = 0;
    return [super initWithCollectionViewLayout:layout];
}


- (ALAssetsLibrary *)assetsLibrary{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[imagesCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    [self loadDatas];
    
}

- (NSMutableArray *)loadDatas{
    _dataArray = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    _selectImages = [NSMutableArray array];
    _onceSelectArray = [NSMutableArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if(group){
                    [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                        if (asset == nil) return ;
                        if (![[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {//不是图片
                            return;
                        }else{
                            [_dataArray addObject:asset];
                        }
                        [self.collectionView reloadData];
                    }];
                }
            } failureBlock:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"访问相册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }];
        });
    return _dataArray;
}





#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    imagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell.backgroundView == nil) {//防止多次创建
        UIImageView *imageView = [[UIImageView alloc] init];
        cell.backgroundView = imageView;
    }
    UIImageView *backView = (UIImageView *)cell.backgroundView;
    UIImage *Simg = [UIImage imageWithCGImage:[_dataArray[indexPath.item] thumbnail]];
    backView.image = Simg;
    UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 6, 20, 20)];
    selectImage.tag = 1001;
    
    [cell.backgroundView addSubview:selectImage];
    selectImage.image = [UIImage imageNamed:@"框"];
    cell.isSelect = NO;
    [_doneSelectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *asset = (ALAsset *)_dataArray[indexPath.item];
        NSURL *url = [[asset defaultRepresentation] url];
        NSString *str = [url absoluteString];
        if ([obj isEqualToString:str]) {
            [cell.backgroundView addSubview:selectImage];
            selectImage.image = [UIImage imageNamed:@"勾"];
            cell.isSelect = YES;
            [_selectArray addObject:_dataArray[indexPath.item]];
        }
    }];
    
    _imageCount = _selectArray.count;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    imagesCollectionViewCell *cell = (imagesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_imageCount >= 6 && cell.isSelect == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"一次最多选中6张图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        if (cell.isSelect == NO) {
            self.imageCount += 1;
            cell.isSelect = YES;
            UIImageView *imageView = [cell viewWithTag:1001];
            imageView.image = [UIImage imageNamed:@"勾"];
            [self.selectArray addObject:_dataArray[indexPath.item]];
        }else{
            self.imageCount -= 1;
            cell.isSelect = NO;
            UIImageView *imageView = [cell viewWithTag:1001];
            imageView.image = [UIImage imageNamed:@"框"];
            [_selectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (obj == _dataArray[indexPath.item]) {
                    [_selectArray removeObject:obj];
                }
            }];
        }

    }
}




- (void)sendArray:(UIButton *)sender{
    
    
    [_selectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *asset = (ALAsset *)obj;
        
        CGImageRef ref = [[asset defaultRepresentation] fullScreenImage];
        
        UIImage *img = [[UIImage alloc]initWithCGImage:ref];
        [_selectImages addObject:img];
        NSURL *url = [[asset defaultRepresentation] url];
        NSString *str = [url absoluteString];
        [_onceSelectArray addObject:str];
    }];
    NSInteger index =  self.navigationController.viewControllers.count - 2;
    
    ShowPhotoViewController *vc = [self.navigationController.viewControllers objectAtIndex:index];
    vc.selectArray = _selectImages;
    vc.doneSelectArray = _onceSelectArray;
    [self.navigationController popToViewController:vc animated:YES];
    
}















@end
