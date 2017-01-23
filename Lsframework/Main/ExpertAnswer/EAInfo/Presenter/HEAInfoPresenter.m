//
//  HEAInfoPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HEAInfoPresenter.h"
#import "UIImage+Category.h"
#import "NSString+Category.h"
#import "ZHProgressView.h"
@interface HEAInfoPresenter (){
    NSInteger _page;
    NSNumber* _docotrID;
    NSInteger _status;
    
}

@end

@implementation HEAInfoPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        _page = 1;
    }
    return self;
}


-(void)loadExpertConsultaionData:(NSNumber *)doctorID status:(NSInteger)status{
    NSInteger userID = kCurrentUser.userId;

    _page = 1;
    _docotrID = doctorID;
    _status = status;
    
    
    if(self.dataSource){
        self.dataSource = nil;
    }
    
    NSString* state = (status == -1? @"": [NSString stringWithFormat:@"%ld",status]);
    
    NSDictionary* parames = @{@"expert_ID":doctorID,@"UserID":@(userID),@"status":state,@"PageIndex":@(_page),@"PageSize":@(kPageSize)};

    
    WS(ws);
    [[FPNetwork POST:API_GET_EXPERTCONSULTATIONLISTV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            ws.dataSource = [HEAParentQuestionEntity mj_objectArrayWithKeyValuesArray:response.data];
//            ws.dataSource = [HEAParentQuestionEntity sortArray:array];
            ws.totalCount = response.totalCount;
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];
    
}

-(void)loadCommonExpertConsultaionData:(NSNumber *)doctorID status:(NSInteger)status{
    NSInteger userID = kCurrentUser.userId;
    
    _page = 1;
    _docotrID = doctorID;
    _status = status;
    
    
    if(self.dataSource){
        self.dataSource = nil;
    }
    
    NSString* state = (status == -1? @"": [NSString stringWithFormat:@"%ld",status]);
    
    NSDictionary* parames = @{@"expert_ID":doctorID,@"UserID":@(userID),@"status":state,@"PageIndex":@(_page),@"PageSize":@(3)};
    
    
    WS(ws);
    [[FPNetwork POST:API_GET_EXPERTCONSULTATIONLISTV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            ws.dataSource = [HEAParentQuestionEntity mj_objectArrayWithKeyValuesArray:response.data];
//            ws.dataSource = [HEAParentQuestionEntity sortArray:array];
            ws.totalCount = response.totalCount;
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];
    
}


-(void)loadHYBExpertConsultaionData:(NSNumber *)doctorID status:(NSInteger)status{
    NSInteger userID = kCurrentUser.userId;
    
    _page++;
    _docotrID = doctorID;
    _status = status;
    
    
    if(self.dataSource){
        self.dataSource = nil;
    }
    
    NSString* state = (status == -1? @"": [NSString stringWithFormat:@"%ld",status]);
    
    NSDictionary* parames = @{@"expert_ID":doctorID,@"UserID":@(userID),@"status":state,@"PageIndex":@(_page),@"PageSize":@(3)};
    
    
    WS(ws);
    [[FPNetwork POST:API_GET_EXPERTCONSULTATIONLISTV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            ws.dataSource = [HEAParentQuestionEntity mj_objectArrayWithKeyValuesArray:response.data];
//            ws.dataSource = [HEAParentQuestionEntity sortArray:array];
            ws.totalCount = response.totalCount;
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onHYBCompletion:info:)]){
            [ws.delegate onHYBCompletion:response.success info:response.message];
        }
    }];
    
}


