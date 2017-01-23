//
//  HotDetailInfoPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HotDetailInfoPresenter.h"

@implementation HotDetailInfoPresenter{
    NSInteger _page;
    NSInteger  _ConsultationID;
    
}
- (instancetype)init{
    if (self = [super init]) {
        _page = 1;

    }
    return self;
}


-(void)GetConsulationReplyByCommentID:(NSUInteger)CommentID {
    if(self.DataSource){
        self.DataSource = nil;
    }
    _page = 1;
    _ConsultationID = CommentID;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"CommentID":@(CommentID)};
    
    
    WS(ws);
    
    [[FPNetwork POST: API_GET_REPLY_COMMENTV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            ws.totalCount = response.totalCount;
            if (response.data!=nil) {
                ws.DataSource = [ConsulationReplyList mj_objectArrayWithKeyValuesArray:response.data];
                
                
            }
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(getConsulationReplyCompletion:info:)]){
                [ws.delegate getConsulationReplyCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
    
}


-(void)getMoreConsultationReplyList{
    _page++;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"CommentID":@(_ConsultationID)};
    WS(ws);
    
    [[FPNetwork POST:API_GET_REPLY_COMMENTV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSMutableArray* array = [ConsulationReplyList mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.DataSource];
                [result addObjectsFromArray:array];
                ws.DataSource = result;
            }else{
                ws.noMoreData = YES;
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetMoreConsultationReplyCompletion:info:)]){
            [ws.delegate GetMoreConsultationReplyCompletion:response.success info:response.message];
        }
        
    }];
}
- (void)InsertConsultationByCommentID:(NSInteger)CommentID  CommentContent:(NSString*) CommentContent{
    
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"CommentID":@(CommentID), @"CommentContent":CommentContent};
    WS(ws);
    [[FPNetwork POST:API_ADD_REPLY_COMMENT withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(InsertConsulationOnCompletion:info:)]){
                [ws.delegate InsertConsulationOnCompletion:response.success info:response.message];
            }
            
            
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
}
-(void)GetHotQuestionInfoSingleWithcommentID:(NSNumber*_Nullable)commentID{
    
    NSDictionary *parames = @{@"userID":@(kCurrentUser.userId),@"commentID":commentID};
    WS(ws);
    [[FPNetwork POST:API_GetCoulationCommentSingleV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            ws.HotInfoSingleDataSource = [ConsultationCommenList mj_objectArrayWithKeyValuesArray:response.data];
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetHotQuestionInfoSingleCompletion:info:)]){
            [ws.delegate GetHotQuestionInfoSingleCompletion:response.success info:response.message];
        }
        
    }];
}
-(void)deleteAallInvitationWithCommentId:(NSNumber *)CommentId
{
    NSDictionary *parames = @{@"CommentID":CommentId,@"userID":@(kCurrentUser.userId)};
    
    NSString* actionName = API_DeleteConsultationComment;
    
    [[FPNetwork POST:actionName withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            
            NSLog(@"%@",response.data);
        }
    }];
    
}
-(void)deleteInvitationWithID:(NSInteger)InvitationID
{
    NSDictionary *parames = @{@"CID":@(InvitationID)};
    
    NSString* actionName = API_DeleteReplyCommentByID;
    
    
    
    [[FPNetwork POST:actionName withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            
            NSLog(@"%@",response.data);
        }
    }];
    
}

@end
