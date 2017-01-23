//
//  PushPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/12/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "MyAnserEntity.h"

@protocol PushPresenterDelegate <NSObject>
@optional
-(void)loadPushDoctorAnswerCompletion:(BOOL)success  info:(NSString*)message;
@end

@interface PushPresenter : BasePresenter
@property (nonatomic, weak) id<PushPresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<MyAnserEntity*> *AnswerSource;
@property(nonatomic,retain) NSNumber   *IsAnwer;

/**
 *  医生回答：已回答页面单条数据
 */
-(void)loadPushDoctorAnswerinfoWithType:(NSNumber*)type UUID:(NSNumber*)uuid;
@end
