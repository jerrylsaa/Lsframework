//
//  HotDetailPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HotDetailPresenter.h"
#import "VoiceConverter.h"
#import "ZHProgressView.h"
#import "HEAParentQuestionEntity.h"

@interface HotDetailPresenter ()<ZHAVRecoderDelegate>{
    NSInteger _page;
    NSInteger  _ConsultationID;
    
}


@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;

@end

@implementation HotDetailPresenter

- (instancetype)init{
    if (self = [super init]) {
        _page = 1;
        _player.delegate = self;
        self.taskManager = [[DataTaskManager alloc] init];
    }
    return self;
}


- (void)play:(playStart)block{
    NSArray* result = [_url componentsSeparatedByString:@"/"];
    //语音文件存在
    if([NSString fileIsExist:[result lastObject]]){
        NSLog(@"文件已存在");
        //判断是否需要转码
        NSURL* audioURL = nil;
        if([NSString isNotNeedConvertAmrToWav:[result lastObject]]){
            //不需要转码，直接播放
            NSLog(@"文件已转码");
            audioURL = [NSString getAudioURL:[result lastObject]];
        }else{
            //先转码，在播放
            NSLog(@"转码");
            NSString* downloadPath = [NSString getDownloadPath:_url];
            //文件名不带后缀
            NSString* fileName = [NSString getFileName:[result lastObject]];
            
            NSString *convertedPath = [NSString GetPathByFileName:fileName ofType:@"wav"];
            
            if([VoiceConverter ConvertAmrToWav:downloadPath wavSavePath:convertedPath]){
                NSLog(@"转码成功");
                NSLog(@"p = %@",[NSURL URLWithString:[NSString GetPathByFileName:fileName ofType:@"wav"]]);
                //                        [[AVRecorderPlayerManager sharedManager] playerAudio:[NSURL URLWithString:[NSString GetPathByFileName:fileName ofType:@"wav"]]];
                
                audioURL = [NSString getAudioURL:[result lastObject]];
                
            }else{
                NSLog(@"转码失败");
            }
        }
        BOOL success = [self playWith:audioURL];
        block(success);
        block(success);
    }else{
        //语音文件不存在，下载
        NSLog(@"文件不存在");
        [ProgressUtil show];
//        ZHProgressView *progress = ZHProgress;
//        [progress show];
        [[FPNetwork DOWNLOAD:_url downloadPath:@"voice"] addDownloadHandler:^(NSProgress *pregress) {
            NSLog(@"progress = %g",pregress.fractionCompleted);
//            progress.progressValue = pregress.fractionCompleted;
        } withCompleteHandler:^(FPResponse *response) {
            [ProgressUtil dismiss];
            if(response.success){
                NSLog(@"url = %@",response.downloadPath);
                
                //先转码，在播放
                NSLog(@"转码");
                NSString* downloadPath = [NSString getDownloadPath:_url];
                //文件名不带后缀
                NSString* fileName = [NSString getFileName:[result lastObject]];
                
                NSString *convertedPath = [NSString GetPathByFileName:fileName ofType:@"wav"];
                if([VoiceConverter ConvertAmrToWav:downloadPath wavSavePath:convertedPath]){
                    NSLog(@"转码成功");
                    NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
                    BOOL success = [self playWith:audioURL];
                    block(success);
                }else{
                    NSLog(@"转码失败");
                }
            }else{
                //下载失败
                NSLog(@"下载失败");
            }
        }];
    }
    
}

- (BOOL)playWith:(NSURL *) url{
    //播放
    _player.audioPath = url.absoluteString;
    
    
    BOOL success = [_player playerStart];
    if (success == YES) {
        _second = 0;
        [self timerStart];
    }
    return success;
}

- (void)stop{
    [_player playerStop];
    _player.delegate = nil;
    [_timer invalidate];
    _timer = nil;
}
- (void)audioEndWith:(AudioType)audioType message:(NSString *)message{
    [_timer invalidate];
    _timer = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playFinished)]) {
        [self.delegate playFinished];
    }
}

