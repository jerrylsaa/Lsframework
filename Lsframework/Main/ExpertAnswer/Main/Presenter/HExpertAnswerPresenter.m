//
//  HExpertAnswerPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HExpertAnswerPresenter.h"

@interface HExpertAnswerPresenter (){
    NSInteger _page;
}

@property(nonatomic,retain) NSMutableArray* expertDataSource;
@property(nonatomic,retain) DataTaskManager* requestManager;
@end

@implementation HExpertAnswerPresenter

-(instancetype)init{
    self= [super init];
    if(self){
        _page = 1;
        self.requestManager = [DataTaskManager new];
        self.hospitalDataSource =@[@"默认排序",@"咨询由多到少",@"价格由低到高",@"回复由快到慢",@"值班医生",@"位置由近到远"];
    }
    return self;
}


- (void)loadExpertHospital{
    NSDictionary* parames = @{@"userid":@(kCurrentUser.userId)};
    WS(ws);
    [[FPNetwork POST:@"GetExpertHospitalNameList" withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSMutableArray* array = [ExpertHospitalEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.hospitalDataSource];
                [result addObjectsFromArray:array];
                ws.hospitalDataSource = nil;
                ws.hospitalDataSource = result;
            }
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetHospitalCompletion:info:)]){
            [ws.delegate onGetHospitalCompletion:response.success info:response.message];
        }
        
    }];
}

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

-(void)loadExpertData{
    [ProgressUtil show];
    NSMutableArray* requestArray = [NSMutableArray array];
    _page = 1;

    if(self.dataSource){
        self.dataSource = nil;
    }
    
    NSDictionary *parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId)};
    
    if (_hospitalName!=0&&_hospitalName!=1) {
        
        if (_officeName!=nil&&_officeName.length!=0) {
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"orderIndex":@(_hospitalName),@"departName":_officeName,@"userid":@(kCurrentUser.userId)};
        }else {
     if (_hospitalName==10) {
        if (self.longitude.length==0||self.longitude==nil) {
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"orderIndex":@(_hospitalName),@"departName":@"",@"userid":@(kCurrentUser.userId),@"X":@"",@"Y":@""};
        }else{
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"orderIndex":@(_hospitalName),@"departName":@"",@"userid":@(kCurrentUser.userId),@"Y":self.longitude,@"X":self.latitude};
        }
  
     }else{
     
    parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"orderIndex":@(_hospitalName),@"departName":@"",@"userid":@(kCurrentUser.userId)};
     
     
     }
       }
    }else {
        if (_officeName!=nil&&_officeName.length!=0) {
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"departName":_officeName,@"userid":@(kCurrentUser.userId)};
        }
    }
    WS(ws);
    FPNetwork* infoRequest = [[FPNetwork POST:API_GET_EXPERTDOCTOR_INFOV4 withParams:parames] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
        [ws.requestManager countDown];
        
        if(response.success){
            ws.dataSource = [ExpertAnswerEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
        [ProgressUtil dismiss];

    }];
    [requestArray addObject:infoRequest];
    
    
    //获取banner
//    NSDictionary* bannerParames = @{@"type":@1};
//    FPNetwork* bannerRequest = [[FPNetwork POST:API_GET_BANNER_LIST withParams:bannerParames] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
//        [ws.requestManager countDown];
//        
//        if(response.success){
//            NSDictionary* dic = [response.data firstObject];
//            ws.bannerURL = [dic objectForKey:@"PicUrl"];
//            
//        }
//        
//        if(ws.delegate && [ws.delegate respondsToSelector:@selector(bannerOnCompletion:info:)]){
//            [ws.delegate bannerOnCompletion:response.success info:nil];
//        }
//    }];
//    
//    [requestArray addObject:bannerRequest];
    
    [_requestManager requestWithDataTasks:requestArray withComplete:^{
        
    }];
    
    
}

-(void)loadMoreExpertData{
    [ProgressUtil show];
    _page++;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId)};
    if (_hospitalName!=0&&_hospitalName!=1) {
        
        if (_officeName!=nil&&_officeName.length!=0) {
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"orderIndex":@(_hospitalName),@"departName":_officeName,@"userid":@(kCurrentUser.userId)};
        }else {
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"orderIndex":@(_hospitalName),@"departName":@"",@"userid":@(kCurrentUser.userId)};
        }
    }else {
        if (_officeName!=nil&&_officeName.length!=0) {
            parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"departName":_officeName,@"userid":@(kCurrentUser.userId)};
        }
    }
    
    WS(ws);
    [[FPNetwork POST:API_GET_EXPERTDOCTOR_INFOV4 withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
           NSMutableArray* array = [ExpertAnswerEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.dataSource];
                [result addObjectsFromArray:array];
                ws.dataSource = nil;
                ws.dataSource = result;
            }else{
                ws.noMoreData = YES;
            }
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(MoreOnCompletion:info:)]){
            [ws.delegate MoreOnCompletion:response.success info:response.message];
        }
        [ProgressUtil dismiss];

    }];

}

- (void)getExperIDByUserID:(isDoctor) block{
    
    [[FPNetwork POST:API_GET_EXPERID_BY_USERID withParams:@{@"userid":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.data) {
            
            if ([response.data count] == 0) {
                //非医生
                block(NO,nil);
                
                //                block(YES,@"1");//模拟医生
                
            }else{
                //医生
                NSDictionary *dic = ((NSArray *)response.data).firstObject;
                NSString *doctorID = [NSString stringWithFormat:@"%@",dic[@"ExperID"]];
                block(YES,doctorID);
            }
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
}

-(void)loadMyBindHospitalData{
    [ProgressUtil show];
    NSMutableArray* requestArray = [NSMutableArray array];
    _page = 1;
    
    if(self.myBindDataSource){
        self.myBindDataSource = nil;
    }
    
    NSDictionary *parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId)};
    
    WS(ws);
    FPNetwork* infoRequest = [[FPNetwork POST:API_getmyhospitallist withParams:parames] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
        [ws.requestManager countDown];
        
        if(response.success){
            ws.myBindDataSource = [ExpertAnswerEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
        [ProgressUtil dismiss];
        
    }];
    [requestArray addObject:infoRequest];
    
    
    [_requestManager requestWithDataTasks:requestArray withComplete:^{
        
    }];
}

-(void)loadMoreMyBindHospitalData{
    [ProgressUtil show];
    _page++;
    
    NSDictionary* parames = @{@"PageIndex":@(_page),@"PageSize":@(kPageSize),@"userid":@(kCurrentUser.userId)};
   
    
    WS(ws);
    [[FPNetwork POST:API_getmyhospitallist withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSMutableArray* array = [ExpertAnswerEntity mj_objectArrayWithKeyValuesArray:response.data];
            
            if(array.count != 0){
                NSMutableArray* result = [NSMutableArray arrayWithArray:ws.myBindDataSource];
                [result addObjectsFromArray:array];
                ws.myBindDataSource = nil;
                ws.myBindDataSource = result;
            }else{
                ws.noMoreData = YES;
            }
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(MoreOnCompletion:info:)]){
            [ws.delegate MoreOnCompletion:response.success info:response.message];
        }
        [ProgressUtil dismiss];
        
    }];
    
}

- (void)setHospitalName:(NSInteger)hospitalName{
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

@end
