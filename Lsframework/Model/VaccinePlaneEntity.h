//
//  VaccinePlaneEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface VaccinePlaneEntity : NSObject


/*
 
 "ID":1,
 "Month":2,
 "InoculationTime":1452182400,
 "MustVaccine":"1|2",
 "ReplaceVaccine":"3",
 "selectableVaccine":"3"
 
 
 */

@property(nullable,nonatomic,retain) NSNumber* rowID;
@property(nullable,nonatomic,retain) NSNumber* month;//接种月份
@property(nullable,nonatomic,copy) NSString* inoculationTime;//必选疫苗
@property(nullable,nonatomic,copy) NSString* mustVaccine;//替代疫苗
@property(nullable,nonatomic,copy) NSString* replaceVaccine;
@property(nullable,nonatomic,copy) NSString* selectableVaccine;//可选疫苗
@property(nullable,nonatomic,copy) NSString* mustVaccineName;
@property(nullable,nonatomic,copy) NSString* replaceVaccineName;
@property(nullable,nonatomic,copy) NSString* selectableVaccineName;


@property(nullable,nonatomic,retain) NSMutableArray<NSMutableArray<NSDictionary* >* > * vaccineDataSource;



/**
    数据源处理

 @return <#return value description#>
 */
+(void)handleDataSource:(NSMutableArray* _Nonnull) dataSource;



@end