//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    [_timer invalidate];
//    _timer = nil;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(playFinished)]) {
//        [self.delegate playFinished];
//    }
//}
- (void)timerStart{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAdd) userInfo:nil repeats:YES];
    _second = 0;
}
- (void)timeAdd{
    _second ++;
    NSString *time;
    if (_second >= 60) {
        NSString *min;
        NSString *sec;
        if (_second/60 >= 10) {
            min = [NSString stringWithFormat:@"%ld",_second/60];
        }else{
            min = [NSString stringWithFormat:@"0%ld",_second/60];
        }
        if (_second%60 >= 10) {
            sec = [NSString stringWithFormat:@"%ld",_second%60];
        }else{
            sec = [NSString stringWithFormat:@"0%ld",_second%60];
        }
        time = [NSString stringWithFormat:@"%@:%@",min,sec];
    }else{
        NSString *sec;
        if (_second%60 >= 10) {
            sec = [NSString stringWithFormat:@"%ld",_second%60];
        }else{
            sec = [NSString stringWithFormat:@"0%ld",_second%60];
        }
        time = [NSString stringWithFormat:@"00:%@",sec];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(second:)]) {
        [self.delegate second:time];
    }
}

//- (void)loadDoctorInfoBy:(NSNumber *)experID complete:(LoadHandler)block{
//    WS(ws);
//    [[FPNetwork POST:API_GET_NEW_EXPERT_DOCTOR_INFO withParams:@{@"ExpertDoctorID":experID}] addCompleteHandler:^(FPResponse *response) {
//        if (response.success == YES) {
//            NSArray *array = [ExpertAnswerEntity mj_objectArrayWithKeyValuesArray:response.data];
//            ws.expertAnswer = array.firstObject;
//        }
//        block(response.success,response.message);
//    }];
//}
-(void)loadDoctorInfoBy:(NSNumber *)experID{

    WS(ws);
    [[FPNetwork POST:API_GET_NEW_EXPERT_DOCTOR_INFO withParams:@{@"ExpertDoctorID":experID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            ws.expertAnswer= [ExpertAnswerEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadDoctorInfoCompletion:info:)]){
            [ws.delegate loadDoctorInfoCompletion:response.success info:response.message];
        }
        
    }];

}
-(void)FreeListeningCountWithConsultationID:(NSInteger)ConsultationID{
    
    NSDictionary* parames = @{@"ConsultationID":@(ConsultationID),@"userID":@(kCurrentUser.userId)};
    
    WS(ws);
    
    [[FPNetwork POST: API_FREELISTENING withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            
            
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onFreeListeningCountCompletion:info:)]){
                [ws.delegate onFreeListeningCountCompletion:response.success info:response.message];
            }
        }
        else {
            
        }
    }];
}
//-(void)GetTherapeuticVisitByConsultationID:(NSUInteger)ConsultationID{
//    
//    
////    NSDictionary* parames = @{@"ConsultationID":@(ConsultationID),@"userID":@(kCurrentUser.userId)};
//    NSDictionary* parames = @{@"ConsultationID":@(ConsultationID)};
//    
//    WS(ws);
//    
//    [[FPNetwork POST: API_GET_THERAPEUTIC_VISTBYCONSULATIONID withParams:parames] addCompleteHandler:^(FPResponse *response) {
//        
//        if (response.success) {
//            
//            ws.TherapeuticVisitSource = [TherapeuticVisit mj_objectArrayWithKeyValuesArray:response.data];
//           
//            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetTherapeuticVisitCompletion:info:)]){
//                [ws.delegate GetTherapeuticVisitCompletion:response.success info:response.message];
//            }
//        }
//        else {
//            
//        }
//    }];
//}
//-(void)GetTherapeuticVisitByConsultationID:(NSUInteger)ConsultationID complete:(LoadHandler)block{
//    
//    
//    //    NSDictionary* parames = @{@"ConsultationID":@(ConsultationID),@"userID":@(kCurrentUser.userId)};
//    NSDictionary* parames = @{@"ConsultationID":@(ConsultationID)};
//    
//    WS(ws);
//    
//    [[FPNetwork POST: API_GET_THERAPEUTIC_VISTBYCONSULATIONID withParams:parames] addCompleteHandler:^(FPResponse *response) {
//        if (response.success) {
//            ws.TherapeuticVisitSource = [TherapeuticVisit mj_objectArrayWithKeyValuesArray:response.data];
//            block(YES,nil);
//        }else{
//            [ProgressUtil showError:@"获取疗效回访失败"];
//        }
//    }];
//}


