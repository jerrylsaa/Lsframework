//
//  NationalityEntity.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NationalityEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(NSArray<NationalityEntity*>*)findAll;

+(NSArray<NSString*>*)findAllName;

@end

NS_ASSUME_NONNULL_END

#import "NationalityEntity+CoreDataProperties.h"
