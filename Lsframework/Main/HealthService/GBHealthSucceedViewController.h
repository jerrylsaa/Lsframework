//
//  GBHealthSucceedViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, GBHealthSucceedType) {
    GBHealthSucceedTypeFromhealth,
    GBHealthSucceedTypeFromNohealth,
};

@interface GBHealthSucceedViewController : BaseViewController


@property (nonatomic) GBHealthSucceedType type;
@property(nonatomic,retain)NSString *Result;
@property(nonatomic)BOOL  IsHealth;
@property(nonatomic,strong)NSNumber *ResultID;
@property(nonatomic,strong)NSString  *EvalName;
@end