- (void)GetConsultationCommentListByConsultationID:(NSUInteger)ConsultationID {
    if(self.ConsultationDataSource){
        [self.ConsultationDataSource removeAllObjects];
        self.ConsultationDataSource = nil;
    }
    _page = 1;
    _ConsultationID = ConsultationID;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"ConsultationID":@(ConsultationID),@"UserID":@(kCurrentUser.userId),@"ConsultationType":@(1)};
    
    
    WS(ws);
    
    [[FPNetwork POST: API_GET_CONSULATIONCOMMENTLISTV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            if (response.data!=nil) {
                [ConsultationCommenList mj_setupObjectClassInArray:^NSDictionary *{
                    return @{@"ReplyCommentList": @"ConsulationReplyList"};
                }];

                ws.ConsultationDataSource = [ConsultationCommenList mj_objectArrayWithKeyValuesArray:response.data];
                
                ws.totalCount = response.totalCount;
                
                for(ConsultationCommenList* comment in ws.ConsultationDataSource){
                    NSMutableArray* array = comment.ReplyCommentList;
                    NSLog(@"reply---%ld",(unsigned long)array.count);
                }
                [ws getReply:ws.ConsultationDataSource];
            }
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetConsultationCommentListCompletion:info:)]){
                [ws.delegate GetConsultationCommentListCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
    
}


-(void)getMoreConsultationCommentList{
    _page++;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"ConsultationID":@(_ConsultationID),@"UserID":@(kCurrentUser.userId),@"ConsultationType":@(1)};
    WS(ws);
    
    [[FPNetwork POST:API_GET_CONSULATIONCOMMENTLISTV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            [ConsultationCommenList mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"ReplyCommentList": @"ConsulationReplyList"};
            }];
            
            NSMutableArray* array = [ConsultationCommenList mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.ConsultationDataSource];
                [result addObjectsFromArray:array];
                ws.ConsultationDataSource = nil;
                ws.ConsultationDataSource = result;
                
                [ws getReply:ws.ConsultationDataSource];
            }else{
                ws.noMoreData = YES;
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetMoreConsultationCommentListCompletion:info:)]){
            [ws.delegate GetMoreConsultationCommentListCompletion:response.success info:response.message];
        }
        
    }];
}

//插入咨询
- (void)ConsultationPost:(NSMutableArray*) imageDataSorce ConsultationID:(NSInteger)ConsultationID  CommentContent:(NSString*) CommentContent{
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
                            [ws loadArr:formDataArray ConsultationID:ConsultationID consultation:CommentContent];
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
            
            [self commitConsultation:@"" ConsultationID:ConsultationID CommentContent:CommentContent];
        });
        
    }


}
- (void)loadArr:(NSMutableArray*)uploadArrPath ConsultationID:(NSUInteger)commentID consultation:(NSString*) consultation
{
    NSDictionary *parames;

    if (uploadArrPath.count != 0) {
        if (uploadArrPath.count == 1) {
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(1),@"ConsultationType",uploadArrPath[0],@"Image1", nil];
            
        }else if (uploadArrPath.count ==2){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(1),@"ConsultationType",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2", nil];
            
        }else if (uploadArrPath.count == 3){
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(1),@"ConsultationType",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3", nil];
        }else if (uploadArrPath.count == 4){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(1),@"ConsultationType",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4", nil];
            
        }else if (uploadArrPath.count == 5){
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(1),@"ConsultationType",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4",uploadArrPath[4],@"Image5", nil];
            
        }else if (uploadArrPath.count == 6){
            
            parames = [NSDictionary dictionaryWithObjectsAndKeys:@(commentID),@"ConsultationID",@(kCurrentUser.userId),@"UserID",consultation,@"CommentContent",@(1),@"ConsultationType",uploadArrPath[0],@"Image1",uploadArrPath[1],@"Image2",uploadArrPath[2],@"Image3",uploadArrPath[3],@"Image4",uploadArrPath[4],@"Image5",uploadArrPath[5],@"Image6", nil];
        }
        
        WS(ws);
        [[FPNetwork POST:API_INSERT_CONSULTATIONCOMMENT withParams:parames] addCompleteHandler:^(FPResponse *response) {
            if(response.success){
                [ProgressUtil dismiss];
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(InsertConsulationOnCompletion:info:)]){
                    [ws.delegate InsertConsulationOnCompletion:response.success info:response.message];
                }
                
                
            }else{
                [ProgressUtil showError:response.message];
            }
        }];
    }
    
    
}

- (void)commitConsultation:(NSString*) uploadPath ConsultationID:(NSInteger)ConsultationID  CommentContent:(NSString*) CommentContent{
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
    
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"ConsultationID":@(ConsultationID), @"CommentContent":CommentContent, @"ConsultationType":@(1),@"Image1":image1Path, @"Image2":image2Path, @"Image3":image3Path};
    
    
    WS(ws);
    [[FPNetwork POST:API_INSERT_CONSULTATIONCOMMENT withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            [ProgressUtil dismiss];
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(InsertConsulationOnCompletion:info:)]){
                [ws.delegate InsertConsulationOnCompletion:response.success info:response.message];
            }
            
            
        }else{
            [ProgressUtil showError:response.message];
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
//    [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil];
    //通知咨询页面刷新
    [kdefaultCenter postNotificationName:Notification_RefreshHotQuestion object:nil];
}

