//
//  GBHealthServiceInfoViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/7/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "HealthService.h"

typedef NS_ENUM(NSUInteger, GBHealthServiceInfoType) {
    GBHealthServiceInfoTypeFromNormal,
    GBHealthServiceInfoTypeFromFood,
};


@interface GBHealthServiceInfoViewController : BaseViewController

@property (nonatomic) GBHealthServiceInfoType type;

@property(nonatomic,retain) HealthService* healthService;
@property(nonatomic,copy) NSString* EvalName;
@property(nonatomic,copy) NSNumber* TypeID;


@end
