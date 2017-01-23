//
//  PhotoCollectionViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoCollectionViewCell;

@protocol PhotoCollectionViewCellDelegate <NSObject>

@optional
- (void)clickDeletePhoto:(PhotoCollectionViewCell* _Nonnull) photoCell;

@end

@interface PhotoCollectionViewCell : UICollectionViewCell

@property(nullable,nonatomic,retain) UIImageView* photoImageView;
@property(nullable,nonatomic,retain) UIButton* deleteButton;

@property(nullable,nonatomic,weak) id<PhotoCollectionViewCellDelegate> delegate;

@end
