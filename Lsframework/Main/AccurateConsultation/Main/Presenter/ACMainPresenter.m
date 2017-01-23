//
//  ACMainPresenter.m
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ACMainPresenter.h"
#import "DataTaskManager.h"
#import "MJExtension.h"


@interface ACMainPresenter ()

@property (nonatomic ,assign)int page;






@end

@implementation ACMainPresenter

- (instancetype)init{
    self = [super init];
    if(self){
        //
        _page = 1;
    }
    return self;
}

#pragma mark -

-(void)loadHospitalWith:(NSString *)cityName{
    //拉取当前市的医院
    NSString* cityID = [CityEntity findCityID:cityName];
    
    NSDictionary* hospitalParames = @{@"City":cityID};
    WS(ws);
    [[FPNetwork POST:API_PHONE_QUERY_HOSPITAL withParams:hospitalParames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSArray* data = response.data;
            NSMutableArray *hospitalArray = [NSMutableArray array];
            for(NSDictionary* dic in data){
                NSMutableDictionary* hdic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [hdic setObject:cityID forKey:@"cityId"];
                [hospitalArray addObject:hdic];
            }
            ws.hospitalDataSource = hospitalArray;
            
            [HospitalEntity MR_truncateAll];
            //将医院保存到数据库中
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                [HospitalEntity mj_objectArrayWithKeyValuesArray:hospitalArray context:localContext];
            }];
        }
        
        if(ws.aCMaindelegate && [ws.aCMaindelegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.aCMaindelegate onCompletion:response.success info:response.message];
        }

    }];
}

-(void)loadHospatialDepart:(NSInteger)hospatialID{
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
            
            ws.departDataSource = result;
            
            [DepartmentEntity MR_truncateAll];
            //将医院科室保存到数据库中
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                [DepartmentEntity mj_objectArrayWithKeyValuesArray:result context:localContext];
            }];

        }
        
        if(ws.aCMaindelegate && [ws.aCMaindelegate respondsToSelector:@selector(departOnCompletion:info:)]){
            [ws.aCMaindelegate departOnCompletion:response.success info:response.message];
        }
        
    }];

    
}

-(void)loadDoctorDta{
    NSLog(@"%@---%@---%@---%@",self.provinceId,self.cityId,self.hospitalId,self.departId);
    
    if ([self.hospitalId integerValue]==1){
        NSLog(@"下拉儿童医院");
        NSLog(@"跳转儿童医院1");
        if(self.aCMaindelegate && [self.aCMaindelegate respondsToSelector:@selector(loadChildrenH5Ctrl)]){
            [self.aCMaindelegate loadChildrenH5Ctrl];
            return;
        }
    }
    
    
    
    [self.doctorDataSource removeAllObjects];
    _page = 1;

    NSNumber *provinceId;
    NSString *cityId;
    NSNumber *hospitalId;
    NSNumber *departId;
    
    provinceId = self.provinceId;
    cityId = self.cityId;
    hospitalId = self.hospitalId;
    departId = self.departId;

    NSDictionary* params = @{@"Province":provinceId, @"City":cityId, @"Hospital":hospitalId, @"Department":departId, @"PageIndex":[NSNumber numberWithInt:_page], @"PageSize":@(kPageSize)};
    WS(ws);
    [[FPNetwork POST:API_PHONE_QueryDOC_AC withParams:params] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.doctorDataSource = [DoctorList mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.aCMaindelegate && [ws.aCMaindelegate respondsToSelector:@selector(doctorOnCompletion:info:)]){
            [ws.aCMaindelegate doctorOnCompletion:response.success info:response.message];
        }
        
    }];
}

-(void)loadMoreDoctroDtaa{
    _page ++;

    NSNumber *provinceId;
    NSString *cityId;
    NSNumber *hospitalId;
    NSNumber *departId;
    
    provinceId = self.provinceId;
    cityId = self.cityId;
    hospitalId = self.hospitalId;
    departId = self.departId;

    NSDictionary* params = @{@"Province":provinceId, @"City":cityId, @"Hospital":hospitalId, @"Department":departId, @"PageIndex":[NSNumber numberWithInt:_page], @"PageSize":@(kPageSize)};
    WS(ws);
    [[FPNetwork POST:API_PHONE_QueryDOC_AC withParams:params] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSArray*  doctorsTmp = [DoctorList mj_objectArrayWithKeyValuesArray:response.data];
            NSMutableArray* result = [NSMutableArray arrayWithArray:[ws.doctorDataSource copy]];

            
            if(doctorsTmp.count == 0){
            //没有更多数据了
                ws.noMoreData = YES;
            }else{
                [result addObjectsFromArray:doctorsTmp];
                ws.doctorDataSource = nil;
                ws.doctorDataSource = result;
            }
        }
        
        if(ws.aCMaindelegate && [ws.aCMaindelegate respondsToSelector:@selector(doctorMoreDataOnCompletion:info:)]){
            [ws.aCMaindelegate doctorMoreDataOnCompletion:response.success info:response.message];
        }
    
    }];

    
}



@end
