//
//  PraiseTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PraiseList.h"
@interface PraiseTableViewCell : UITableViewCell{
    UIView  *containerView;



}

/**
 *   "RowID": 1,
 "uuid": 1,
 "ArticleID": 1,
 "CommentID": 0,
 "UserID": 1,
 "CommentContent": "1",
 "CreateTime": 1473005573,
 "IsDelete": false

 */
@property(nonatomic,strong)UIImageView  *HeadImageView;
@property(nonatomic,strong)UILabel  *HeadName;
@property(nonatomic,strong)UILabel  *FloorLb;
@property(nonatomic,strong)UILabel  *CommentContent;
@property(nonatomic,strong)UIImageView  *TimeImageView;
@property(nonatomic,strong)UILabel  *TimeLb;
@property(nonatomic,strong) UIButton * AnswerBtn;

@property(nonatomic,strong)UIImageView  *AnswerImageView;

@property(nonatomic,strong)UILabel   *AnswerName;

@property(nonatomic,strong)UILabel   *AnswerfloorLb;

@property(nonatomic,strong)UILabel   *AnswerComment;

@property(nonatomic,retain) PraiseList * praiseList;

@property(nonatomic,strong)UILabel   *lineLb;



@end
