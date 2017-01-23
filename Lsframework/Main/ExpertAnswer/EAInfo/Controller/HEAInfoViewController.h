//
//  HEAInfoViewController.h
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "ExpertAnswerEntity.h"
#import "HEAInfoPresenter.h"
#import "HEAParentQuestionEntity.h"

@interface HEAInfoViewController : BaseViewController

@property(nonatomic,retain) ExpertAnswerEntity* expertEntity;
@property(nonatomic,retain) HEAInfoPresenter* presenter;
@property(nonatomic,strong) NSNumber* coupon;
@property(nonatomic,retain) NSString *hospitalType;


@property (nonatomic, strong) HEAParentQuestionEntity *question;
@property (nonatomic,retain) NSNumber *IsFree;
@property (nonatomic, strong) NSNumber *isPraise;
@property (nonatomic, strong) NSNumber *praiseCount;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger rowID;
@property (nonatomic, strong) NSNumber *row;


@end
