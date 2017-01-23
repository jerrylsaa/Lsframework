//
//  FDChoicePackagePresenter.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDChoicePackagePresenter.h"

@implementation FDChoicePackagePresenter

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _dataSource = [NSMutableArray array];
    }
    return self;
}


- (void)loadPackageByDoctorId:(NSNumber *)doctorId with:(Complete)block{
    WS(ws);
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:doctorId forKey:@"DoctorID"];
    [[FPNetwork POST:API_QUERY_DOCTOR_PACKAGE_LIST withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSArray *array = response.data;
            for (NSDictionary *dic in array) {
                Package *packageEntity = [Package new];
                packageEntity.packageName = [dic objectForKey:@"Package_Name"];
                packageEntity.packagePrice = [dic objectForKey:@"Package_Price"];
                packageEntity.packageInfo = [dic objectForKey:@"Base_PackageInfo"];
                [ws.dataSource addObject:packageEntity];
            }
            block(YES ,ws.dataSource);
        }
    }];
}




- (void)getPackage:(NSInteger)doctorID{
    NSDictionary* parames = @{@"DoctorID":@(doctorID)};
    WS(ws);
    [[FPNetwork POST:API_QUERY_DOCTOR_PACKAGE_LIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            ws.packageArray = [Package mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];

}



@end
