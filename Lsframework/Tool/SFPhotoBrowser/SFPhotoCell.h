//
//  SFPhotoCell.h
//
//
//  Created by laoshifu on 15/11/24.
//  Copyright (c) 2015年 laoshifu All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPhoto.h"
#import "SFPhotoScrollView.h"

@interface SFPhotoCell : UICollectionViewCell

@property (nonatomic,strong)SFPhotoScrollView *photoView;

@property(nonatomic,strong)SFPhoto *photo;
@end
