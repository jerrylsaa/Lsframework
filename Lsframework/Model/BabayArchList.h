//
//  BabayArchList.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabayArchList : NSObject

@property(nonatomic) NSInteger childID;

@property(nullable,nonatomic,copy) NSString* childName;

@property(nullable,nonatomic,copy) NSString* sex;

@property(nullable,nonatomic,copy) NSString* nL;//年龄

@property(nullable,nonatomic,copy) NSString* childImg;//头像

/******/
@property(nullable,nonatomic,retain) NSNumber* height;//身高
@property(nullable,nonatomic,retain) NSNumber* weight;//体重
@property (nullable,nonatomic, strong) NSDate * birthDate;//生日
@property(nullable,nonatomic,copy) NSString* nickName;



@end
