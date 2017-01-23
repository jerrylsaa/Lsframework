//
//  ChatViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "Conversation.h"

typedef NS_ENUM(NSInteger, ChatType) {
    ChatTypeSingal,
    ChatTypeConversation,
    ChatTypePush,
};

@interface ChatViewController : BaseViewController

@property (nonatomic, assign) ChatType chatType;

//从头像进入
@property (nonatomic, assign) NSInteger ReceiveUserID;
@property (nonatomic, copy) NSString *nickName;
//从会话列表进入
@property (nonatomic, strong) Conversation *conversation;
@property (nonatomic, strong) NSNumber *RowID;

@property (nonatomic, assign) NSInteger SendUserID;



@end
