//
//  PatientCaseDetailPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PatientCaseDetailPresenter.h"

@interface PatientCaseDetailPresenter (){
    NSInteger index;
}

@end

@implementation PatientCaseDetailPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        self.taskManager = [DataTaskManager new];
        index = 1;
    }
    return self;
}


-(void)loadPatientCaseDetail:(NSNumber *)recordID{
    
    NSMutableArray* netWorkArray = [NSMutableArray array];
    WS(ws);
    
    //加载病友详情
    NSDictionary* patientCaseParames = @{@"AdmissionRecordID": recordID};
    FPNetwork* patientCaseNetWork = [[FPNetwork POST:API_Get_AdmissionRecordDetailV1 withParams:patientCaseParames] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
        [ws.taskManager countDown];
        
        if(response.success){
            
            NSMutableArray* array = [PatientCaseDetailEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            ws.patientCaseDetailDataSource = [PatientCaseDetailEntity formatModelWithArray:array];
            
        }else {
            [ProgressUtil showError:response.message];
        }
        
    }];
    [netWorkArray addObject:patientCaseNetWork];
    
    //加载评论
    index = 1;
    NSDictionary* commentParames = @{@"AdmissionRecordID":recordID ,@"PageIndex":@(index), @"PageSize":@(kPageSize)};
    FPNetwork* commentNetWork = [[FPNetwork POST:API_Get_AdmissionCommentV1 withParams:commentParames] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
        [ws.taskManager countDown];
        
        if(response.success){
            
            [ConsultationCommenList mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"ReplayList": @"ConsulationReplyList"};
            }];

            
            ws.commentListDataSource = [ConsultationCommenList mj_objectArrayWithKeyValuesArray:response.data];
            ws.noMoreData = (response.totalCount <= kPageSize);
            ws.commentTotalCount = response.totalCount;
            
            [ConsultationCommenList formatConsulationReplyListWithArray:ws.commentListDataSource];
            
        }else {
            [ProgressUtil showError:response.message];
        }
    }];
    [netWorkArray addObject:commentNetWork];
    
    //
    [self.taskManager requestWithDataTasks:netWorkArray withComplete:^{
       
        ws.dataSource = [NSMutableArray arrayWithObjects:ws.patientCaseDetailDataSource,ws.commentListDataSource, nil];
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadPatientCaseDetailComplete)]){
            [ws.delegate loadPatientCaseDetailComplete];
        }
    }];
    
}

-(void)uploadPostImage:(NSMutableArray *)imageDataSorce ConsultationID:(NSInteger)commentID CommentContent:(NSString *) commentContent{
    NSMutableArray* formDataArray=[NSMutableArray array];
    if (imageDataSorce.count != 0) {
        for (UIImage *image in imageDataSorce) {
            FormData* formData = [FormData new];
            formData.data = [image resetSizeOfImageData:image maxSize:500];
            formData.fileName=@"file.png";
            formData.name=@"file";
            formData.mimeType=@"image/png";
            
            WS(ws);
            [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:@[formData]] addCompleteHandler:^(FPResponse *response) {
                if(response.success){
                    [ProgressUtil dismiss];
                    NSDictionary* data=[response.data dictionary];
                    NSMutableArray* uploadPath=[data[@"Result"] getSingleUploadPath];
                    NSLog(@"uploadPath=%@",uploadPath);
                    if (uploadPath[0]) {
                        [formDataArray addObject:uploadPath[0]];
                        if (formDataArray.count == imageDataSorce.count) {
                            [ws loadArr:formDataArray ConsultationID:commentID consultation:commentContent];
                        }
                    }
                    
                    
                }else{
                    [ProgressUtil showError:response.message];
                }
            }];
        }
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ProgressUtil show];
            
            [self commitPostComment:@"" ConsultationID:commentID CommentContent:commentContent];
        });
        
    }
    
}
- (void)loadArr:(NSMutableArray*)uploadArrPath ConsultationID:(NSUInteger)commentID consultation:(NSString*) consultation
{
    NSDictionary *parames;

    if (uploadArrPath.count != 0) {
        if (uploadArrPath.count == 1) {
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"AdmissionRecordID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@"",@"IsDelete",uploadArrPath[0],@"Image1", nil];
            
        }else if (uploadArrPath.count ==2){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"AdmissionRecordID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@"",@"IsDelete",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2", nil];
            
        }else if (uploadArrPath.count == 3){
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"AdmissionRecordID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@"",@"IsDelete",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3", nil];
        }else if (uploadArrPath.count == 4){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"AdmissionRecordID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@"",@"IsDelete",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4", nil];
            
        }else if (uploadArrPath.count == 5){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"AdmissionRecordID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@"",@"IsDelete",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4",uploadArrPath[4],@"Image5", nil];
            
        }else if (uploadArrPath.count == 6){
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"AdmissionRecordID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@"",@"IsDelete",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4",uploadArrPath[4],@"Image5",uploadArrPath[5],@"Image6", nil];
        }
        
        WS(ws);
        [[FPNetwork POST:API_Add_AdmissionComment withParams:parames] addCompleteHandler:^(FPResponse *response) {
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
    
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"AdmissionRecordID":@(commentID), @"CommentContent":CommentContent, @"IsDelete":@"",@"Image1":image1Path, @"Image2":image2Path, @"Image3":image3Path};
    
    
    WS(ws);
    [[FPNetwork POST:API_Add_AdmissionComment withParams:parames] addCompleteHandler:^(FPResponse *response) {
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

-(void)getPostCommentListByCommentID:(NSInteger)commentID{
    index = 1;
    self.currentIndex = index;
    
    NSDictionary* parames = @{@"AdmissionRecordID":@(commentID) ,@"PageIndex":@(index), @"PageSize":@(kPageSize)};

    
    WS(ws);
    [[FPNetwork POST: API_Get_AdmissionCommentV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            
            [ConsultationCommenList mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"ReplayList": @"ConsulationReplyList"};
            }];
            
            ws.commentTotalCount = response.totalCount;
            ws.commentListDataSource = [ConsultationCommenList mj_objectArrayWithKeyValuesArray:response.data];
            [ConsultationCommenList formatConsulationReplyListWithArray:ws.commentListDataSource];
            
            ws.noMoreData = ws.commentListDataSource.count == 0;
            
            WSLog(@"&&&&&====%u---",ws.dataSource.count);
            
            //
            if(ws.dataSource.count != 0){
                
                if(ws.dataSource.count > 1){
                    //有评论
                    [ws.dataSource removeLastObject];
                    [ws.dataSource addObject:ws.commentListDataSource];
                }else{
                    //无评论
                    [ws.dataSource addObject:ws.commentListDataSource];
                }
                
                WSLog(@"====%ld---",[ws.dataSource lastObject].count);
                
            }
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(postCommentComplete:info:)]){
            [ws.delegate postCommentComplete:response.success info:response.message];
        }
        
    }];
    
}

