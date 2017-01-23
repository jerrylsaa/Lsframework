//
//  CircleCommentCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsultationCommenList.h"
#import "CircleTableViewCell.h"
#import "RegexKitLite.h"
#import "TextSegment.h"

#import "ConsulationReplyList.h"

@interface CircleCommentCell : UITableViewCell

@property(nullable,nonatomic,weak) id<CircleTableViewCellDelegate> delegate;

@property(nullable,nonatomic,retain) ConsultationCommenList* commentEntity;

@property(nullable,nonatomic,strong) UILabel* commentLabel;

@property(nonatomic,strong)NSMutableArray *ReplySource;

@property(nonatomic,strong)ConsulationReplyList *ConsulationReplyList;


@end
