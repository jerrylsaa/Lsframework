//
//  DailyRemindEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface DailyRemindEntity : NSObject

/*
 "RowID":1,
 "uuid":10,
 "RemindDate":"第10天",
 "RemindContent":"多数母乳喂养的新生儿每天排便次数较多，妈妈们记得要及时给宝宝清理排便哦。",
 "CreateTime":1463676925,
 "RemindDay":10

 */

@property(nullable,nonatomic,retain)NSNumber* rowID;
@property(nullable,nonatomic,retain)NSNumber* uuid;
@property(nullable,nonatomic,copy) NSString* remindDate;
@property(nullable,nonatomic,retain) NSString* remindContent;
@property(nullable,nonatomic,retain) NSDate* createTime;
@property(nullable,nonatomic,retain) NSNumber* remindDay;

@end
