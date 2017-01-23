//
//  BookingDatePresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BookingDatePresenter.h"
#import "DataTaskManager.h"

@interface BookingDatePresenter ()<ZHCityPickerDelegate>

@property (nonatomic ,strong)ZHCityPicker *cityPicker;
@property (nonatomic ,strong)NSArray *cityArray;
@property (nonatomic ,assign)int page;

@end


@implementation BookingDatePresenter
- (instancetype)init{
    self = [super init];
    if(self){
        //
        _page = 1;
    }
    return self;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (ZHCityPicker *)cityPicker{
    if (!_cityPicker) {
        _cityPicker = [ZHCityPicker new];
        _cityPicker.delegate = self;
    }
    return _cityPicker;
}
//显示省市picker
- (void)showPickerInView:(UIView *)view{
    
    [self.cityPicker showInView:view];
}
//隐藏省市picker
- (void)dismissPicker{
    [self.cityPicker dismiss];
}
//根据省市拉取医院数据
- (void)loadHospitalDataWith:(Compelte)block{
    if (!self.city || [self.city.ssqId intValue] == 0) {
        [ProgressUtil showInfo:@"请先选择省市"];
        block(NO);
        return;
    }
    //限制最大存储数目
    [HospitalEntity MR_truncateAll];
    if ([HospitalEntity MR_findAll].count >= 1000) {
        [HospitalEntity MR_truncateAll];
    }
    
    //查询是否有符合条件的医院
    self.hospitalArray = [HospitalEntity MR_findByAttribute:@"cityId" withValue:self.city.ssqId];
    //请求数据并存入数据库
    if (self.hospitalArray.count == 0) {
        
        NSDictionary *parameters= [NSDictionary dictionaryWithObject:self.city.ssqId forKey:@"City"];
        [[FPNetwork POST:API_PHONE_QUERY_HOSPITAL withParams:parameters] addCompleteHandler:^(FPResponse *response) {
            //插入查询条件省份id
            NSArray *responseArray = response.data;
            if (responseArray.count > 0) {
                NSMutableArray *dataArray = [NSMutableArray array];
                for (NSDictionary *subDic in response.data) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:subDic];
                    [dic setObject:self.city.ssqId forKey:@"cityId"];
                    [dic setObject:subDic[@"HName"] forKey:@"hName"];
                    [dataArray addObject:dic];
                }
                NSArray *array = [HospitalEntity mj_objectArrayWithKeyValuesArray:dataArray context:[NSManagedObjectContext MR_defaultContext]];
                self.hospitalArray = array;
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                block(YES);
            }
        }];
        //
    }else{
        NSLog(@"");
        block(YES);
    }
}
//根据省市医院拉取科室列表数据
- (void)loadDepartmentDataWith:(Compelte)block{
    //此处应该判断hospital的医院id是否存在
    if (!self.hospital ) {
        [ProgressUtil showInfo:@"请先选择医院"];
        block(NO);
        return;
    }
    //限制最大存储数目
    //    [DepartmentEntity MR_truncateAll];
    if ([DepartmentEntity MR_findAll].count >= 1000) {
        [DepartmentEntity MR_truncateAll];
    }
    //查询是否有符合条件的医院 //筛选条件待定，默认为0
    NSArray *sortArray = [DepartmentEntity MR_findByAttribute:@"hospitalId" withValue:self.hospital.keyid];
    self.departmentArray = [sortArray sortedArrayUsingComparator:^NSComparisonResult(DepartmentEntity *obj1, DepartmentEntity *obj2) {
        return [obj1.keyId compare:obj2.keyId];
    }];
    WS(ws);
    //请求数据并存入数据库
    if (self.departmentArray.count == 0) {
        NSDictionary *parameters= [NSDictionary dictionaryWithObject:self.hospital.keyid forKey:@"HospitalID"];
        [[FPNetwork POST:API_PHONE_QUERY_DEPART withParams:parameters] addCompleteHandler:^(FPResponse *response) {
            //插入查询条件医院id
            runOnBackground(^{
                NSMutableArray *dataArray = [NSMutableArray array];
                for (NSDictionary *subDic in response.data) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:subDic];
                    //插入医院id,处理关键字,首字母转小写
                    [dic setObject:self.hospital.keyid forKey:@"hospitalId"];
                    NSDictionary *subDic = [NSDictionary dictionaryWithDictionary:dic];
                    [dataArray addObject:subDic];
                }
                NSArray * array = [DepartmentEntity mj_objectArrayWithKeyValuesArray:dataArray context:[NSManagedObjectContext MR_defaultContext]];
                ws.departmentArray = array;
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                    if (!error) {
                        
                        NSArray *sortArray = [DepartmentEntity MR_findAll];
                        ws.departmentArray = [sortArray sortedArrayUsingComparator:^NSComparisonResult(DepartmentEntity *obj1, DepartmentEntity *obj2) {
                            return [obj1.keyId compare:obj2.keyId];
                        }];
                        
                        block(YES);
                    }
                }];
                
            });
        }];
        
    }else{
        block(YES);
    }
}


