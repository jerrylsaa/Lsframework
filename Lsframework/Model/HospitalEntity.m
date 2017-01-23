//
//  HospitalEntity.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HospitalEntity.h"
#import "MJExtension.h"

@implementation HospitalEntity

// Insert code here to add functionality to your managed object subclass


+ (NSString*)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if([propertyName isEqualToString:@"hName"]){
       return [propertyName mj_firstCharUpper];
    }else{
        return propertyName;
    }
}


+(NSInteger)findHospatialIDWithName:(NSString *)hospatialName{
    NSArray* result = [HospitalEntity MR_findByAttribute:@"hName" withValue:hospatialName];
    HospitalEntity* hospatial = [result firstObject];
    return [hospatial.keyid integerValue];
}

+(NSArray<NSString *> *)findHospatialName:(NSString *)cityID{
    NSArray* hospitalList = [HospitalEntity MR_findByAttribute:@"cityId" withValue:cityID];
    
   NSArray* resultArray = [hospitalList sortedArrayUsingComparator:^NSComparisonResult(HospitalEntity*  _Nonnull obj1, HospitalEntity*  _Nonnull obj2) {
       NSComparisonResult result = [obj1.hName compare:obj2.hName];
       return result == NSOrderedDescending;
    }];
    
    NSMutableArray* dataArray = [NSMutableArray array];
    for(HospitalEntity* h in resultArray){
        [dataArray addObject:h.hName];
    }
    
    return dataArray;

}

+(BOOL)hospistalIsExist:(NSString *)cityName{
    NSArray* cityList = [CityEntity MR_findByAttribute:@"ssqName" withValue:cityName];
    CityEntity* city = [cityList firstObject];
    
    NSArray* hospitalList = [HospitalEntity MR_findByAttribute:@"cityId" withValue:city.ssqId];

    return ((hospitalList.count != 0)? YES: NO);
}


@end
