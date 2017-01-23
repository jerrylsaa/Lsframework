//
//  DailyArticleDetailTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PraiseList.h"

#import "CircleTableViewCell.h"

@interface DailyArticleDetailTableViewCell : UITableViewCell{
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

@property(nonatomic,strong)UILabel   *lineLb;


@property(nonatomic,retain) PraiseList * praiseList;

@property(nullable,nonatomic,weak) id<CircleTableViewCellDelegate> delegate;

@property(nonatomic,strong)UIButton *deleteBtn;

@property(nonatomic,strong)UIButton *smallDeleteBtn;

@end