//拉取定位省市数据
- (void)locationWithBlock:(LocationManagerBlcok)block{
    WS(ws);
    [[LocationManager shareInstance] getProvinceAndCityWithBlock:^(NSString * province, NSString * city,NSString * longitude, NSString * latitude, BOOL success) {
        if (success == YES) {
            //根据省市查询数据库实体
            [ws entityForProvince:province andCity:city withBlock:^(NSString * province, NSString * city,NSString * longitude, NSString * latitude, BOOL success) {
                block(province ,city ,longitude,latitude,success);
            }];
        }
    }];
}
//根据省市查询数据库实体
- (void)entityForProvince:(NSString *)province andCity:(NSString *)city withBlock:(LocationManagerBlcok)block{
    WS(ws);
    //根据省名字从数据库查询省份实体
    NSArray *provinceArray = [ProvinceEntity MR_findByAttribute:@"ssqName" withValue:province];
    if (provinceArray && provinceArray.count > 0){
        ProvinceEntity *entity = provinceArray[0];
        if (city && city.length > 0) {
            //根据市名字从数据库查询城市
            NSArray *sortArray = [CityEntity MR_findByAttribute:@"ssqName" withValue:city];
            NSArray *cityArray = [sortArray sortedArrayUsingComparator:^NSComparisonResult(CityEntity *obj1, CityEntity *obj2) {
                return [obj1.keyid compare:obj2.keyid];
            }];
            if (cityArray.count > 0) {
                for (CityEntity *cityEntity in cityArray) {
                    if ([cityEntity.provinceId intValue] == [entity.ssqId intValue]) {
                        self.city = cityEntity;
                    }
                }
            }else{
                //拉取城市数据
                NSDictionary *parameters= [NSDictionary dictionaryWithObject:entity.ssqId forKey:@"Province"];
                [[FPNetwork POST:API_PHONE_QUERY_City withParams:parameters] addCompleteHandler:^(FPResponse *response) {
                    //插入查询条件省份id
                    NSMutableArray *dataArray = [NSMutableArray array];
                    for (NSDictionary *subDic in response.data) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:subDic];
                        [dic setObject:entity.ssqId forKey:@"provinceId"];
                        [dataArray addObject:dic];
                    }
                    //存入数据库
                    [CityEntity mj_objectArrayWithKeyValuesArray:dataArray context:[NSManagedObjectContext MR_defaultContext]];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                        if (contextDidSave == YES) {
                            //再次查询市区实体
                            NSArray *sortArray = [CityEntity MR_findByAttribute:@"ssqName" withValue:city];
                            NSArray *cityArray = [sortArray sortedArrayUsingComparator:^NSComparisonResult(CityEntity *obj1, CityEntity *obj2) {
                                return [obj1.keyid compare:obj2.keyid];
                            }];
                            
                            for (CityEntity *cityEntity in cityArray) {
                                if ([cityEntity.provinceId intValue] == [entity.ssqId intValue]) {
                                    ws.city = cityEntity;
                                }
                            }
                        }
                    }];
                }];
            }
        }
    }
}
#pragma mark ZHCityPickerDelegate
- (void)selected:(CityEntity *)city{
    self.city = city;
    if ([self.delegate respondsToSelector:@selector(selected:)]) {
        [self.delegate selected:city];
    }
}
@end
