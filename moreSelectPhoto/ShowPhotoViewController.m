//
//  ShowPhotoViewController.m
//  moreSelectPhoto
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import "SDPhotoBrowser.h"
#import "ImagesCollectionViewController.h"

//cell Image
#define kImageCount 3//一行显示几个图片

#define kImageWidth [UIScreen mainScreen].bounds.size.width/3

#define kImageheight [UIScreen mainScreen].bounds.size.width/3

#define kImageEdge 2
#define boundary @"AaB03x"


@interface ShowPhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate>

@property (nonatomic,strong) NSMutableArray *imageDataArray;


@end

@implementation ShowPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:@"提交" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(sendDatas:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _imageDataArray = [NSMutableArray array];
    [self reloadView];
}



- (void)reloadView{
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    //添加选中的图片
    if (self.selectArray.count!=0) {
        [_selectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGFloat imageX = idx % kImageCount * (kImageWidth + kImageEdge);
            CGFloat imageY = idx / kImageCount * (kImageheight +kImageEdge) + 64;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, kImageWidth, kImageheight)];
            imageView.image = obj;
            imageView.userInteractionEnabled = YES;
            [self.view addSubview:imageView];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kImageWidth-26, 6, 20, 20)];
            [btn setImage:[UIImage imageNamed:@"删"] forState:UIControlStateNormal];
            btn.tag = idx;
            [btn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
            
            UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 32, kImageWidth, kImageheight-32)];
            control.tag = idx;
            [control addTarget:self action:@selector(showMessage:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:control];
            
        }];
    }
    //添加加号
    NSInteger i = self.selectArray.count;
    
    
    if (i >= 6) {
        
    }else{
        CGFloat imageX = i % kImageCount * (kImageWidth + kImageEdge);
        CGFloat imageY = i / kImageCount * (kImageheight + kImageEdge) + 64;
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(imageX, imageY, kImageWidth, kImageheight);
        [button setImage:[UIImage imageNamed:@"zl_iconfont-tianjia"] forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(photoSelectet)
         forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

- (void)deleteImage:(UIButton *)sender{
    [_selectArray removeObjectAtIndex:sender.tag];
    [_doneSelectArray removeObjectAtIndex:sender.tag];
    [self reloadView];
}

// 大图
- (void)showMessage:(UIControl *)sender{
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.delegate = self;
    browser.currentImageIndex = (int)sender.tag;
    browser.imageCount = _selectArray.count;
    browser.sourceImagesContainerView = sender.superview.superview;
    [browser show];
    
}

#pragma mark - SDPhotoBrowser delegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    UIImageView *button = [browser.sourceImagesContainerView.subviews objectAtIndex:index];
    return button.image;
}

#pragma mark - 选择图片
- (void)photoSelectet{
    
    
    ImagesCollectionViewController *iamgesVC = [[ImagesCollectionViewController alloc] init];
    iamgesVC.doneSelectArray = _doneSelectArray;
    [self.navigationController pushViewController:iamgesVC animated:YES];
    
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        [self performSelector:@selector(showCream)];
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [self performSelector:@selector(showPhoto)];
//    }]];
//    [self presentViewController:alertController animated:YES completion:^{
//    }];
}

- (void)showCream{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showPhoto{
    UIImagePickerController *imPiC = [[UIImagePickerController alloc] init];
    imPiC.delegate = self;
    imPiC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imPiC animated:YES completion:^{
    }];
}
#pragma mark - imagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //    选择图片后，取出选择的图片
    UIImage *selectedImage = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [self.selectArray addObject:selectedImage];
    
    [self reloadView];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)sendDatas:(UIButton *)sender{
    [_selectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSData *imageData;
        if (UIImagePNGRepresentation(obj) == nil){
            imageData = UIImageJPEGRepresentation(obj, 1.0);
        }
        else{
            imageData = UIImagePNGRepresentation(obj);
        }
        [_imageDataArray addObject:imageData];

    }];
    
}









@end
