//
//  MessagePresenter.m
//  PublicHealth
//
//  Created by Tom on 16/3/25.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "MessagePresenter.h"

@interface MessagePresenter()

@property (nonatomic, assign) NSUInteger page;


@end

@implementation MessagePresenter

-(instancetype)init{
    self = [super init];
    if (self) {
        _messages = [NSMutableArray new];
    }
    return self;
}

#pragma mark 刷新消息

-(void)refreshMessageData{
    _page = 1;
    //网络请求
    NSDictionary * params = @{@"phone":@""};
    [[FPNetwork POST:API_PHONE_INDENTIFYING_CODE withParams:params] addCompleteHandler:^(id response) {
        NSLog(@"%@", response);
    }];
    [_messages removeAllObjects];
    MessageEntity * entity = [MessageEntity MR_createEntityInContext:nil];
    entity.title = @"Hello Message";
    [_messages addObject:entity];
    //
    if (_delegate && [_delegate respondsToSelector:@selector(onRefreshComplete:)]) {
        [_delegate onRefreshComplete:YES];
    }
}

#pragma mark 加载更多消息

- (void)loadMoreMessageData{
    _page ++;
    //网络请求
    MessageEntity * entity = [MessageEntity MR_createEntityInContext:nil];
    entity.title = @"Hello Message";
    [_messages addObject:entity];
    //
    if (_delegate && [_delegate respondsToSelector:@selector(onLoadMessageComplete:hasMoreData:)]) {
        [_delegate onLoadMessageComplete:YES hasMoreData:YES];
    }
}

#pragma mark 更新消息状态

-(void)changeMessageStatus:(NSUInteger)position{
    //网络请求
    if (_delegate && [_delegate respondsToSelector:@selector(onChangeMessageStatusComplete:withPosition:)]) {
        [_delegate onChangeMessageStatusComplete:YES withPosition:position];
    }
}

-(void)addMessage{
    MessageEntity * entity = [MessageEntity MR_createEntityInContext:nil];
    entity.title = @"Hello Message";
    [_messages addObject:entity];
}

@end
