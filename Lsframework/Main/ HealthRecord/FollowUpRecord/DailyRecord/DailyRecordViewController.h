//
//  DailyRecordViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, DailyRecordType) {
    DailyRecordTypeHistory,
    DailyRecordTypeCurrent
};


@interface DailyRecordViewController : BaseViewController

@property (nonatomic ,assign) DailyRecordType dailyType;

@property (nonatomic ,copy) NSString *date;

@end
