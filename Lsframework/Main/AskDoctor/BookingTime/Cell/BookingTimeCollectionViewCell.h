//
//  BookingTimeCollectionViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ ClickItemBlock)(UIButton* bt);

@interface BookingTimeCollectionViewCell : UICollectionViewCell

@property(nonatomic,retain) UIButton* timebt;

- (void)clickItemOnComplete:(ClickItemBlock) block;


@end
