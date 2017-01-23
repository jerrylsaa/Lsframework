//
//  SFPhotoBrowser.h
//
//
//  Created by laoshifu on 15/9/15.
//  Copyright (c) 2015年 laoshifu All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPhoto.h"
#import "SFPhotoScrollView.h"
#import "SFPhotoCell.h"

@protocol PhotoBrowerDelegate <NSObject>

//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(SFPhotoBrowser *)photoBrowser;

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (SFPhoto *)photoBrowser:(SFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

@end

@interface SFPhotoBrowser : UIView <UIScrollViewDelegate,PhotoViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (nonatomic,assign)id<PhotoBrowerDelegate> delegate;
//显示
+ (void)showImageInView:(UIView *)view selectImageIndex:(NSInteger)index delegate:(id<PhotoBrowerDelegate>)delegate;
@end