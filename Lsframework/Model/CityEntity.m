//
//  CityEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CityEntity.h"
#import "ProvinceEntity.h"
#import "MJExtension.h"

@implementation CityEntity

// Insert code here to add functionality to your managed object subclass

+(NSString *)findCityID:(NSString *)city{
    
    NSArray *cityArray = [CityEntity MR_findByAttribute:@"ssqName" withValue:city];
    CityEntity* cityEntity = [cityArray firstObject];
    
    return cityEntity.ssqId;

}

+(void)saveCityToLocal:(NSString *)cityName{
    
    NSArray *cityArray = [CityEntity MR_findByAttribute:@"ssqName" withValue:cityName];
    CityEntity* city = [cityArray firstObject];

    
    NSString* proVinceName = city.provinceName;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:proVinceName forKey:@"province"];
    [defaults setObject:cityName forKey:@"city"];
    [defaults synchronize];
    
}

+(CityEntity *)getCityFromLocal{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
//    NSString* provinceName = [defaults objectForKey:@"province"];
    NSString* cityName =[defaults objectForKey:@"city"];
    
    [defaults synchronize];

//    CityEntity* city = [CityEntity new];
//    city.ssqName = cityName;
//    city.ssqId = [CityEntity findCityID:cityName];
//    
//    city.provinceName = provinceName;
//    NSString* proID = [ProvinceEntity findProvinceID:provinceName];
//    city.provinceId = [NSNumber numberWithInteger:[proID integerValue]];
    
    
    NSArray *cityArray = [CityEntity MR_findByAttribute:@"ssqName" withValue:cityName];
    CityEntity* cityEntity = [cityArray firstObject];

    
    return cityEntity;
}

+(BOOL)cityIsExist{

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* city =[defaults objectForKey:@"city"];
    [defaults synchronize];
    
    return (city.length != 0 ? YES: NO);
    
}

+(NSArray<CityEntity *> *)findAll{
    NSArray* array = [CityEntity MR_findAll];
    return array;
}

+(void)saveCityToDatabase{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
    NSArray* array = [NSArray arrayWithContentsOfFile:path];
    
    [CityEntity MR_truncateAll];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        [CityEntity mj_objectArrayWithKeyValuesArray:array context:localContext];
    }];

}


@end
