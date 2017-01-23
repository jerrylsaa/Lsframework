//
//  CommentHeaderCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CircleEntity.h"
#import "CircleTableViewCell.h"
#import "RegexKitLite.h"
#import "TextSegment.h"
#import "ApiMacro.h"


@interface CommentHeaderCell : UITableViewCell

@property(nullable,nonatomic,retain) CircleEntity* circleEntity;
@property (nullable,nonatomic, strong) NSNumber *selectNumber;


@end
