//
//  DailyArticleDetailPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DailyArticleDetailPresenter.h"

@implementation DailyArticleDetailPresenter {
    NSInteger _page;
    NSNumber* _CommentID;
    
    
}
-(instancetype)init{
    self= [super init];
    if(self){
        _page = 1;
        
    }
    return self;
}



-(void)getReplyListWithCommentID:(NSNumber*)CommentID{
    if(self.dataSource){
        self.dataSource = nil;
    }
    _page = 1;
    _CommentID = CommentID;
    
NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"CommentID":CommentID,@"UserID":@(kCurrentUser.userId)};
    
    
    WS(ws);
    
    [[FPNetwork POST: API_GET_ARTICLECOMMENTREPLYLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            if (response.data!=nil) {
                ws.dataSource = [PraiseList mj_objectArrayWithKeyValuesArray:response.data];
                
                ws.totalCount = response.totalCount;
            }
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetReplyListCompletion:info:)]){
                [ws.delegate GetReplyListCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
    
}


-(void)getMoreReplyList{
    _page++;
    
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"CommentID":_CommentID,@"UserID":@(kCurrentUser.userId)};
    WS(ws);
    
    [[FPNetwork POST:API_GET_ARTICLECOMMENTREPLYLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSMutableArray* array = [PraiseList mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.dataSource];
                [result addObjectsFromArray:array];
                ws.dataSource = nil;
                ws.dataSource = result;
            }else{
                ws.noMoreData = YES;
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetMoreReplyListCompletion:info:)]){
            [ws.delegate GetMoreReplyListCompletion:response.success info:response.message];
        }
        
    }];
}

-(void)insertArticleCommentWithArticleID:(NSNumber*)ArticleID CommentID:(NSNumber*)commentID UserID:(NSNumber*)userid CommentContent:(NSString*)CommentContent{
    
    WS(ws);
    NSDictionary* parames = @{@"ArticleID":ArticleID,@"CommentID":commentID,@"UserID":userid,@"CommentContent":CommentContent};
    
    [[FPNetwork POST: API_INSERT_ARTICLECOMMENT withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(insertArticleCommentCompletion:info:)]){
                [ws.delegate insertArticleCommentCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
}
#pragma mark--删除1-
-(void)deleteAallInvitationWithCommentId:(NSNumber *)CommentId
{
    
    
    NSDictionary *parames = @{@"CommentID":CommentId,@"UserID":@(kCurrentUser.userId)};
    
    NSString* actionName = API_DeleteArticleComment;
    
    
    [[FPNetwork POST:actionName withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            
            NSLog(@"delete is-- %@",response.data);
        }
    }];
    
}
@end
