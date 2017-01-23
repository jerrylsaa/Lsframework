//
//  CommentDetailHeaderCell.h
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


@interface CommentDetailHeaderCell : UITableViewCell

@property(nullable,nonatomic,weak) id<CircleTableViewCellDelegate> delegate;

@property(nullable,nonatomic,retain) ConsultationCommenList* commentEntity;


@end
