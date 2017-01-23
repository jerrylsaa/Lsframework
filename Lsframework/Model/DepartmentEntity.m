//
//  DepartmentEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DepartmentEntity.h"
#import "MJExtension.h"

@implementation DepartmentEntity

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if([propertyName isEqualToString:@"keyId"]){
        return @"ID";
    }
    
    if([propertyName isEqualToString:@"hospitalId"]){
        return @"hospitalId";
    }
    
    return [propertyName mj_firstCharUpper];
}



+ (BOOL)departIsExist:(NSInteger)hospatialID{
   NSArray* result = [DepartmentEntity MR_findByAttribute:@"hospitalId" withValue:@(hospatialID)];
    return result.count? YES:NO;
}

+(NSArray<NSString *> *)findDepartNameWithHospatialID:(NSInteger)hospatialID{
    NSArray* result = [DepartmentEntity MR_findByAttribute:@"hospitalId" withValue:@(hospatialID)];
    NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:result.count];
    for(DepartmentEntity* d in result){
        [tempArray addObject:d.departName];
    }
    
    //给科室排序
    [tempArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {

       NSComparisonResult compareResult = [obj1 compare:obj2];
        
        return compareResult == NSOrderedDescending;//升序
        
    }];
    
    return tempArray;
}

+(NSInteger)findDepartID:(NSString *)departName{
    NSArray* result = [DepartmentEntity MR_findByAttribute:@"departName" withValue:departName];
    DepartmentEntity* depart = [result firstObject];
    return [depart.keyId integerValue];

}







@end
