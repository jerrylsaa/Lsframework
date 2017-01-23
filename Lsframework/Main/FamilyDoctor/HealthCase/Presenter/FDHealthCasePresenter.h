//
//  FDHealthCasePresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

#import "FDHealthCaseEntity.h"

@protocol FDHealthCasePresenterDelegate <NSObject>

- (void)onCompletion:(BOOL) success info:(NSString*) message;

@end


@interface FDHealthCasePresenter : BasePresenter


@property(nonatomic,weak) id<FDHealthCasePresenterDelegate> delegate;

@property(nonatomic,retain) NSArray<FDHealthCaseEntity*> * dataSource;


- (void)requtestData;

@end
