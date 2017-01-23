//
//  ChatPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChatPresenter.h"

@interface ChatPresenter ()



@end

@implementation ChatPresenter

- (void)insertChatWithContent:(NSString *)text reciverID:(NSInteger)reciverID complete:(LoadHandler)block{
    
    [[FPNetwork POST:INSERT_DIALOG_DETAIL withParams:@{@"SendUserID":@(kCurrentUser.userId),@"ReceiveUserID":@(reciverID),@"Content":text}] addCompleteHandler:^(FPResponse *response) {
        block(response.success, response.message);
    }];
}
//获取单个私聊对话
- (void)GetDialogInfo:(NSInteger) receiveUserID complete:(LoadHandler)block{
    WS(ws);
    [[FPNetwork POST:GET_DIALOG_INFO withParams:@{@"SendUserID":@(kCurrentUser.userId),@"ReceiveUserID":@(receiveUserID)}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSDictionary *dic = [(NSArray *)response.data firstObject];
            ws.dialodID = [dic[@"ID"] integerValue];
            block(response.success,response.message);
        }
    }];
}

//获取私聊内容
- (void)GetDialogDetailList:(NSInteger) dialogID complete:(LoadHandler)block{
    WS(ws);// API_GetTalkDetail  GET_DIALOG_DETAIL_LIST
    [[FPNetwork POST:API_GetTalkDetail withParams:@{@"DialogID":@(dialogID),@"UserID":@(kCurrentUser.userId),@"PageIndex":@(_pageIndex),@"PageSize":@10}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            ws.dataSource = [ChatEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        block(response.success,response.message);
    }];
}
- (void)loadMoreDetailList:(NSInteger) dialogID{
    _pageIndex ++;
    WS(ws);
    [ws GetDialogDetailList:dialogID complete:^(BOOL success, NSString *message) {
        [ws.delegate loadComplete:success message:message];
    }];
}
- (void)refreshDetailList:(NSInteger) dialogID{
    _pageIndex = 1;
    WS(ws);
    [self GetDialogDetailList:dialogID complete:^(BOOL success, NSString *message) {
        [ws.delegate loadComplete:success message:message];
    }];
}
- (void)upload:(UIImage *)image complete:(LoadHandler)block{
    FormData * formData = [FormData new];
    formData.data = UIImagePNGRepresentation(image);
    formData.fileName = @"file.png";
    formData.name = @"file";
    formData.mimeType = @"image/png";
    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:@[formData]] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSDictionary *data=[response.data dictionary];
            response.message = [data[@"Result"] getUploadPath];
        }
        block(response.success,response.message);
    }];
}
- (void)cancelContent:(NSInteger) dialogID complete:(LoadHandler)block{
    [[FPNetwork POST:DELETE_DIALOG_DETAIL_BY_ID withParams:@{@"DetailID":@(dialogID),@"UserID":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == NO) {
            block(NO,nil);
        }else{
            BOOL suc = [response.data boolValue];
            if (suc == YES) {
                block(YES,nil);
            }else{
                block(NO,nil);
            }
        }
    }];
}


@end
