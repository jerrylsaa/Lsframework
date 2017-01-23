//
//  ChatListPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChatListPresenter.h"

@implementation ChatListPresenter

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)GetChatList
{
    WS(ws);
    [[FPNetwork POST:API_GetMyDialogList withParams:@{@"SendUserID":@(kCurrentUser.userId)}]addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            ws.dataSource = [Conversation mj_objectArrayWithKeyValuesArray:response.data];
        }
        if (ws.deleagte && [ws.deleagte respondsToSelector:@selector(GetChatListCompletion:info:)]) {
            
            [ws.deleagte GetChatListCompletion:response.success info:response.message];
        }else
        {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
    
}

- (void)loadChatList:(LoadHandler)block{ //GET_DIALOG_INFO_LIST(带系统消息)  API_GetMyDialogList  API_GetTalkDetail
    WS(ws);
    [[FPNetwork POST:API_GetMyDialogList withParams:@{@"SendUserID":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            ws.dataSource = [Conversation mj_objectArrayWithKeyValuesArray:response.data];
        }
        block(response.success, response.message);
    }];
}

- (void)cancelCell:(NSInteger)dialogID complete:(LoadHandler)block{
    
    [[FPNetwork POST:DELETE_DIALOG_INFO withParams:@{@"UserID":@(kCurrentUser.userId),@"DialogID":@(dialogID)}] addCompleteHandler:^(FPResponse *response) {
        block(response.success, response.message);
    }];    
}
-(void)isReadNoticeWithUuid:(NSNumber *)uuid sysBlock:(IsReadBlock)block
{
    
    NSDictionary *params = @{@"UUID":uuid,@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    [[FPNetwork POST:API_setmessageread withParams:params]addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            
            BOOL success;
            if ([response.data integerValue] == 1) {
                NSLog(@"adfsa");
                success =YES;
            }else{
                
                success = NO;
            }
            
            block(success);
        }
        
    }];
    
}

@end
