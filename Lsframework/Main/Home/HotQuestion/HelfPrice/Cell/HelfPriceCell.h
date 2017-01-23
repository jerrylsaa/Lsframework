//
//  HelfPriceCell.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HelfDelegate <NSObject>

- (void)deleteImageAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HelfPriceCell : UICollectionViewCell

@property (nonatomic, weak) id<HelfDelegate> delegate;

@property(nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isDelete;



@end
