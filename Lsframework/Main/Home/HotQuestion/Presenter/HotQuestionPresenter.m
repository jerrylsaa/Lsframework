//
//  HotQuestionPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HotQuestionPresenter.h"
#import "UIImage+Category.h"
#import "NSString+Category.h"
#import "ZHProgressView.h"

@interface HotQuestionPresenter (){
    NSInteger _page;
    NSNumber* _docotrID;
    NSInteger _status;
    
}

@end

@implementation HotQuestionPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        _page = 1;
    }
    return self;
}

- (void)refreshHotQuestion:(LoadHandler)block{
    _page = 1;
    [self loadHotQuestion:^(BOOL success, NSString *message) {
        block(success,message);
    }];
}
- (void)loadMoreHotQuestion:(LoadHandler)block{
    _page ++;
//    WS(ws);
    [self loadHotQuestion:^(BOOL success, NSString *message) {
        block(success,message);
//        NSLog(@"%d=-=-= %d",_page,ws.dataSource.count);
    }];
}

- (void)loadHotQuestion:(LoadHandler)block{
    NSDictionary *parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId),@"orderIndex":@(4)};
    
    if (_hospitalName!=nil&&_hospitalName.length!=0) {
        
        if (_officeName!=nil&&_officeName.length!=0) {
            if ([_hospitalName isEqualToString:@"限时免费"]) {
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId),@"orderIndex":@(1),@"department":_officeName};
            }else if ([_hospitalName isEqualToString:@"热门问题"]){
            
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId),@"orderIndex":@(2),@"department":_officeName};
            
            }else if ([_hospitalName isEqualToString:@"未回答"]){
                
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId),@"orderIndex":@(3),@"department":_officeName};
                
            }else{
                parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId),@"orderIndex":@(4),@"department":_officeName};
    
            }

        }else {
            if ([_hospitalName isEqualToString:@"限时免费"]) {
                parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId),@"orderIndex":@(1),@"department":@""};
            }else if ([_hospitalName isEqualToString:@"热门问题"]){
                
                parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId),@"orderIndex":@(2),@"department":@""};
                
            }else if ([_hospitalName isEqualToString:@"未回答"]){
                
                parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId),@"orderIndex":@(3),@"department":@""};
                
            }else{
                parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId),@"orderIndex":@(4),@"department":@""};
                
            }
    
        }
    }else {
        if (_officeName!=nil&&_officeName.length!=0) {
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId),@"orderIndex":@"",@"department":_officeName};
        }
    }
    NSLog(@"医院和科室：%@%@",_hospitalName,_officeName);
    NSLog(@"医院和科室2：%@",parames);
    [[FPNetwork POST:API_GET_ALLEXPERTCONSULTATIONLISTV4 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response) {
            if (response.success == YES) {
                _dataSource= [HEAParentQuestionEntity mj_objectArrayWithKeyValuesArray:response.data];
//                _dataSource = [HEAParentQuestionEntity sortArray:array];
            }
            block(response.success,response.message);
        }else{
            block(NO,@"网络不可用，请检查网络设置");
        }
    }];
}



-(void)getTradeID:(NSString *)bussinessType withPrice:(CGFloat)price withPayType:(NSString *)payType{
    
    self.bussinessType = bussinessType;
    
    NSInteger userID = kCurrentUser.userId;
    
    NSDictionary* parames = @{@"UserID":@(userID),@"Price":[NSNumber numberWithFloat:price],@"Business":bussinessType,@"PayType":payType};
    WS(ws);
    NSString *action = API_INSERT_PAYORDER;
    if (self.TraceRecords == 1) {
        action = @"InsertBasePayOrderV1";
    }
    [[FPNetwork POST:action withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSDictionary* dic = [response.data firstObject];
            ws.orderID = dic[@"OrderID"];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(tradeIDOnCompletion:info:)]){
            [ws.delegate tradeIDOnCompletion:response.success info:response.message];
        }
    }];
}

-(void)tradePaySuccessWithOrderID:(NSString *)orderID{
    NSInteger userID = kCurrentUser.userId;
    
    NSDictionary* parmas = @{@"UserID":@(userID),@"OrderID":orderID};
    WS(ws);
    
    [[FPNetwork POST:API_PAYSUCCESS withParams:parmas] addCompleteHandler:^(FPResponse *response) {
        
        //        __block BOOL success = YES;
        //        static dispatch_once_t onceToken;
        //        dispatch_once(&onceToken, ^{
        //            success = NO;
        //        });
        
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(paySuccessOnCompletion:info:)]){
            [ws.delegate paySuccessOnCompletion:response.success info:response.message];
        }
    }];
    
}


