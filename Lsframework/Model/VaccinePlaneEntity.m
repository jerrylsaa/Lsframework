//
//  VaccinePlaneEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "VaccinePlaneEntity.h"

@implementation VaccinePlaneEntity

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if([propertyName isEqualToString:@"rowID"]){
        return @"ID";
    }
    
    if([propertyName isEqualToString:@"selectableVaccine"]){
        return @"selectableVaccine";
    }
    
    if([propertyName isEqualToString:@"selectableVaccineName"]){
        return @"selectableVaccineName";
    }

    
    return [propertyName mj_firstCharUpper];

}

+(void)handleDataSource:(NSMutableArray *)dataSource{
    
    for(VaccinePlaneEntity* vaccine in dataSource){
        vaccine.vaccineDataSource = [NSMutableArray array];
        
        NSMutableArray* mustArray = [NSMutableArray array];
        NSMutableArray* replaceArray = [NSMutableArray array];
        NSMutableArray* selectArray = [NSMutableArray array];

        
        //必选疫苗
        if(vaccine.mustVaccine && vaccine.mustVaccine.length != 0 && vaccine.mustVaccineName && vaccine.mustVaccineName.length != 0){
            NSArray* mustVaccineIDArray = [vaccine.mustVaccine componentsSeparatedByString:@"|"];
            
            NSArray* musatVaccineNameArray = [vaccine.mustVaccineName componentsSeparatedByString:@"|"];
            
            for(int i = 0; i < mustVaccineIDArray.count; i++){
                NSMutableDictionary* dic = [NSMutableDictionary dictionary];
                NSString* vaccineID = [mustVaccineIDArray objectAtIndex:i];
                if(![vaccineID isEqualToString:@"0"]){
                    NSString* vaccineName = [musatVaccineNameArray objectAtIndex:i];
                    [dic setObject:vaccineID forKey:@"ID"];
                    [dic setObject:vaccineName forKey:@"name"];
                    [dic setObject:@"must" forKey:@"type"];
                    [mustArray addObject:dic];
                }
            }
        }
        
        //替代疫苗
        if(vaccine.replaceVaccine && vaccine.replaceVaccine.length != 0 && vaccine.replaceVaccineName && vaccine.replaceVaccineName.length != 0){
            NSArray* replaceVaccineIDArray = [vaccine.replaceVaccine componentsSeparatedByString:@"|"];
            
            NSArray* replaceVaccineNameArray = [vaccine.replaceVaccineName componentsSeparatedByString:@"|"];
            
            for(int i = 0; i < replaceVaccineIDArray.count; i++){
                NSMutableDictionary* dic = [NSMutableDictionary dictionary];
                NSString* vaccineID = [replaceVaccineIDArray objectAtIndex:i];
                if(![vaccineID isEqualToString:@"0"]){
                    NSString* vaccineName = [replaceVaccineNameArray objectAtIndex:i];
                    [dic setObject:vaccineID forKey:@"ID"];
                    [dic setObject:vaccineName forKey:@"name"];
                    [dic setObject:@"replace" forKey:@"type"];
                    [replaceArray addObject:dic];
                }
            }
        }

        //可选选疫苗
        if(vaccine.selectableVaccine && vaccine.selectableVaccine.length != 0 && vaccine.selectableVaccineName && vaccine.selectableVaccineName.length != 0){
            NSArray* selectVaccineIDArray = [vaccine.selectableVaccine componentsSeparatedByString:@"|"];
            
            NSArray* selectVaccineNameArray = [vaccine.selectableVaccineName componentsSeparatedByString:@"|"];
            
            for(int i = 0; i < selectVaccineIDArray.count; i++){
                NSMutableDictionary* dic = [NSMutableDictionary dictionary];
                NSString* vaccineID = [selectVaccineIDArray objectAtIndex:i];
                if(![vaccineID isEqualToString:@"0"]){
                    NSString* vaccineName = [selectVaccineNameArray objectAtIndex:i];
                    [dic setObject:vaccineID forKey:@"ID"];
                    [dic setObject:vaccineName forKey:@"name"];
                    [dic setObject:@"select" forKey:@"type"];
                    [selectArray addObject:dic];

                }
            }
        }
        [vaccine.vaccineDataSource addObject:mustArray];
        [vaccine.vaccineDataSource addObject:replaceArray];
        [vaccine.vaccineDataSource addObject:selectArray];
        
    }
}


@end
