//
//  PhotoWallTableViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleEntity.h"
#import "CircleTableViewCell.h"
#import "RegexKitLite.h"
#import "TextSegment.h"


@interface PhotoWallTableViewCell : UITableViewCell

@property(nullable,nonatomic,weak) id<CircleTableViewCellDelegate> delegate;

@property(nullable,nonatomic,retain) CircleEntity* circleEntity;



@end
