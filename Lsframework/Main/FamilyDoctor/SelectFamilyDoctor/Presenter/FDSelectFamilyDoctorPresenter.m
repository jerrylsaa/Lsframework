//
//  FDSelectFamilyDoctorPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDSelectFamilyDoctorPresenter.h"

#define kPageSize 20

@interface FDSelectFamilyDoctorPresenter (){

}

@property(nonatomic,copy) NSString* ccity;
@property(nonatomic,copy) NSString* cityID;
@property(nonatomic,copy) NSString* provinceID;

@end

@implementation FDSelectFamilyDoctorPresenter

-(void)loadDoctorData:(NSString *)proVince City:(NSString *)city{
    self.ccity = city;
    //获取省ID
   NSString* provinceID = [ProvinceEntity findProvinceID:proVince];
    if(provinceID && provinceID.length !=0){
        self.provinceID = provinceID;
    }else{
    //否则省id获取失败，加载本地数据库重新获取
        self.provinceID = @"";
        //        NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"txt"];
        //        if(path.length !=0){
        //            NSArray* array = [NSArray arrayWithContentsOfFile:path];
        //
        //        }
    }
    
    //获取市ID
    NSString* cityID = [CityEntity findCityID:city];
    if(cityID && cityID.length != 0 ){
        self.cityID = cityID;
    }else{
    //城市id获取失败，重新获取
        self.cityID = @"";
    }

    //获取医生列表
    NSDictionary* parames =  @{@"Province":self.provinceID, @"City":self.cityID, @"Hospital":@"", @"Department":@"", @"PageIndex":@1, @"PageSize":@(kPageSize)};
    [self getDoctorList:parames];
}

/**
 *  获取医生列表
 */
- (void)getDoctorList:(NSDictionary*) parames{
    self.request = [DataTaskManager new];
    NSMutableArray* array = [NSMutableArray array];
    WS(ws);
    __weak typeof(self.request) weakSync = self.request;
    
   //拉取医生列表
   FPNetwork* doctorList = [[FPNetwork POST:API_QUERY_PACKAGEDOCTOR withParams:parames] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
       [weakSync countDown];
       
       if(response.success){
           NSArray* data = response.data;
           ws.dataSource =[DoctorList mj_objectArrayWithKeyValuesArray:data];
       }
       
       if(ws.delegate && [ws.delegate respondsToSelector:@selector(fetchFamilyDoctorData:info:)]){
           [ws.delegate fetchFamilyDoctorData:response.success info:response.message];
       }
    }];
    [array addObject:doctorList];
    
   //拉取当前市的医院
    NSDictionary* hospitalParames = @{@"City":self.cityID};
   FPNetwork* hospital = [[FPNetwork POST:API_PHONE_QUERY_HOSPITAL withParams:hospitalParames] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
       [weakSync countDown];
       
       if(response.success){
           //判断数据库是否有这个医院如果没有就保存到数据库，否则就不保存
           NSArray* cityList = [CityEntity MR_findByAttribute:@"ssqName" withValue:self.ccity];
           CityEntity* city = [cityList firstObject];
           NSArray* hospitalList = [HospitalEntity MR_findByAttribute:@"cityId" withValue:city.ssqId];
           if(hospitalList.count != 0){
               return ;
           }
           NSArray* data = response.data;
           NSMutableArray *hospitalArray = [NSMutableArray array];
           for(NSDictionary* dic in data){
               NSMutableDictionary* hdic = [NSMutableDictionary dictionaryWithDictionary:dic];
               [hdic setObject:self.cityID forKey:@"cityId"];
               [hospitalArray addObject:hdic];
           }
           //将医院保存到数据库中
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
               [HospitalEntity mj_objectArrayWithKeyValuesArray:hospitalArray context:localContext];
           }];
       }
    }];
    [array addObject:hospital];
    
    [self.request requestWithDataTasks:array withComplete:^{
        
    }];
}



- (void)loadHospatialDepart:(NSInteger)hospatialID{
    //拉取科室
    WS(ws);
    NSDictionary* departParames = @{@"HospitalID":@(hospatialID)};
    
    [[FPNetwork POST:API_PHONE_QUERY_DEPART withParams:departParames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSArray* data = response.data;
            //将医院id导入到科室的表中
            NSMutableArray* result = [NSMutableArray arrayWithCapacity:data.count];
            
            for(NSDictionary* dic in data){
                NSMutableDictionary* mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [mutableDic setObject:@(hospatialID) forKey:@"hospitalId"];
                [result addObject:mutableDic];
            }
            
            [DepartmentEntity mj_objectArrayWithKeyValuesArray:result context:[NSManagedObjectContext MR_defaultContext]];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            ws.departSource = [DepartmentEntity findDepartNameWithHospatialID:hospatialID];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletionDepart:info:)]){
            [ws.delegate onCompletionDepart:response.success info:response.message];
        }

    }];
    
}






@end
