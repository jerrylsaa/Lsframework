//
//  ChatSingalCell.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBaseCell.h"
#import "ChatEntity.h"

@interface ChatSingalCell : ChatBaseCell
@property (nonatomic, strong) ChatEntity *chat;
@property (nonatomic, assign) TalkType talkType;
@property (nonatomic, assign) DisplayType displayType;
@property (nonatomic, assign) BOOL isTime;
@property (nonatomic, weak) id<CellImageDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImage *image;
@end
