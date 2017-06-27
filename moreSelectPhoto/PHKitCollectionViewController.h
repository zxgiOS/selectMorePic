//
//  PHKitCollectionViewController.h
//  moreSelectPhoto
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PHKitCollectionViewController : UICollectionViewController

@property (nonatomic,strong) PHCollection *collection;
@property (nonatomic,strong) NSMutableArray *a;

@end
