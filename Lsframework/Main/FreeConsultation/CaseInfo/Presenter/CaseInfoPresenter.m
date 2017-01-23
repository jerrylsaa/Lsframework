//
//  CaseInfoPresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CaseInfoPresenter.h"
#import "UIImage+Category.h"


@implementation CaseInfoPresenter

- (instancetype)init{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (void)commitCaseInfo:(CaseInfo *) caseInfo{
    caseInfo.babyName = _currentSelectedChildInfo.childName;
    self.caseInfo = caseInfo;
    if (!caseInfo.babyName || caseInfo.babyName.length == 0) {
        [_delegate commitCaseInfoSuccess:NO info:@"请选择宝宝"];
        return;
    }
    if(!self.hasChoseDisease){
        [_delegate commitCaseInfoSuccess:NO info:@"请选择所患疾病"];
        return;

    }
    
//    if (caseInfo.isKnowDiseaseName && (!caseInfo.diseaseName || caseInfo.diseaseName.length == 0)) {
//        [_delegate commitCaseInfoSuccess:NO info:@"请输入所患疾病名字"];
//        return;
//    }
    
    if (!caseInfo.bellDate || caseInfo.bellDate.length == 0) {
        [_delegate commitCaseInfoSuccess:NO info:@"请选择患病时间"];
        return;
    }
    if (caseInfo.isInspect == -1) {
        [_delegate commitCaseInfoSuccess:NO info:@"请选择是否检查"];
        return;
    }
    
    if (!caseInfo.inspectionData) {
        [_delegate commitCaseInfoSuccess:NO info:@"请填写检查资料"];
        return;
    }
    if (_caseInfoType == CaseInfoTypeFree)
        if (caseInfo.askDepart == -2) {
            [_delegate commitCaseInfoSuccess:NO info:@"请选择是否需要咨询科室"];
            return;
        }
    if (_caseInfoType != CaseInfoTypeQuick) {
        /*
         if (!caseInfo.descriptionDisease || caseInfo.descriptionDisease.length == 0) {
         [_delegate commitCaseInfoSuccess:NO info:@"请填写病情描述"];
         return;
         }
         if (!caseInfo.drugAndInspect || caseInfo.drugAndInspect.length == 0) {
         [_delegate commitCaseInfoSuccess:NO info:@"请填写药物使用或其它治疗情况"];
         return;
         }
         
         if (!caseInfo.descriptionDiseaseAudio || caseInfo.descriptionDiseaseAudio.length == 0) {
         [_delegate commitCaseInfoSuccess:NO info:@"请上传病情描述语音"];
         return;
         }
         if (!caseInfo.descriptionDiseaseImage || caseInfo.descriptionDiseaseImage.length == 0) {
         [_delegate commitCaseInfoSuccess:NO info:@"请上传病情描述图片"];
         return;
         }
         if (!caseInfo.drugAndInspectAudio || caseInfo.descriptionDiseaseImage.length == 0) {
         [_delegate commitCaseInfoSuccess:NO info:@"请输入病情描述图片"];
         return;
         }
         */
        
    }
    
    [ProgressUtil show];
    if (self.imageArray && self.imageArray.count > 0) {
        [self uploadImage:self.imageArray];
    }else{
        self.imagePath = @"";
        [self commit];
    }
    
}

- (void)uploadImage:(NSArray *)imageArray{
    WS(ws);
    NSMutableArray * array = [NSMutableArray new];
    for (int i = 0; i < imageArray.count ; i ++) {
        NSString *imagePath  = imageArray[i];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        FormData * formData = [FormData new];
        formData.data = [image resetSizeOfImageData:image maxSize:500];
        formData.fileName = @"file.png";
        formData.name = @"file";
        formData.mimeType = @"image/png";
        [array addObject:formData];
    }
//    [ProgressUtil showInfo:[NSString stringWithFormat:@"正在上传图片"]];
    [[FPNetwork POST:nil withParams:nil withFormDatas:array] addCompleteHandler:^(FPResponse *response) {
        if (response.status == 200) {
//            NSData * data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSString *reciveStr = [jsonDict objectForKey:@"Result"];
            //"2.73 M|file.png|/attach_upload/201604/07/201604071329513820.png,"
//            NSArray *array = [reciveStr componentsSeparatedByString:@"|"];
//            NSString *str = ((NSString *)array[2]);
//            NSString * realStr = [str substringToIndex:str.length - 1];
//            if (weakSelf.imagePath.length == 0) {
//                weakSelf.imagePath = realStr;
//            }else{
//                weakSelf.imagePath = [NSString stringWithFormat:@"%@|%@",self.imagePath,realStr];
//            }
//            weakSelf.imagePath = reciveStr;
//            
//            [ProgressUtil showSuccess:@"图片上传成功"];
//            //跳转到上传全部数据
//            [weakSelf commit];
            
            NSDictionary* data=[response.data dictionary];
            NSMutableString* uploadPath=[data[@"Result"] getUploadPath];
            NSLog(@"uploadPath=%@",uploadPath);
            ws.imagePath = uploadPath;
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onUploadCompletion:info:)]){
            [ws.delegate onUploadCompletion:response.success info:response.message];
        }
    }];
    
}

