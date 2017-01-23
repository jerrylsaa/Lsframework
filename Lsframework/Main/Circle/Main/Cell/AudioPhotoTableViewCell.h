//
//  AudioPhotoTableViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleEntity.h"
#import "CircleTableViewCell.h"


@interface AudioPhotoTableViewCell : UITableViewCell

@property(nullable,nonatomic,weak) id<CircleTableViewCellDelegate> delegate;

@property(nullable,nonatomic,retain) CircleEntity* circleEntity;
@property(nonatomic)int voicebtIsSelect;//语音按钮是否选中,0,未选中，1，选中


@end
