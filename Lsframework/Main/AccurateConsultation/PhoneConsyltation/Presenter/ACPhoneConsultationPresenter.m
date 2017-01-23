//
//  ACPhoneConsultationPresenter.m
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ACPhoneConsultationPresenter.h"
#import "UIImage+Category.h"

@interface ACPhoneConsultationPresenter ()



@end

@implementation ACPhoneConsultationPresenter

-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}


-(void)getBabyArchives{
    NSDictionary* parames = @{@"userID":@(kCurrentUser.userId)};
    
    WS(ws);
    [[FPNetwork POST:API_PHONE_QUERY_BABY_ARCHIVESLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"data=%@",response.data);
    
        if(response.success){
            NSArray* dataArray = response.data;
            for(NSDictionary* dic in dataArray){
                BabayArchList* baby = [BabayArchList mj_objectWithKeyValues:dic];
                [ws.dataSource addObject:baby];
            }
            [ws.delegate onCompletation:YES info:response.message];
        }else{
            [ws.delegate onCompletation:NO info:response.message];
        }
    }];
}

- (void)uploadDescriptionDiseaseImage:(NSMutableArray *)urls{
    
    NSMutableArray* formDataArray=[NSMutableArray arrayWithCapacity:urls.count];
    for(NSString* url in urls){
        FormData* formData = [FormData new];
        UIImage* image = [UIImage imageWithContentsOfFile:url];
        formData.data = [image resetSizeOfImageData:image maxSize:500];
        formData.fileName=@"file.png";
        formData.name=@"file";
        formData.mimeType=@"image/png";
        [formDataArray addObject:formData];
    }
    
    WS(ws);
    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:formDataArray] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSDictionary* data = [response.data dictionary];
            NSMutableString* uploadPath = [data[@"Result"] getUploadPath];
            ws.uploadPath = uploadPath;
            NSLog(@"uploadPath=%@",uploadPath);
        }
        
        [ws.delegate uploadImageCompletation:response.success];
        
    }];
}

- (void)commitPhoneConsultation{
    
    //孩子姓名
    if(self.babyName.length==0){
        [self.delegate commitCompletation:NO info:@"请选择孩子姓名"];
        return ;
    }
    //所患疾病
    if([self.diseaseName trimming].length==0){
        self.diseaseName=@"";
    }
    //病情描述
    if([self.descriptionDisease trimming].length==0){
        self.descriptionDisease=@"";
    }
    //病情描述图片
    if(self.descriptionDiseaseImage.length==0){
        self.descriptionDiseaseImage=@"";
    }
    
    
    NSDictionary* parames = @{@"UserID":@(self.userID),
                              @"BabyName":self.babyName,
                              @"DiseaseName":self.diseaseName,
                              @"DescriptionDisease":self.descriptionDisease,
                              @"DescriptionDiseaseImage":self.descriptionDiseaseImage,
                              @"AskDoctor":@(self.askDoctorID),
                              @"FeeNormal":self.feeNormal,
                              @"FeeUnit":self.feeUnit,
                              @"FeeSequence":@(self.feeSequence),
                              @"FeeTime":self.feeTime};
    WS(ws);
    [[FPNetwork POST:API_PHONE_ADD_TEL_CONSULTATION withParams:parames] addCompleteHandler:^(FPResponse *response) {
       
        [ws.delegate commitCompletation:response.success info:response.message];
        
    }];
    
    
    
    
}



@end
