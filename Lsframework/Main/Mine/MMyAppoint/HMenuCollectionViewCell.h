//
//  HMenuCollectionViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/7/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMenuCollectionViewCell : UICollectionViewCell
@property(nonatomic,assign) CGFloat imageHeight;
- (void)initCellWith:(NSDictionary*) dic;

@end
