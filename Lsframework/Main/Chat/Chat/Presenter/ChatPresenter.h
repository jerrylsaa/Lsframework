//
//  ChatPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ChatEntity.h"

@protocol ChatPresenterDelegate <NSObject>

- (void)loadComplete:(BOOL)success message:(NSString *)message;

@end

typedef void(^LoadHandler)(BOOL success, NSString *message);

@interface ChatPresenter : BasePresenter

@property (nonatomic, weak) id<ChatPresenterDelegate> delegate;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger dialodID;
@property (nonatomic, assign) NSInteger pageIndex;

- (void)insertChatWithContent:(NSString *)text reciverID:(NSInteger)reciverID complete:(LoadHandler)block;

- (void)GetDialogInfo:(NSInteger) receiveUserID complete:(LoadHandler)block
;
- (void)loadMoreDetailList:(NSInteger) dialogID;

- (void)refreshDetailList:(NSInteger) dialogID;

//上传图片
- (void)upload:(UIImage *)image complete:(LoadHandler)block;

//删除聊天内容
- (void)cancelContent:(NSInteger) dialogID complete:(LoadHandler)block;

@end