-(void)loadMoreExpertConsultaionData{
//    if(self.dataSource.count != 0){
//        _page++;
//    }
    
    _page++;

    
    NSInteger userID = kCurrentUser.userId;

    NSString* state = (_status == -1? @"": [NSString stringWithFormat:@"%ld",_status]);
    
    NSDictionary* parames = @{@"expert_ID":_docotrID,@"UserID":@(userID),@"status":state,@"PageIndex":@(_page),@"PageSize":@(kPageSize)};
    
    
    WS(ws);
    [[FPNetwork POST:API_GET_EXPERTCONSULTATIONLISTV1 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            
            NSMutableArray* tempArray = [HEAParentQuestionEntity mj_objectArrayWithKeyValuesArray:response.data];
            if(tempArray.count != 0){
                NSMutableArray* array = [NSMutableArray arrayWithArray:ws.dataSource];
                [array addObjectsFromArray:tempArray];
                ws.dataSource = nil;
                ws.dataSource = array;
//                ws.dataSource = [HEAParentQuestionEntity sortArray:array];
            }else{
                ws.noMoreData = YES;
            }
            
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(MoreOnCompletion:info:)]){
            [ws.delegate MoreOnCompletion:response.success info:response.message];
        }
    }];
}
//API_INSERT_CONSULTING_RECORDS
- (void)addExpertConsultation:(NSString *)consultationContent doctorID:(NSNumber *)doctorID photo:(NSArray *)photoUrl isOpen:(BOOL)isopen complete:(AddComplete)block{
    NSString *openStr =[NSString string];
    if (isopen) {
        openStr =@"1";
    }else{
        openStr =@"0";
    }
    NSInteger userID = kCurrentUser.userId;
    NSDictionary *parames =[NSDictionary dictionary];
        
        if (photoUrl.count ==0) {
            parames = @{@"DoctorID":doctorID,@"UserID":@(userID),@"ConsultCount":consultationContent,@"OrderID":self.orderID};
        }else if(photoUrl.count ==1){
            parames = @{@"DoctorID":doctorID,@"UserID":@(userID),@"ConsultCount":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0]};
            
        }else if(photoUrl.count ==2){
            parames = @{@"DoctorID":doctorID,@"UserID":@(userID),@"ConsultCount":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1]};
            
        }else if(photoUrl.count ==3){
            parames = @{@"DoctorID":doctorID,@"UserID":@(userID),@"ConsultCount":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2]};
            
        }else if(photoUrl.count ==4){
            parames = @{@"DoctorID":doctorID,@"UserID":@(userID),@"ConsultCount":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"Image4":photoUrl[3]};
            
        }else if(photoUrl.count ==5){
            parames = @{@"DoctorID":doctorID,@"UserID":@(userID),@"ConsultCount":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"Image4":photoUrl[3],@"Image5":photoUrl[4]};
            
        }else if(photoUrl.count ==6){
            parames = @{@"DoctorID":doctorID,@"UserID":@(userID),@"ConsultCount":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"Image4":photoUrl[3],@"Image5":photoUrl[4],@"Image6":photoUrl[5]};
            
        }

//    block(YES,nil);
    [[FPNetwork POST:API_INSERT_CONSULTING_RECORDS withParams:parames] addCompleteHandler:^(FPResponse *response) {
        block(response.success,response.message);
    }];

}

- (void)addExpertConsultation:(NSString *)consultationContent doctorID:(NSNumber *)doctorID photo:(NSArray *)photoUrl isOpen:(BOOL)isopen couponid:(NSNumber*)couponIDD  Freeclinic:(NSNumber*)Freeclinic{
    NSString *openStr =[NSString string];
    if (isopen) {
        openStr =@"true";
    }else{
        openStr =@"false";
    }
    NSInteger userID = kCurrentUser.userId;
    NSDictionary *parames =[NSDictionary dictionary];

    NSLog(@"888888=coupid:%@",couponIDD);
    
     NSLog(@"orderID:%@",self.orderID);
    if(self.orderID == nil){
        
        self.orderID = @"0";
    }
    if (couponIDD == nil) {
        
        if (photoUrl.count ==0) {
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsFree":Freeclinic};
        }else if(photoUrl.count ==1){
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"IsFree":Freeclinic};
            
        }else if(photoUrl.count ==2){
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"IsFree":Freeclinic};
            
        }else if(photoUrl.count ==3){
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"IsFree":Freeclinic};
            
        }else if (photoUrl.count == 4){
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"Image4":photoUrl[3],@"IsFree":Freeclinic};
            
        }else if (photoUrl.count == 5){
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"Image4":photoUrl[3],@"Image5":photoUrl[4],@"IsFree":Freeclinic};
            
        }else if (photoUrl.count == 6){
           
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"Image4":photoUrl[3],@"Image5":photoUrl[4],@"Image6":photoUrl[5],@"IsFree":Freeclinic};
            
        }

        
    }else{
    
            if (photoUrl.count ==0) {
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"couponid":couponIDD,@"IsFree":Freeclinic};
        }else if(photoUrl.count ==1){
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"couponid":couponIDD,@"IsFree":Freeclinic};
            
        }else if(photoUrl.count ==2){
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"couponid":couponIDD,@"IsFree":Freeclinic};
            
        }else if(photoUrl.count ==3){
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"couponid":couponIDD,@"IsFree":Freeclinic};
            
        }else if (photoUrl.count == 4){
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"Image4":photoUrl[3],@"IsFree":Freeclinic};
            
        }else if (photoUrl.count == 5){
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"Image4":photoUrl[3],@"Image5":photoUrl[4],@"IsFree":Freeclinic};
            
        }else if (photoUrl.count == 6){
            
            parames = @{@"expert_ID":doctorID,@"user_ID":@(userID),@"consultationContent":consultationContent,@"OrderID":self.orderID,@"IsOpenImage":openStr,@"Image1":photoUrl[0],@"Image2":photoUrl[1],@"Image3":photoUrl[2],@"Image4":photoUrl[3],@"Image5":photoUrl[4],@"Image6":photoUrl[5],@"IsFree":Freeclinic};
            
        }
    }

    
    WS(ws);