- (void)commit{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(kCurrentUser.userId) forKey:@"UserID"];
    [parameters setObject:self.caseInfo.babyName forKey:@"BabyName"];
    //所患疾病
    NSString* diseaseName = nil;
    if(self.caseInfo.isKnowDiseaseName){
        diseaseName = self.caseInfo.diseaseName;
    }else{
        diseaseName = @"";
    }
    [parameters setObject:diseaseName forKey:@"DiseaseName"];
    //患病时间
    [parameters setObject:self.caseInfo.bellDate forKey:@"BeIllDate"];
    //是否检查
    [parameters setObject:[NSNumber numberWithInt:self.caseInfo.isInspect] forKey:@"IsInspect"];
    //病情描述
    NSString* descriptionDisease = nil;
    if(self.caseInfo.descriptionDisease.length != 0){
        descriptionDisease = self.caseInfo.descriptionDisease;
    }else{
        descriptionDisease = @"";
    }
    [parameters setObject:descriptionDisease forKey:@"DescriptionDisease"];
    //病情描述语音
//    if(self.caseInfo.descriptionDiseaseAudio.length != 0){
//        [parameters setObject:self.caseInfo.descriptionDiseaseAudio forKey:@"DescriptionDiseaseAudio"];
//    }else{
//        [parameters setObject:@"" forKey:@"DescriptionDiseaseAudio"];
//    }
    [parameters setObject:@"" forKey:@"DescriptionDiseaseAudio"];

    //病情描述图片
//    if(self.caseInfo.descriptionDiseaseImage.length != 0){
//        [parameters setObject:self.caseInfo.descriptionDiseaseImage forKey:@"DescriptionDiseaseImage"];
//    }else{
//        [parameters setObject:@"" forKey:@"DescriptionDiseaseImage"];
//    }
    [parameters setObject:@"" forKey:@"DescriptionDiseaseImage"];

    //药品使用和其它治疗情况
    if (self.caseInfo.drugAndInspect.length != 0){
        [parameters setObject:self.caseInfo.drugAndInspect forKey:@"DrugAndInspect"];
    }else{
        [parameters setObject:@"" forKey:@"DrugAndInspect"];
    }
    //药品使用和其它治疗情况(语音)
//    if(self.caseInfo.drugAndInspectAudio.length !=0 ){
//        [parameters setObject:self.caseInfo.drugAndInspectAudio forKey:@"DrugAndInspectAudio"];
//    }else{
//        [parameters setObject:@"" forKey:@"DrugAndInspectAudio"];
//    }
    [parameters setObject:@"" forKey:@"DrugAndInspectAudio"];

    //检查资料
    if (self.caseInfo.inspectionData.length !=0){
        [parameters setObject:self.caseInfo.inspectionData forKey:@"InspectionData"];
    }else{
        [parameters setObject:@"" forKey:@"InspectionData"];
    }
    //检查资料(图片)
    if(self.imagePath.length != 0){
        [parameters setObject:self.imagePath forKey: @"InspectionDataImage"];
    }else{
        [parameters setObject:@"" forKey: @"InspectionDataImage"];
    }
    //咨询医生
    NSString* doctorID = nil;
    if(self.caseInfo.doctorId.length != 0){
        doctorID = self.caseInfo.doctorId;
    }else{
        doctorID = @"";
    }
    [parameters setValue:doctorID forKey:@"AskDoctor"];
    //咨询的科室
    [parameters setObject: @(self.caseInfo.askDepart) forKey:@"AskDepart"];
    //是否咨询过此医生
    [parameters setObject:@"" forKey:@"IsAskDoctor"];

    NSLog(@"%@",parameters);
    WS(ws);
    [[FPNetwork POST:API_PHONE_ADD_CONSULTATION withParams:parameters] addCompleteHandler:^(FPResponse* response) {
        NSLog(@"===%@",response.data);
        if (response != nil) {
            if (response.isSuccess) {
                ws.orderNum = response.data[@"OrderNum"];
                ws.resultId = response.data[@"ResultID"];
                if ([self.delegate respondsToSelector:@selector(commitCaseInfoSuccess:info:)]) {
                    [self.delegate commitCaseInfoSuccess:YES info:@"添加成功"];
                }
            }else{
                //                if (self.delegate respondsToSelector:@selector(commitCaseInfoSuccess:info:)) {
                //                    [self.delegate commitCaseInfoSuccess:NO info:@"添加"];
            }
        }
    }];
    
}

-(void)getChildInfo{
    [[FPNetwork GET:API_PHONE_QUERY_BABY_ARCHIVES_LIST withParams:@{@"userID":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        if (response.isSuccess) {
            _childInfos = [ChildEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        [_delegate onnGetChildInfosComplete];
    }];
}

-(void)commitConsultaion{
    [self commit];
}

@end
