//
//  GaugeDetailModel.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/5/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GaugeDetailModel : NSObject
@property (nonatomic,strong) NSString *insertAge;
@property (nonatomic,assign) double insertTime;
@property (nonatomic,strong) NSString *doctor;
@property (nonatomic,assign) NSInteger resultTime;
@property (nonatomic,assign) NSInteger gaugeID;
@end