//    [ws.delegate addOnCompletion:YES info:nil];
    [[FPNetwork POST:API_ADD_EXPERT_CONSULTATIONV2 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(addOnCompletion:info:)]){
            [ws.delegate addOnCompletion:response.success info:response.message];
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
            ws.orderID = dic[@"OrderID"];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(tradeIDOnCompletion:info:)]){
            [ws.delegate tradeIDOnCompletion:response.success info:response.message];
        }
    }];
}

- (void)getTradeID:(NSString*) bussinessType withPrice:(CGFloat) price withPayType:(NSString*) payType withCouponID:(NSNumber *)couponID{
    
    self.bussinessType = bussinessType;
    
    NSInteger userID = kCurrentUser.userId;
    
    NSDictionary* parames = @{@"UserID":@(userID),@"Price":[NSNumber numberWithFloat:price],@"Business":bussinessType,@"PayType":payType,@"couponID":couponID};
    WS(ws);
    
    [[FPNetwork POST:API_INSERT_PAYORDER withParams:parames] addCompleteHandler:^(FPResponse *response) {
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
    
    NSDictionary* parmas = @{@"UserID":@(userID),@"OrderID":self.orderID};
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
    NSString  *orderID = self.orderID;
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
    
    _voiceURL = url;
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
    [ProgressUtil showWithStatus:@"上传图片中..."];
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
            WSLog(@"======%@",uploadPathArr);
            if (uploadPathArr[0]) {
                [photoUrlArr addObject:uploadPathArr[0]];
                if (photoUrlArr.count ==photoArr.count) {
                    WSLog(@"photoUrl = %ld",photoUrlArr.count);
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

-(void)GetExpertCanConsumeCountWithExpertID:(NSNumber*)expertID{
    WS(ws);
     NSInteger userID = kCurrentUser.userId;
    [[FPNetwork POST: API_GET_EXPERTCANCONSUMECOUNT withParams:@{@"UserID":@(userID),@"Expert_ID":expertID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSLog(@"====咨询次数：%@",response.data);
            _Couponcount = response.data;
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetExpertCanConsumeCountOnCompletion:info:)]){
            [ws.delegate  GetExpertCanConsumeCountOnCompletion:response.success info:response.message];
        }
    }];
}
-(void)getCouPonList{
    
    WS(ws);
    [[FPNetwork POST: API_GET_MYCOUPONLIST withParams:@{@"UserID":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            NSLog(@"优惠券列表：%@",response.data);
            ws.CouPonSource = [CouponList  mj_objectArrayWithKeyValuesArray:response.data];
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetCouPonListCompletion:info:)]){
            [ws.delegate  GetCouPonListCompletion:response.success info:response.message];
        }
    }];
    
}

-(void)GetConsultationConsumptionCouponPriceWithCouponID:(NSNumber*)coupid  Expert_ID:(NSNumber*)expertID{
    [ProgressUtil show];

    WS(ws);
    [[FPNetwork POST: API_GET_CONSULATIONCONSUMPTIONCOUPON withParams:@{@"UserID":@(kCurrentUser.userId),@"CouponID":coupid,@"Expert_ID":expertID}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            NSLog(@"金额和状态：%@",response.data);
            if (response.data !=nil) {
                self.Status = [response.data[@"status"] integerValue];
                self.price = [response.data[@"price"]  floatValue];
            }else{
                
            }
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetConsultationCouponPriceCompletion:info:)]){
            [ws.delegate  GetConsultationCouponPriceCompletion:response.success info:response.message];
        }
    }];
}
-(void)GetConsumptionCouponWithcouponID:(NSNumber*)coupid  expert_ID:(NSNumber*)expertID  ConsultationID:(NSNumber*)consultationid{

    WS(ws);
    [[FPNetwork POST: API_GET_CONSUMPTIONCOUPON withParams:@{@"UserID":@(kCurrentUser.userId),@"CouponID":coupid,@"expert_ID":expertID,@"ConsultationID":consultationid}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetConsumptionCouponCompletion:info:)]){
            [ws.delegate  GetConsumptionCouponCompletion:response.success info:response.message];
        }
    }];

}
- (void)weixinPayOpenImage:(BOOL)isOpenImage PhotoArr:(NSArray *)photoArr Question:(NSString *)question DoctorId:(NSNumber *)doctorId{
    WS(ws);
    
    NSString *photoUrl;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:kCurrentUser.token forKey:@"token"];
    [parameters setObject:@(kCurrentUser.userId) forKey:@"userID"];
    [parameters setObject:@"questionBiz" forKey:@"type"];
    [parameters setObject:question forKey:@"consultContent"];
    [parameters setObject:doctorId forKey:@"id"];

    if (photoArr.count ==1) {
        photoUrl =photoArr[0];
        [parameters setObject:photoUrl forKey:@"imgArr"];

    }else if(photoArr.count ==2){
        photoUrl =[NSString stringWithFormat:@"%@,%@",photoArr[0],photoArr[1]];
        [parameters setObject:photoUrl forKey:@"imgArr"];

    }else if(photoArr.count ==3){
        photoUrl =[NSString stringWithFormat:@"%@,%@,%@",photoArr[0],photoArr[1],photoArr[2]];
        [parameters setObject:photoUrl forKey:@"imgArr"];

    }else if (photoArr.count == 4){
        photoUrl =[NSString stringWithFormat:@"%@,%@,%@,%@",photoArr[0],photoArr[1],photoArr[2],photoArr[3]];
        [parameters setObject:photoUrl forKey:@"imgArr"];
        
    }else if (photoArr.count == 5){
        photoUrl =[NSString stringWithFormat:@"%@,%@,%@,%@,%@",photoArr[0],photoArr[1],photoArr[2],photoArr
                   [3],photoArr[4]];
        [parameters setObject:photoUrl forKey:@"imgArr"];
        
    }else if (photoArr.count == 6){
        photoUrl =[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",photoArr[0],photoArr[1],photoArr[2],photoArr[3],photoArr[4],photoArr[5]];
        [parameters setObject:photoUrl forKey:@"imgArr"];
        
    }
    if (isOpenImage) {
        
        [parameters setObject:@"true" forKey:@"isPublic"];

    }else{
        
        [parameters setObject:@"false" forKey:@"isPublic"];

    }
    // CreateWxOrder
    [[FPNetwork GETtigerhuang007:@"createwxorderv3" withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        
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

- (void)weixinPayOpenImage:(BOOL)isOpenImage PhotoArr:(NSArray *)photoArr Question:(NSString *)question DoctorId:(NSNumber *)doctorId CouponID:(NSNumber *)couponID{
    WS(ws);
    
    NSString *photoUrl;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:kCurrentUser.token forKey:@"token"];
    [parameters setObject:@(kCurrentUser.userId) forKey:@"userID"];
    [parameters setObject:@"questionBiz" forKey:@"type"];
    [parameters setObject:question forKey:@"consultContent"];
    [parameters setObject:doctorId forKey:@"id"];
    [parameters setObject:@"true" forKey:@"useCoupon"];
    [parameters setObject:couponID forKey:@"couponID"];

    if (photoArr.count ==1) {
        photoUrl =photoArr[0];
        [parameters setObject:photoUrl forKey:@"imgArr"];
        
    }else if(photoArr.count ==2){
        photoUrl =[NSString stringWithFormat:@"%@,%@",photoArr[0],photoArr[1]];
        [parameters setObject:photoUrl forKey:@"imgArr"];
        
    }else if(photoArr.count ==3){
        photoUrl =[NSString stringWithFormat:@"%@,%@,%@",photoArr[0],photoArr[1],photoArr[2]];
        [parameters setObject:photoUrl forKey:@"imgArr"];
        
    }else if (photoArr.count == 4){
        photoUrl =[NSString stringWithFormat:@"%@,%@,%@,%@",photoArr[0],photoArr[1],photoArr[2],photoArr[3]];
        [parameters setObject:photoUrl forKey:@"imgArr"];
        
    }else if (photoArr.count == 5){
        photoUrl =[NSString stringWithFormat:@"%@,%@,%@,%@,%@",photoArr[0],photoArr[1],photoArr[2],photoArr
                   [3],photoArr[4]];
        [parameters setObject:photoUrl forKey:@"imgArr"];
        
    }else if (photoArr.count == 6){
        photoUrl =[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",photoArr[0],photoArr[1],photoArr[2],photoArr[3],photoArr[4],photoArr[5]];
        [parameters setObject:photoUrl forKey:@"imgArr"];
        
    }
    if (isOpenImage) {
        
        [parameters setObject:@"true" forKey:@"isPublic"];
        
    }else{
        
        [parameters setObject:@"false" forKey:@"isPublic"];
        
    }
    [[FPNetwork GETtigerhuang007:@"createwxorderv3" withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        
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



- (void)getCouponByCouponCode:(NSString *)code{
    WS(ws);
    
    [[FPNetwork POST:API_ClaimCouponByCouponCode withParams:@{@"userID":@(kCurrentUser.userId),@"CouponCode":code}] addCompleteHandler:^(FPResponse *response) {
        if(response.status ==200){
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetCouponByCouponCodeCompletion: info:)]){
                [ws.delegate  GetCouponByCouponCodeCompletion:YES info:response.message];
            }
            
        }else if(response.status ==500){
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetCouponByCouponCodeCompletion: info:)]){
                [ws.delegate  GetCouponByCouponCodeCompletion:NO info:response.message];
            }
            
        }else {
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(GetCouponByCouponCodeCompletion: info:)]){
                [ws.delegate  GetCouponByCouponCodeCompletion:NO info:@"网络不可用,请重试"];
            }
        }
    }];
}


