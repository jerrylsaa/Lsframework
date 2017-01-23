//
//  DiscoverHealthLogEntity.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverHealthLogEntity : NSObject
@property (nonatomic,assign) float dlID;
@property (nonatomic,assign) NSInteger DayNum;
@property (nonatomic,retain) NSString *LogContent;
@property (nonatomic,assign) NSInteger LogStatus;
@property (nonatomic,retain) NSString *photourl;
@property (nonatomic,assign) NSInteger CreateTime;
@end