-(void)addListenQuestion:(HEAParentQuestionEntity *)question withListenPrice:(CGFloat) listenPrice{
    NSInteger userID = kCurrentUser.userId;
    NSString *orderID = self.orderID;
    NSInteger consultationID = question.uuID;
    CGFloat price = listenPrice;
    NSInteger expertID = question.expertID;
    
    
    NSDictionary* parames = @{@"Expert_ID":@(expertID),@"ConsultationID":@(consultationID),@"User_ID":@(userID),@"Price":@1,@"OrderID":orderID};
    WS(ws);
    NSString *action = API_INSERTLISTENQUESTION;
    if (self.TraceRecords == 1) {
        action = @"InsertListenQuestionTraceRecords";
    }
    [[FPNetwork POST:action withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(listenOnCompletion:info:)]){
            [ws.delegate listenOnCompletion:response.success info:response.message];
        }
    }];
    
}

-(void)downloadAudioFile:(NSString *)url{
    
    self.voiceURL = url;
    WS(ws);
//    ZHProgressView *progress = ZHProgress;
//    [progress show];
    [[FPNetwork DOWNLOAD:url downloadPath:@"voice"] addDownloadHandler:^(NSProgress *pregress) {
        
        NSLog(@"progress = %.2f",pregress.fractionCompleted);
//        progress.progressValue = pregress.fractionCompleted;
    } withCompleteHandler:^(FPResponse *response) {
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(downloadOnCompletion:info:)]){
            [ws.delegate downloadOnCompletion:response.success info:response.message];
        }
    }];
    
}

- (void)uploadPhoto:(NSMutableArray *)photoArr{
    WS(ws);
    NSMutableArray *photoUrlArr =[NSMutableArray array];
    if (photoArr.count!=0) {
        
        for (UIImage *image in photoArr) {
            
            
            FormData * formData = [FormData new];
            formData.data = [image resetSizeOfImageData:image maxSize:200];
            //        formData.data = UIImagePNGRepresentation(image);
            
            formData.fileName = @"file.png";
            formData.name = @"file";
            formData.mimeType = @"image/png";
            
            [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:@[formData]] addCompleteHandler:^(FPResponse *response) {
                if (response.success) {
                    
                    NSDictionary *data = [response.data dictionary];
                    NSLog(@"%@", response.data);
                    NSMutableArray *uploadPathArr = [data[@"Result"] getSingleUploadPath];
                    NSLog(@"======%@",uploadPathArr);
                    if (uploadPathArr[0]) {
                        [photoUrlArr addObject:uploadPathArr[0]];
                        if (photoUrlArr.count ==photoArr.count) {
                            
                            if(ws.delegate && [ws.delegate respondsToSelector:@selector(uploadPhotoDataOnCompletion:info:urlPhotoPathArr:)]){
                                [ws.delegate uploadPhotoDataOnCompletion:response.success info:response.message urlPhotoPathArr:photoUrlArr];
                            }else{
                                [ProgressUtil showError:@"请重试"];
                            }
                            
                        }
                    }
                    
                    
                }else {
                    
                    
                    if(ws.delegate && [ws.delegate respondsToSelector:@selector(uploadPhotoDataOnCompletion:info:urlPhotoPathArr:)]){
                        [ws.delegate uploadPhotoDataOnCompletion:NO     info:nil urlPhotoPathArr:photoUrlArr];
                    }else{
                        [ProgressUtil showError:@"请重试"];
                    }
                }
                
            }];
            
            
        }
    }else {
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(uploadPhotoDataOnCompletion:info:urlPhotoPathArr:)]){
            [ws.delegate uploadPhotoDataOnCompletion:YES     info:nil urlPhotoPathArr:photoUrlArr];
        }else{
            [ProgressUtil showError:@"请重试"];
        }
    }
    
}

/**
 *  获取科室
 */
- (void)loadExpertOffice{

    NSDictionary* parames = @{@"userid":@(kCurrentUser.userId)};
    WS(ws);
    [[FPNetwork POST:@"GetExpertDepartNameList" withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSMutableArray* array = [ExpertOfficeEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.officeDataSource];
                [result addObjectsFromArray:array];
                ws.officeDataSource = nil;
                ws.officeDataSource = result;
            }
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetOfficeCompletion:info:)]){
            [ws.delegate onGetOfficeCompletion:response.success info:response.message];
        }
        
    }];
}

- (void)setHospitalName:(NSString *)hospitalName{
    if (_hospitalName!=hospitalName) {
        _page =1;
    }
    _hospitalName =hospitalName;
}

- (void)setOfficeName:(NSString *)officeName{
    if (_officeName!=officeName) {
        _page =1;
    }
    _officeName =officeName;
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

@end
