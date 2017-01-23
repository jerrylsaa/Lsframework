//
//  DateEntity.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (NSArray *)findDateWithYear:(NSString *)year andMonth:(NSString *)month;

@end

NS_ASSUME_NONNULL_END

#import "DateEntity+CoreDataProperties.h"
