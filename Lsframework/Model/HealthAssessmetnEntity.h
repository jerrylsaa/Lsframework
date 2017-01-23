//
//  HealthAssessmetnEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthAssessmetnEntity : NSObject

@property(nonatomic) NSInteger rowID;
@property(nonatomic) NSInteger keyID;//ID
@property(nonatomic) NSInteger userID;
@property(nonatomic,copy) NSString* exactAge;
@property(nonatomic,copy) NSString* examDate;
@property(nonatomic,copy) NSString* childName;
@property(nonatomic,copy) NSString* childSex;
@property(nonatomic,copy) NSString* birthDate;
@property(nonatomic,copy)NSString* staticPage ;

@end
