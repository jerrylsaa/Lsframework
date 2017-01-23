//
//  LocationManager.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  定位回调
 *
 *  @param province 省份
 *  @param city     城市
 *  @param success  为NO时，省份和城市都返回nil
 */
typedef void(^LocationManagerBlcok)(NSString * province, NSString * city,NSString * longitude, NSString * latitude, BOOL success);

@interface LocationManager : NSObject

+(instancetype) shareInstance;

-(void)getProvinceAndCityWithBlock:(LocationManagerBlcok)block;


@end
