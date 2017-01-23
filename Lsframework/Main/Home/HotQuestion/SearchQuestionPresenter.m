//
//  SearchQuestionPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SearchQuestionPresenter.h"
#import "UIImage+Category.h"
#import "NSString+Category.h"
#import "ZHProgressView.h"

@interface SearchQuestionPresenter (){
    NSInteger _page;
    NSNumber* _docotrID;
    NSInteger _status;
    
}

@end

@implementation SearchQuestionPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        _page = 1;
    }
    return self;
}

- (void)refreshSearchQuestion:(LoadHandler)block{
    _page = 1;
    [self loadHotQuestion:^(BOOL success, NSString *message) {
        block(success,message);
    }];
}
- (void)loadMoreSearchQuestion:(LoadHandler)block{
    _page ++;
    WS(ws);
    [self loadHotQuestion:^(BOOL success, NSString *message) {
        block(success,message);
        //        NSLog(@"%d=-=-= %d",_page,ws.dataSource.count);
    }];
}

- (void)loadHotQuestion:(LoadHandler)block{
//    NSDictionary *parames = @{@"PageIndex":@(_page),@"PageSize":@(5)};
    
//    if (_SearchName!=nil&&_SearchName.length!=0) {
    NSInteger userID = kCurrentUser.userId;
        NSDictionary *parames = @{@"PageIndex":@(_page),@"PageSize":@(10),@"keyword":_SearchName,@"userid":@(userID)};

//    }
    
    [[FPNetwork POST:API_GET_ALLEXPERTCONSULTATIONLISTBYKEYWORDV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response) {
            if (response.success == YES) {
                NSLog(@"搜索:%@",response.data);
                _dataSource = [HEAParentQuestionEntity mj_objectArrayWithKeyValuesArray:response.data];
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
    
    [[FPNetwork POST:API_INSERT_PAYORDER withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSDictionary* dic = [response.data firstObject];
            ws.orderID = [NSString stringWithFormat:@"%@",dic[@"OrderID"]];
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
    [[FPNetwork POST:API_INSERTLISTENQUESTION withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        
        
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


- (void)setSearchName:(NSString *)SearchName{
    if (_SearchName!=SearchName) {
        _page =1;
    }
    _SearchName =SearchName;
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



@end
