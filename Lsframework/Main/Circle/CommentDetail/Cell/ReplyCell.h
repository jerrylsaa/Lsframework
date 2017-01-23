//
//  ReplyCell.h
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
#import "ApiMacro.h"
#import "ConsulationReplyList.h"



@interface ReplyCell : UITableViewCell

@property(nullable,nonatomic,weak) id<CircleTableViewCellDelegate> delegate;

@property(nullable,nonatomic,retain) ConsulationReplyList* replyList;

@property(nonatomic,strong)UIButton *deleteBtn;



@end

