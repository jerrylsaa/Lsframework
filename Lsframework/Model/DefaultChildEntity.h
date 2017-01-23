//
//  DefaultChildEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DefaultChildEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+(DefaultChildEntity*)defaultChild;

+(void)deleteDefaultChild;

+(BOOL)isHasDefaultChild;


@end

NS_ASSUME_NONNULL_END

#import "DefaultChildEntity+CoreDataProperties.h"
