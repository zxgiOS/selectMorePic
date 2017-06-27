//
//  ImagesCollectionViewController.h
//  moreSelectPhoto
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesCollectionViewController : UICollectionViewController

@property (nonatomic) int imageCount;

@property (nonatomic,strong) NSMutableArray *doneSelectArray;


@end
