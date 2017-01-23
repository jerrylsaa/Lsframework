//
//  RankingCell.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayRecommend.h"

@interface RankingCell : UITableViewCell

/** 点赞label*/
@property(nonatomic,strong)UILabel*praiseLabel;
/** 评论label*/
@property(nonatomic,strong)UILabel*commentLabel;
/** 点赞btn*/
@property(nonatomic,strong)UIButton*praiseBtn;
/** 今日模型*/
@property(nonatomic,strong)TodayRecommend*todayRecommend;

@end
