//
//  ChildEntity.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildEntity : NSObject

@property (nonatomic) NSInteger keyId;

@property(nonatomic) NSInteger childID;

@property (nonatomic, strong) NSString * childName;

@property (nonatomic, strong) NSString * childSex;

@property (nonatomic, strong) NSString * birthWeight;

@property (nonatomic, strong) NSString * birthHeight;

@property (nonatomic, strong) NSDate * birthDate;

@property (nonatomic) NSInteger mZ;

@property (nonatomic) NSInteger gJ;

@property (nonatomic, strong) NSString * nL;

@property (nonatomic, copy) NSString * childGroupTime;

@property(nonatomic,retain) NSString* child_Img;//孩子头像

@property (nonatomic, copy)NSString * GUARGIAN_NAME;

@property (nonatomic) NSInteger Brithday;


@end