- (void)getExpertCommentListByExpertID:(NSNumber *)expertID{
    WS(ws);
    [[FPNetwork POST:API_GetExpertCommentList withParams:@{@"ExpertID":expertID}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success == YES) {
            ws.myCommentListDataSource = [ExpertCommentListEntity mj_objectArrayWithKeyValuesArray:response.data];
            if (ws.myCommentListDataSource.count!=0) {
                ws.myCommentListEntity = ws.myCommentListDataSource.firstObject;
                ws.myCommentListEntity.TotalCount =@(response.totalCount);
            }
            
            if (ws.delegate && [ws.delegate respondsToSelector:@selector(getExpertCommentListSuccess)]) {
                [ws.delegate getExpertCommentListSuccess];
            }
        }else{
            [ProgressUtil showError:response.message?response.message:@"网络不可用,请重试"];

        }
    }];
}
#pragma mark---  判断是否是医生
- (void)getExperIDByUserID:(isDoctor) block{
    [ProgressUtil show];
    [[FPNetwork POST:API_GET_EXPERID_BY_USERID withParams:@{@"userid":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.data) {
            [ProgressUtil dismiss];
            if ([response.data count] == 0) {
                //非医生
                block(NO,nil);
                
                //                block(YES,@"1");//模拟医生
                
            }else{
                //医生
                NSDictionary *dic = ((NSArray *)response.data).firstObject;
                NSString *doctorID = [NSString stringWithFormat:@"%@",dic[@"ExperID"]];
                //保存医生ID到本地
                kCurrentUser.expertID = [NSNumber numberWithInteger:[doctorID integerValue]];
                
                block(YES,doctorID);
            }
        }else{
            [ProgressUtil showError:response.message];

        }
    }];
}

@end
