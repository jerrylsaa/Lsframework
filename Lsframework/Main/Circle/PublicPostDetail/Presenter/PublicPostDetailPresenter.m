//
//  PublicPostDetailPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PublicPostDetailPresenter.h"

@interface PublicPostDetailPresenter (){
    NSInteger pageIndex;
}

@end

@implementation PublicPostDetailPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        pageIndex = 1;
        self.taskManager = [[DataTaskManager alloc] init];
    }
    return self;
}


-(void)getPostCommentListByCommentID:(NSInteger)commentID{
    pageIndex = 1;
    if(self.dataSource){
        [self.dataSource removeAllObjects];
        self.dataSource = nil;
    }
    
    NSDictionary* parames = @{@"PageIndex":@(pageIndex),@"PageSize":@(kPageSize),@"ConsultationID":@(commentID),@"UserID":@(kCurrentUser.userId),@"ConsultationType":@(2)};//2代表帖子，1代表评论
    
    WS(ws);
    [[FPNetwork POST: API_GET_CONSULATIONCOMMENTLISTV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            
            NSLog(@"数量是-- %@",response.data);

            
            [ConsultationCommenList mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"ReplyCommentList": @"ConsulationReplyList"};
            }];
            
            ws.totalCount = response.totalCount;
            ws.dataSource = [ConsultationCommenList mj_objectArrayWithKeyValuesArray:response.data];
            
            //            [ws getReply:ws.dataSource];
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(postCommentComplete:info:)]){
            [ws.delegate postCommentComplete:response.success info:response.message];
        }
        
    }];
    
}

- (void)getMorePostCommentListCommentID:(NSUInteger)commentID{
    
    pageIndex ++;
    
    NSDictionary* parames = @{@"PageIndex":@(pageIndex),@"PageSize":@(kPageSize),@"ConsultationID":@(commentID),@"UserID":@(kCurrentUser.userId),@"ConsultationType":@(2)};//2代表帖子，1代表评论
    
    
    WS(ws);
    
    [[FPNetwork POST: API_GET_CONSULATIONCOMMENTLISTV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            [ConsultationCommenList mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"ReplyCommentList": @"ConsulationReplyList"};
            }];
            
            
            NSMutableArray* array = [ConsultationCommenList mj_objectArrayWithKeyValuesArray:response.data];
            if(array.count != 0 ){
                
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.dataSource];
                [result addObjectsFromArray:array];
                
                ws.dataSource = result;
                
                
//                [ws getReply:ws.dataSource];
                
                
                
            }else{
                ws.noMoreData = YES;
            }
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(morePostCommentComplete:info:)]){
            [ws.delegate morePostCommentComplete:response.success info:response.message];
        }
        
    }];
    
}

-(void)commitPostComment:(NSString *)uploadPath ConsultationID:(NSUInteger)commentID CommentContent:(NSString *)CommentContent{
    
    NSString* image1Path;
    NSString* image2Path;
    NSString* image3Path;
    
    if(uploadPath && uploadPath.length != 0){
        if(![uploadPath containsString:@"|"]){
            //只有一个图片
            image1Path = uploadPath;
            image2Path = @"";
            image3Path = @"";
        }else{
            //多张图
            NSArray* uploadArray = [uploadPath componentsSeparatedByString:@"|"];
            if(uploadArray.count == 2){
                image1Path = [uploadArray firstObject];
                image2Path = [uploadArray lastObject];
                image3Path = @"";
            }else if(uploadArray.count == 3){
                image1Path = [uploadArray firstObject];
                image2Path = [uploadArray objectAtIndex:1];
                image3Path = [uploadArray lastObject];
            }else{
                NSLog(@"count = %ld",uploadArray.count);
                
            }
        }
    }else{
        image1Path = @"";
        image2Path = @"";
        image3Path = @"";
    }
    
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"ConsultationID":@(commentID), @"CommentContent":CommentContent, @"ConsultationType":@(2),@"Image1":image1Path, @"Image2":image2Path, @"Image3":image3Path};
    
    
    WS(ws);
    [[FPNetwork POST:API_INSERT_CONSULTATIONCOMMENT withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //刷新评论列表
                [ws getPostCommentListByCommentID:commentID];
            });
            
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
    
}