- (void)checkWXPayResultWithOder:(NSString *)oder{
    WS(ws);
    [[FPNetwork GETtigerhuang007:@"QueryWxOrderState" withParams:@{@"token":kCurrentUser.token,@"userID":@(kCurrentUser.userId),@"orderNo":oder}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            [ProgressUtil showInfo:response.message];
            if (response.data !=nil) {
                NSDictionary *dict =response.data;
                NSString *state =[dict objectForKey:@"state"];
                NSString *url =[dict objectForKey:@"voiceUrl"];
                if ([state isEqualToString:@"SUCCESS"]) {
                    if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCheckWXPayResultWithOderCompletion:info:Url:)]){
                        [ws.delegate onCheckWXPayResultWithOderCompletion:response.success info:response.message Url:url];
                    }
                }
            }
            
        }else {
            if (response.message !=nil&&![response.message isEqualToString:@""]) {
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCheckWXPayResultWithOderCompletion:info:Url:)]){
                    [ws.delegate onCheckWXPayResultWithOderCompletion:NO info:response.message Url:nil];
                }
            }else{
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCheckWXPayResultWithOderCompletion:info:Url:)]){
                    [ws.delegate onCheckWXPayResultWithOderCompletion:NO info:@"网络不可用,请重试" Url:nil];
                }
            }
        }
    }];
}

- (void)weixinPayWithListenId:(NSInteger )questionId{
    WS(ws);
    [[FPNetwork GETtigerhuang007:@"CreateWxOrder" withParams:@{@"token":kCurrentUser.token,@"userID":@(kCurrentUser.userId),@"type":@"listenBiz",@"id":@(questionId)}] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            [ProgressUtil dismiss];
            
            if(response.data){
                NSDictionary* responseDic = response.data;
                
                NSString* orderNO = [responseDic objectForKey:@"orderNO"];
                NSDictionary* wxParams = [responseDic objectForKey:@"wxParams"];
                
                NSLog(@"orderNO = %@,wxParams = %@",orderNO,wxParams);
                
                //发起微信支付
                [WXPayUtil payWithWXParames:wxParams callback:^{
                    
                    //检查微信支付结果
                    [ProgressUtil show];
                    [ws checkWXPayResultWithOder:orderNO];
                    
                    
                }];
                
            }
            
            
        }else if(response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
    }];

}
//加载追问问题
- (void)loadDataByConsultationID:(NSInteger )consultationID finish:(LoadHandler)block{
    //GetExpertConsultationTraceList
    [[FPNetwork POST:@"GetExpertConsultationTraceListV2" withParams:@{@"userid":@(kCurrentUser.userId),@"ConsultationID":@(consultationID),@"PageIndex":@"1",@"PageSize":@"1000"}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            NSArray *arra = response.data;
            for (NSDictionary *dic in arra) {
                NSLog(@"----- -----%@",dic);
            }
            _dataSource = [HEAParentQuestionEntity mj_objectArrayWithKeyValuesArray:response.data];
            block(YES,nil);
        }else{
            block(NO,nil);
        }
    }];
}
//
- (void)GetExpertConsultationByUUID:(NSInteger)uuid finish:(LoadHandler)block{
    WS(ws);
    [[FPNetwork POST:@"GetExpertConsultationWithVisitV1" withParams:@{@"userid":@(kCurrentUser.userId),@"UUID":@(uuid)}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
//            NSArray *array = [DetailQuestion mj_objectArrayWithKeyValuesArray:response.data];
//            ws.question = array.firstObject;
    ws.NoAnswer = [NSNumber  numberWithInteger:response.NoAnswer];
    NSArray  *coulationsArray = [response.data  objectForKey:@"Consultation"];
     ws.question = [DetailQuestion  mj_objectWithKeyValues:coulationsArray.firstObject];
            
    NSArray  *VisitArray = [response.data  objectForKey:@"Visit"];
    ws.TherapeuticVisitSource = [TherapeuticVisit  mj_objectWithKeyValues:VisitArray.firstObject];
            
     ws.url = ws.question.VoiceUrl;
            block(YES,nil);
        }else{
            block(NO,nil);
        }
    }];
}

