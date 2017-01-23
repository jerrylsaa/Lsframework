//
//  ChatCell.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatEntity.h"
#import "ChatBaseCell.h"

@interface ChatCell : ChatBaseCell

@property (nonatomic, strong) ChatEntity *chat;
@property (nonatomic, assign) TalkType talkType;
@property (nonatomic, assign) DisplayType displayType;
@property (nonatomic, assign) BOOL isTime;
@property (nonatomic, weak) id<CellImageDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImage *image;
@end
