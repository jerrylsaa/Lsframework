//
//  RecommendCell.h
//  FamilyPlatForm
//
//  Created by Mac on 16/11/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayRecommend.h"

@interface RecommendCell : UITableViewCell

/** 点赞图片*/
@property(nonatomic,strong)UIButton*praiseButton;
/** 点赞label*/
@property(nonatomic,strong)UILabel*praiseLabel;

/** 今日模型*/
@property(nonatomic,strong)TodayRecommend*todayRecommend;



@end