- (void)GetExpertHalfPriceByExpertID:(NSInteger )expertID{
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"ExpertID":@(expertID)};
    
    WS(ws);
    [[FPNetwork POST:API_GetExpertHalfPrice withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                NSArray *arr =response.data;
                if (arr.count!=0) {
                    NSDictionary *dic =arr[0];
                    if (dic!=nil) {
                        _halfPrice =[dic objectForKey:@"HalfPrice"];
                        _ifVacation =[dic objectForKey:@"IsVacation"];
                        
                        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetExpertHalfPriceOnCompletion: info:)]){
                            [ws.delegate GetExpertHalfPriceOnCompletion:YES info:response.message];
                        }else{
                            [ProgressUtil showError:@"网络不可用,请重试"];
                        }
                    }
                }
                
                
                
            }else{
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetExpertHalfPriceOnCompletion: info:)]){
                    [ws.delegate GetExpertHalfPriceOnCompletion:NO info:response.message];
                }else{
                    [ProgressUtil showError:@"网络不可用,请重试"];
                }
//                ws.myDietAnalysisSource =nil;
//                if(ws.delegate && [ws.delegate respondsToSelector:@selector(getDietAnalysisOnCompletion: Info:)]){
//                    [ws.delegate getDietAnalysisOnCompletion:YES Info:response.message];
//                }else{
//                    [ProgressUtil showError:@"网络不可用,请重试"];
//                }
            }
            
            
        }else if (response.status ==500){
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetExpertHalfPriceOnCompletion: info:)]){
                [ws.delegate GetExpertHalfPriceOnCompletion:NO info:response.message];
            }else{
                [ProgressUtil showError:@"网络不可用,请重试"];
            }
        }else {
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetExpertHalfPriceOnCompletion: info:)]){
                [ws.delegate GetExpertHalfPriceOnCompletion:NO info:@"网络不可用,请重试"];
            }else{
                [ProgressUtil showError:@"网络不可用,请重试"];
            }
            
        }
        
    }];
}

- (void)GetExpertCommentListByConsultationID:(NSNumber *)uuid{
    WS(ws);
    [[FPNetwork POST:API_GetExpertCommentList withParams:@{@"ConsultationID":uuid,@"PageIndex":@1,@"PageSize":@1}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success == YES) {
            NSArray *array = [ExpertCommentListEntity mj_objectArrayWithKeyValuesArray:response.data];
            if (array.count!=0) {
                ws.myComment = array.firstObject;
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(getExpertCommentListSuccess)]) {
                [self.delegate getExpertCommentListSuccess];
            }
        }else{
            [ProgressUtil showError:response.message?response.message:@"网络不可用,请重试"];
        }
    }];
}

- (void)addExpertComment:(NSString *)comment Stars:(NSInteger )stars ConsultationID:(NSNumber *)consultationID ExpertID:(NSNumber *)expertID{
    WS(ws);
    [[FPNetwork POST:API_AddExpertComment withParams:@{@"StarLevel":@(stars),@"ConsultationID":consultationID,@"CommentConetent":comment,@"ExpertID":expertID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success == YES) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(addExpertCommentSuccess)]) {
                [self.delegate addExpertCommentSuccess];
            }
        }else{
            [ProgressUtil showError:response.message?response.message:@"网络不可用,请重试"];
        }
    }];
}



#pragma mark - 获取评论里的回复
- (void)getReply:(NSMutableArray*) commentDataSource{
    NSMutableArray* array = [NSMutableArray array];
    NSMutableArray* replyDataSource = [NSMutableArray array];
    
    for(int i = 0; i < commentDataSource.count; i++){
        ConsultationCommenList* commentEntity = commentDataSource[i];
        
        NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(2),@"CommentID":@(commentEntity.uuid)};
        
        WS(ws);
        FPNetwork* repley = [[FPNetwork POST:API_GET_REPLY_COMMENT withParams:parames] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
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
        NSLog(@"---%ld",replyDataSource.count);
        
        for(ConsultationCommenList* commentEntity in ws.ConsultationDataSource){
            
            NSMutableArray* temp = [NSMutableArray array];
            
            for(ConsulationReplyList* replyEntity in replyDataSource){
                
                if(commentEntity.uuid == replyEntity.CommentID){
                    [temp addObject:replyEntity];
                }
            }
            commentEntity.ReplyCommentList = temp;
            
        }
        
        
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetConsultationCommentListCompletion:info:)]){
            [ws.delegate GetConsultationCommentListCompletion:YES info:@""];
        }
        
        
    }];
    
}



@end
