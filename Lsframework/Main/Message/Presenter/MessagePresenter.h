//
//  MessagePresenter.h
//  PublicHealth
//
//  Created by Tom on 16/3/25.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "BasePresenter.h"
#import "MessageEntity.h"

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeAll,
    MessageTypeUnRead,
};

@protocol MessagePresnterDelegate <NSObject>

- (void)onRefreshComplete:(BOOL)success;

- (void)onLoadMessageComplete:(BOOL)success hasMoreData:(BOOL)hasMoreData;

- (void)onChangeMessageStatusComplete:(BOOL)success withPosition:(NSUInteger)position;

@end

@interface MessagePresenter : BasePresenter

@property (nonatomic) MessageType type;

@property (nonatomic, weak) id<MessagePresnterDelegate> delegate;

@property (nonatomic, strong, readonly) NSMutableArray<MessageEntity*> * messages;


- (void)refreshMessageData;

- (void)loadMoreMessageData;

- (void)changeMessageStatus:(NSUInteger)position;

- (void)addMessage;

@end
