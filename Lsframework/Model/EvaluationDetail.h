//
//  EvaluationDetail.h
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/5/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluationDetail : NSObject


@property (nonatomic, copy  ) NSString  *userName;

@property (nonatomic, copy  ) NSString  *hName;

@property (nonatomic, copy  ) NSString  *departName;
@property (nonatomic, copy  ) NSString  *duties;

@property (nonatomic, copy  ) NSString  *doctorName;

@property (nonatomic, copy  ) NSString  *title;

@property (nonatomic, copy  ) NSString  *field;

@property (nonatomic, copy  ) NSString  *userImg;

@property (nonatomic, assign) NSInteger applyTime;

@property (nonatomic, assign) NSInteger orderState;

@property (nonatomic, copy  ) NSString  *babyName;

@property (nonatomic, copy  ) NSString  *isEvaluate;

@property (nonatomic, copy  ) NSString  *askMode;

@property(nonatomic, copy) NSString *descriptionDisease;

@property(nonatomic, assign) NSInteger patientNum;

@property(nonatomic, assign) NSInteger followUp;

@property(nonatomic, assign)NSInteger starNum;

@property(nonatomic,copy)NSNumber *doctorID;

@end