-(void)uploadPostImage:(NSMutableArray *)imageDataSorce ConsultationID:(NSInteger)commentID CommentContent:(NSString *) commentContent{
    NSMutableArray* formDataArray=[NSMutableArray array];
    if (imageDataSorce.count != 0) {
    for (UIImage *image in imageDataSorce) {
        FormData* formData = [FormData new];
        formData.data = [image resetSizeOfImageData:image maxSize:200];
        formData.fileName=@"file.png";
        formData.name=@"file";
        formData.mimeType=@"image/png";
        
        [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:@[formData]] addCompleteHandler:^(FPResponse *response) {
            if (response.success) {
                NSDictionary *data = [response.data dictionary];
                NSMutableArray *uploadPathArr = [data[@"Result"] getSingleUploadPath];
                
                if (uploadPathArr[0]) {
                    [formDataArray addObject:uploadPathArr[0]];
                    if (formDataArray.count ==imageDataSorce.count) {
                        
                        [self loadArr:formDataArray ConsultationID:commentID consultation:commentContent];
                        }
                }
            }
            
        }];
      }
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ProgressUtil show];
            NSString *uploadPath = @"";
            [self commitPostComment:uploadPath ConsultationID:commentID CommentContent:commentContent];
        });
        NSLog(@"上传图片数量为零");
    }
    
    
}
- (void)loadArr:(NSMutableArray*)uploadArrPath ConsultationID:(NSUInteger)commentID consultation:(NSString*) consultation
{
    NSDictionary *parames;

    if (uploadArrPath.count != 0) {
        if (uploadArrPath.count == 1) {
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(2),@"ConsultationType",uploadArrPath[0],@"Image1", nil];
            
        }else if (uploadArrPath.count ==2){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(2),@"ConsultationType",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2", nil];
            
        }else if (uploadArrPath.count == 3){
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(2),@"ConsultationType",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3", nil];
        }else if (uploadArrPath.count == 4){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(2),@"ConsultationType",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4", nil];
            
        }else if (uploadArrPath.count == 5){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(2),@"ConsultationType",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4",uploadArrPath[4],@"Image5", nil];
            
        }else if (uploadArrPath.count == 6){
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(2),@"ConsultationType",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4",uploadArrPath[4],@"Image5",uploadArrPath[5],@"Image6", nil];
        }
        
        WS(ws);
        [[FPNetwork POST:API_INSERT_CONSULTATIONCOMMENT withParams:parames] addCompleteHandler:^(FPResponse *response) {
            if(response.success){
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    //刷新评论列表
                    [ws getPostCommentListByCommentID:commentID];
                });
                
            }else{
                [ProgressUtil showError:response.message];
            }
        }];
    }
    
    
}

#pragma mark - 获取评论里的回复
- (void)getReply:(NSMutableArray*) commentDataSource{
    NSMutableArray* array = [NSMutableArray array];
    NSMutableArray* replyDataSource = [NSMutableArray array];
    
    for(int i = 0; i < commentDataSource.count; i++){
        ConsultationCommenList* commentEntity = commentDataSource[i];
        
        NSDictionary* parames = @{@"PageIndex":@(pageIndex),@"PageSize":@(2),@"CommentID":@(commentEntity.uuid)};
        
        WS(ws);
        FPNetwork* repley = [[FPNetwork POST:API_GET_REPLY_COMMENTV1 withParams:parames] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
            [ws.taskManager countDown];
            
            if(response.success){
                NSMutableArray* commentDataSource = [ConsulationReplyList mj_objectArrayWithKeyValuesArray:response.data];
                [replyDataSource addObjectsFromArray:commentDataSource];
            }
            
        }];
        [array addObject:repley];
    }

    WS(ws);
    [self.taskManager requestWithDataTasks:array withComplete:^{
        NSLog(@"replydatasoure count is--- %ld",(unsigned long)replyDataSource.count);
        
        for(ConsultationCommenList* commentEntity in ws.dataSource){
            
            NSMutableArray* temp = [NSMutableArray array];
            
            for(ConsulationReplyList* replyEntity in replyDataSource){
                
                if(commentEntity.uuid == replyEntity.CommentID){
                    [temp addObject:replyEntity];
                }
            }
            commentEntity.ReplyCommentList = temp;
            
        }
        
        
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(postCommentComplete:info:)]){
            [ws.delegate postCommentComplete:YES info:@""];
        }
        
        
    }];
    
}

