//
//  FoodResultCell.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodSearchResultEntity.h"

@protocol FoodResultCellDelegate <NSObject>
@optional

- (void)selectBtn:(FoodSearchResultEntity *)foodEntity;

@end

@interface FoodResultCell : UITableViewCell

@property(nonatomic,weak) id<FoodResultCellDelegate> delegate;

@property(nonatomic,retain) FoodSearchResultEntity *foodEntity;
@end
