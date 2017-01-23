//
//  DietAnalysisCell.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMMyDietAnalysisEntity.h"

@interface DietAnalysisCell : UITableViewCell
@property(nonatomic,strong) DMMyDietAnalysisEntity *dietAnalysis;
@property(nonatomic,retain) NSString *illMatched;
@end
