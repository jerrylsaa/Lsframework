//
//  DiscoverHealthLogTableViewCell.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverHealthLogEntity.h"

@interface DiscoverHealthLogTableViewCell : UITableViewCell
@property (nonatomic,strong) DiscoverHealthLogEntity *logEntity;
@property (nonatomic,assign) BOOL isEdited;
@end
