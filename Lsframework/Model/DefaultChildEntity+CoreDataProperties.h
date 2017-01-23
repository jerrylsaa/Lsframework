//
//  DefaultChildEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DefaultChildEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface DefaultChildEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *babyID;
@property (nullable, nonatomic, retain) NSDate *birthDate;
@property (nullable, nonatomic, retain) NSString *birthHeight;
@property (nullable, nonatomic, retain) NSString *birthWeight;
@property (nullable, nonatomic, retain) NSString *childGroupTime;
@property (nullable, nonatomic, retain) NSString *childName;
@property (nullable, nonatomic, retain) NSString *childSex;
@property (nullable, nonatomic, retain) NSNumber *gJ;
@property (nullable, nonatomic, retain) NSNumber *mZ;
@property (nullable, nonatomic, retain) NSString *nL;
@property (nullable, nonatomic, retain) NSString *childImg;
@property (nullable, nonatomic, retain) NSString * userName;

@end

NS_ASSUME_NONNULL_END
