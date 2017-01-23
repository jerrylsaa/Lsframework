//
//  HExpertAnswerTableViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertAnswerEntity.h"

@interface HExpertAnswerTableViewCell : UITableViewCell


@property(nonatomic,retain) ExpertAnswerEntity* expertAnswer;
@property(nonatomic,strong) UIImageView* statusImageView;
@property(nonatomic,strong) UIImageView* moreStatusImageView;


@end
