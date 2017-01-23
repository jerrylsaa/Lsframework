//
//  Package.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Package : NSObject

//"PackageStarTime":"2016/1/1 0:00:00",
//"PackageEndTime":"2017/1/1 0:00:00",
//"OrderPrice":"880.0000",
//"ActualPrice":"800.0000",
//"DoctorName":"儿童医院医生",
//"ChildName":"666",
//"UserName":"曹操",
//"PackageName":"一级家庭医生",
//"OrderState":"已申请",
//"Base_PackageInfo":[
//                    {

@property(nonatomic,retain) NSDate* packageStarTime;//套餐开始日期
@property(nonatomic,retain) NSDate* packageEndTime;//结束日期
@property(nonatomic,copy) NSString* orderPrice;//订单价格
@property(nonatomic,copy) NSString* actualPrice;//实际价格
@property(nonatomic,copy) NSString* doctorName;//
@property(nonatomic,copy) NSString* childName;//
@property(nonatomic,copy) NSString* userName;//
@property(nonatomic,copy) NSString* orderState;//订单状态
@property(nonatomic,retain) NSArray<NSDictionary* >* basePackageInfo;

@property(nonatomic,retain) NSNumber* packageID;

@property (nonatomic ,copy)NSString *packageName;

@property (nonatomic ,strong)NSNumber *packagePrice;

@property (nonatomic ,strong)NSArray *packageInfo;

/** 兼容选择家庭医生模块，选择套餐字段*/
@property(nonatomic,retain) NSNumber* fapackageID;

@property (nonatomic ,copy)NSString *fapackageName;

@property (nonatomic ,strong)NSNumber *fapackagePrice;

@property (nonatomic ,strong)NSArray *fapackageInfo;


@end