- (void)getMorePostCommentListCommentID:(NSUInteger)commentID{
    
    index += 1;
    self.currentIndex = index;
    NSDictionary* parames = @{@"AdmissionRecordID":@(commentID) ,@"PageIndex":@(index), @"PageSize":@(kPageSize)};
    
    
    WS(ws);
    
    [[FPNetwork POST: API_Get_AdmissionCommentV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            [ConsultationCommenList mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"ReplayList": @"ConsulationReplyList"};
            }];
            
            
            NSMutableArray* array = [ConsultationCommenList mj_objectArrayWithKeyValuesArray:response.data];
            if(array.count != 0 ){
                
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.commentListDataSource];
                [result addObjectsFromArray:array];
                ws.commentListDataSource = result;
                
                if(ws.dataSource.count != 0){
                    [ws.dataSource removeLastObject];
                    [ws.dataSource addObject:ws.commentListDataSource];
                    [ConsultationCommenList formatConsulationReplyListWithArray:ws.commentListDataSource];

                }
                
            }else{
                ws.noMoreData = YES;
            }
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(morePostCommentComplete:info:)]){
            [ws.delegate morePostCommentComplete:response.success info:response.message];
        }
        
    }];
    
}
#pragma mark--单条--
-(void)getPostCommentListByCommentID:(NSInteger)commentID NSindexRow:(NSInteger)inter{
    

    NSDictionary* parames = @{@"AdmissionRecordID":@(commentID) ,@"PageIndex":@(inter), @"PageSize":@(kPageSize)};
    
    WS(ws);
    [[FPNetwork POST: API_Get_AdmissionCommentV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            
            [ConsultationCommenList mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"ReplayList": @"ConsulationReplyList"};
            }];
            
            ws.commentTotalCount = response.totalCount;
            ws.commentListDataSource = [ConsultationCommenList mj_objectArrayWithKeyValuesArray:response.data];
            [ConsultationCommenList formatConsulationReplyListWithArray:ws.commentListDataSource];
            
            ws.noMoreData = ws.commentListDataSource.count == 0;
            
            WSLog(@"&&&&&====%u---",ws.dataSource.count);
            
            //
            if(ws.dataSource.count != 0){
                
                if(ws.dataSource.count > 1){
                    //有评论
                    [ws.dataSource removeLastObject];
                    [ws.dataSource addObject:ws.commentListDataSource];
                }else{
                    //无评论
                    [ws.dataSource addObject:ws.commentListDataSource];
                }
                
                WSLog(@"====%ld---",[ws.dataSource lastObject].count);
                
            }
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(postCommentComplete:info:)]){
            [ws.delegate postCommentComplete:response.success info:response.message];
        }
        
    }];
    
}







@end
