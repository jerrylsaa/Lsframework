//
//  HotPhotoCollectionViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/10/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotPhotoCollectionViewCell;

@protocol HotPhotoCollectionViewCelldelegate <NSObject>
@optional
-(void)clickDeleteHotPhotos:(HotPhotoCollectionViewCell*_Nonnull)photocell;


@end

@interface HotPhotoCollectionViewCell : UICollectionViewCell

@property(nullable,nonatomic,retain) UIImageView* photoImageView;
@property(nullable,nonatomic,retain) UIButton* deleteButton;
@property(nullable,nonatomic,weak)id<HotPhotoCollectionViewCelldelegate>delegate;

@end
