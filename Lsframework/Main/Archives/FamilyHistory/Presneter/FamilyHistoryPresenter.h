//
//  FamilyHistoryPresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ChildForm.h"
@protocol FamilyHistoryPresenterDelegate <NSObject>

- (void)onCommitComplete:(BOOL) success info:(NSString*) info;

@end

typedef void(^Complete)(BOOL success ,NSString *message);

@interface FamilyHistoryPresenter : BasePresenter

@property(nonatomic,weak) id<FamilyHistoryPresenterDelegate> delegate;

@property(nonatomic,copy) NSString* fatherAge;
@property(nonatomic,copy) NSString* motherAge;


- (void)commitFamilyHistory:(ChildForm*) childForm;

- (void)commitFamilyHistory:(ChildForm*) childForm block:(Complete)block;

@end
