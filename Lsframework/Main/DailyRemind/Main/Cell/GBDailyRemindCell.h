//
//  GBDailyRemindCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyRemindEntity.h"

@interface GBDailyRemindCell : UITableViewCell

@property(nonatomic)BOOL isCurrentDailRemind;

@property(nullable,nonatomic,retain) DailyRemindEntity* dailyRemind;

@end
