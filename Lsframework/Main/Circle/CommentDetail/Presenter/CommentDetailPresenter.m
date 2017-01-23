//
//  CommentDetailPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CommentDetailPresenter.h"

@interface CommentDetailPresenter (){
    NSInteger pageIndex;
}

@end


@implementation CommentDetailPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        pageIndex = 1;
    }
    return self;
}

-(void)getPostReplyListByCommentID:(NSInteger)commentID{
    pageIndex = 1;
    if(self.dataSource){
        [self.dataSource removeAllObjects];
        self.dataSource = nil;
    }
    
    NSDictionary* parames = @{@"PageIndex":@(pageIndex),@"PageSize":@(kPageSize),@"CommentID":@(commentID)};

    NSString* actionName = API_GET_REPLY_COMMENTV1;
    if(self.isPatinetCase){
        actionName = API_Get_PatientCommentReplyV1;
    }
    
    WS(ws);
    [[FPNetwork POST: actionName withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            ws.totalCount = response.totalCount;
            ws.dataSource = [ConsulationReplyList mj_objectArrayWithKeyValuesArray:response.data];
            [ConsulationReplyList formatChildImageWithArray:ws.dataSource];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(replyCommentComplete:info:)]){
            [ws.delegate replyCommentComplete:response.success info:response.message];
        }
        
    }];

}

-(void)getMorePostReplyListCommentID:(NSInteger)commentID{
    pageIndex ++;
    
    NSDictionary* parames = @{@"PageIndex":@(pageIndex),@"PageSize":@(kPageSize),@"CommentID":@(commentID)};

    NSString* actionName = API_GET_REPLY_COMMENTV1;
    if(self.isPatinetCase){
        actionName = API_Get_PatientCommentReplyV1;
    }

    
    WS(ws);
    [[FPNetwork POST: actionName withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            NSMutableArray* array = [ConsulationReplyList mj_objectArrayWithKeyValuesArray:response.data];
            if(array.count != 0 ){
                
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.dataSource];
                [result addObjectsFromArray:array];
                //                [ws.dataSource removeAllObjects];
                //                ws.dataSource = nil;
                ws.dataSource = result;
                [ConsulationReplyList formatChildImageWithArray:ws.dataSource];

                
            }else{
                ws.noMoreData = YES;
            }
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(moreReplyCommentComplete:info:)]){
            [ws.delegate moreReplyCommentComplete:response.success info:response.message];
        }
        
    }];

}

-(void)commitPostReplyWithConsultationID:(NSInteger)commentID CommentContent:(NSString *)commentContent{
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"CommentID":@(commentID), @"CommentContent":commentContent};
    
    NSString* actionName = API_ADD_REPLY_COMMENT;
    if(self.isPatinetCase){
        actionName = API_InsertPatientCommentReply;
        parames = @{@"UserID":@(kCurrentUser.userId),@"CommentID":@(commentID), @"CommentContent":commentContent, @"IsDelete":@""};
    }

    
    WS(ws);
    [[FPNetwork POST:actionName withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //刷新评论列表
                [ws getPostReplyListByCommentID:commentID];
            });
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetCircleQuestionInfoSingleCompletion:info:)]){
                [ws.delegate GetCircleQuestionInfoSingleCompletion:response.success info:response.message];
            }

            [kdefaultCenter postNotificationName:@"refreshPopViewnew" object:nil userInfo:nil];
            
        }else{
            [ProgressUtil showError:response.message];
        }
    }];

    
    
}

-(void)GetCircleQuestionInfoSingleWithcommentID:(NSNumber*_Nullable)commentID{

    
    NSDictionary *parames = @{@"userID":@(kCurrentUser.userId),@"commentID":commentID};
    
    NSString* actionName = API_GetCoulationCommentSingleV1;
    if(self.isPatinetCase){
        actionName = @"GetOneAdmissionCommentV1";
    }

    WS(ws);
    [[FPNetwork POST:actionName withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            ws.CircleInfoSingleDataSource = [ConsultationCommenList mj_objectArrayWithKeyValuesArray:response.data];
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetCircleQuestionInfoSingleCompletion:info:)]){
            [ws.delegate GetCircleQuestionInfoSingleCompletion:response.success info:response.message];
        }
        
    }];


}
-(void)deleteInvitationWithID:(NSInteger)InvitationID
{
    NSDictionary *parames = @{@"CID":@(InvitationID)};
    
    NSString* actionName = API_DeleteReplyCommentByID;

    if (self.isPatinetCase == YES) {
        parames = @{@"uuid":@(InvitationID)};
        actionName = API_DeletePatientCommentReplay;
        
    }
   
    [[FPNetwork POST:actionName withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            
            NSLog(@"%@",response.data);
        }
    }];
    
}
-(void)deleteAallInvitationWithCommentId:(NSNumber *)CommentId
{
    NSDictionary *parames = @{@"CommentID":CommentId,@"userID":@(kCurrentUser.userId)};
    
    NSString* actionName = API_DeleteConsultationComment;
    
    if (self.isPatinetCase == YES) {
        parames = @{@"CommentID":CommentId};
        actionName = API_DeleteAdmissionComment;
    }
    
    
    [[FPNetwork POST:actionName withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            
            NSLog(@"delete is-- %@",response.data);
        }
    }];
    
}

@end
