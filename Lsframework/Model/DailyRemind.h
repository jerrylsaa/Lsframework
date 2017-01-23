//
//  DailyRemind.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyRemind : NSObject
/**
 *      {
 "ID": 1,
 "Time": 100,
 "DevelopmentIndex": "身高20，体重20",
 "Guidelanguage": "身高20，体重20",
 "HygienicMeasures": "准时喝奶"
 }
 
 */
@property(nonatomic,strong)NSNumber  *Time;
@property(nonatomic,copy)NSString  *TimeDesc;
@property(nonatomic,copy)NSString  *DevelopmentIndex;
@property(nonatomic,copy)NSString  *Guidelanguage;
@property(nonatomic,copy)NSString  *HygienicMeasures;
@end
