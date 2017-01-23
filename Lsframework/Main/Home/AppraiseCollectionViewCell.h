//
//  AppraiseCollectionViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthService.h"
@interface AppraiseCollectionViewCell : UICollectionViewCell
@property(nonatomic,assign) CGFloat AppraiseImageHeight;


@property(nullable,nonatomic,retain) HealthService *HealthService;


@end
