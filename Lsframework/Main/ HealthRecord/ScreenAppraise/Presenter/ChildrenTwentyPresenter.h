//
//  ChildrenTwentyPresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ChildrenTwentyEntity.h"
@protocol HospitalChildrenTwentyPresenterDelegate <NSObject>

@optional
- (void)onCompletion:(BOOL)success info:(NSString *)messsage;

@end
@interface ChildrenTwentyPresenter : BasePresenter
@property(nonatomic,weak) id<HospitalChildrenTwentyPresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<ChildrenTwentyEntity *> * child20DataSource;

- (void)getChild20Data;


@end
