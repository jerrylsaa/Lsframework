//
//  TherapeuticVisit.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TherapeuticVisit : NSObject
/**
 *      {
 "uuid": 1,
 "ConsultationID": 1,
 "XiaoBianName": "11",
 "VisitContent": "1011"
 }

 */


@property(nonatomic) NSInteger uuid;//
@property(nonatomic) NSInteger ConsultationID;
@property(nullable,nonatomic,copy) NSString* XiaoBianName;
@property(nullable,nonatomic,copy) NSString* VisitContent;
//@property(nullable,nonatomic,copy)NSNumber  *CreateTime;
@property(nullable,nonatomic,copy)NSString  *CreateTime;
@property(nullable,nonatomic,copy)NSNumber  *ModifyTime;


@end
