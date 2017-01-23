//
//  BabyInfoDetail.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabyInfoDetail : NSObject

@property(nonatomic,retain) NSDate* birthDate;

@property(nonatomic) NSInteger childId;

@property(nonatomic,copy) NSString* childImg;//头像

@property(nonatomic,copy) NSString* childName;

@property(nonatomic) NSInteger childNation;//国家

@property(nonatomic) NSInteger childSex;

@property(nonatomic) NSInteger familyDoctor;


@end
