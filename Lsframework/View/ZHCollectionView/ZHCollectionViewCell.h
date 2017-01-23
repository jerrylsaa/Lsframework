//
//  ZHCollectionViewCell.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildEntity.h"
typedef NS_ENUM(NSUInteger, CellType) {
    CellTypeBaby,
    CellTypeAdd
};

@interface ZHCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *headImageView;

@property (nonatomic ,strong) UILabel *nameLabel;

@property (nonatomic ,strong) UIImageView *selectImageView;

@property (nonatomic ,assign) BOOL isAdd;

@property (nonatomic ,assign) CellType cellType;

@property (nonatomic ,strong) ChildEntity *entity;

@end
