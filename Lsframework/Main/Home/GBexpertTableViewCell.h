//
//  GBexpertTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertAnswerEntity.h"
@interface GBexpertTableViewCell : UITableViewCell
@property(nonatomic,retain) ExpertAnswerEntity* expertAnswer;

@property(nonatomic)BOOL showBottomLine ;

@end
