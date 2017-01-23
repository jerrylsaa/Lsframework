//
//  ProvinceEntity.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ProvinceEntity.h"
#import "MJExtension.h"

@implementation ProvinceEntity

+(NSArray<ProvinceEntity *> *)findAll{
    return [ProvinceEntity MR_findAll];
}

+(NSArray<NSString *> *)findAllName{
    NSMutableArray * array = [NSMutableArray new];
    for (ProvinceEntity * entity in [ProvinceEntity findAll]){
        [array addObject:entity.ssqName];
    }
    return array;
}

+(NSString *)findProvinceID:(NSString *)provinceName{
    NSArray* proArray = [ProvinceEntity MR_findByAttribute:@"ssqName" withValue:provinceName];
    ProvinceEntity* provinceEntity = [proArray firstObject];
    
    return provinceEntity.ssqId;
}

+(void)saveProvinceToDatabase{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"txt"];
    NSArray* array = [NSArray arrayWithContentsOfFile:path];
    
    [ProvinceEntity MR_truncateAll];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        [ProvinceEntity mj_objectArrayWithKeyValuesArray:array context:localContext];
    }];

}

@end