-(void)loadReply:(NSNumber *)uuid
{
        self.commentDataSource = [NSMutableArray new];
    
        NSDictionary* parames = @{@"PageIndex":@(pageIndex),@"PageSize":@(10),@"CommentID":uuid};
        
        [[FPNetwork POST:API_GET_REPLY_COMMENTV1 withParams:parames]addCompleteHandler:^(FPResponse *response) {
          
            if (response.success) {
                 self.commentDataSource = [ConsulationReplyList mj_objectArrayWithKeyValuesArray:response.data];
                NSLog(@"commentDataSource - is-- %@",self.commentDataSource);
            }
            
            
        }];
}

//点赞
- (void)praise:(nullable NSString *)consultationID success:(nullable LoadHandler)block{
    WS(ws);
    NSString *consultationType;
    if (!_praiseType || _praiseType == 0) {
        consultationType = @"1";
    }else{
        consultationType = @"2";
    }
    [ProgressUtil show];
    [[FPNetwork POST:INSERT_CONSULTATION_PRAISE withParams:@{@"UserID":@(kCurrentUser.userId),@"ConsultationType":consultationType,@"ConsultationID":consultationID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            if ([response.data boolValue] == YES) {
                [ProgressUtil showSuccess:@"成功点赞"];
                block(YES,nil);
                [ws sendNotification];
            }else{
                [ProgressUtil showError:@"点赞失败"];
                block(NO,response.message);
            }
        }else{
            [ProgressUtil showError:@"点赞失败"];
            block(NO,response.message);
        }
    }];
}
//取消点赞
- (void)cancelPraise:(nullable NSString *)consultationID success:(nullable LoadHandler)block{
    WS(ws);
    NSString *consultationType;
    if (!_praiseType || _praiseType == 0) {
        consultationType = @"1";
    }else{
        consultationType = @"2";
    }
    [ProgressUtil show];
    [[FPNetwork POST:CANCEL_CONSULTATION_PRAISE withParams:@{@"UserID":@(kCurrentUser.userId),@"ConsultationType":consultationType,@"ConsultationID":consultationID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            if ([response.data boolValue] == YES) {
                [ProgressUtil showSuccess:@"取消点赞成功"];
                [ws sendNotification];
                block(YES,nil);
            }else{
                [ProgressUtil showError:@"取消点赞失败"];
                block(NO,response.message);
            }
        }else{
            [ProgressUtil showError:@"取消点赞失败"];
            block(NO,response.message);
        }
    }];
}
- (void)sendNotification{
    //通知圈子更新
        [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil];
    //通知咨询页面刷新
    [kdefaultCenter postNotificationName:Notification_RefreshHotQuestion object:nil];
    //刷新首页点赞的数据
    [kdefaultCenter postNotificationName:Notification_RefreshHomePraiseHot object:nil];
    
}

//获取帖子详情单条数据
-(void)GetCircleDetailSingleWithuuid:(NSNumber*_Nullable)uuid{
    NSDictionary *parames = @{@"UserID":@(kCurrentUser.userId),@"uuid":uuid};
    WS(ws);
    [[FPNetwork POST:API_GetCircleSingleV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            ws.CircleDetailSingleSource = [CircleEntity mj_objectArrayWithKeyValuesArray:response.data];
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetCircleDetailSingleComplete:info:)]){
            [ws.delegate GetCircleDetailSingleComplete:response.success info:response.message];
        }
        
    }];
}

-(void)deleteFirstWorldId:(NSNumber *)worldId{
    
    NSDictionary *parames = @{@"wordId":worldId,@"userID":@(kCurrentUser.userId)};
    
    NSString* actionName = API_DeleteWordsConsultationByID;
    
    [[FPNetwork POST:actionName withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            
            NSLog(@"%@",response.data);
        }
    }];
    
}

@end
