//
//  FDHealthCaseEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/3.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDHealthCaseEntity : NSObject

@property(nonatomic) NSInteger keyID;

@property(nonatomic,copy) NSString* healthyName;

@property(nonatomic,retain) NSDate* starDate;

@property(nonatomic,retain) NSDate* endDate;

@property(nonatomic,copy) NSString* healthyContent;

@end
