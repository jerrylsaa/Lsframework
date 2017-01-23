//
//  ChatListPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "Conversation.h"

typedef void(^LoadHandler)(BOOL success, NSString *message);

typedef void(^IsReadBlock) (BOOL success);

@protocol ChatListPresenterDelegate <NSObject>

-(void)GetChatListCompletion:(BOOL)success info:(NSString *)message;

@end

@interface ChatListPresenter : BasePresenter

@property (nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic,weak) id<ChatListPresenterDelegate> deleagte;

-(void)isReadNoticeWithUuid:(NSNumber *)uuid sysBlock:(IsReadBlock)block;

-(void)GetChatList;

- (void)loadChatList:(LoadHandler)block;

- (void)cancelCell:(NSInteger)dialogID complete:(LoadHandler)block;



@end
