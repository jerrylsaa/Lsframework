//
//  TreatMentRecordPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "FDAppointManagerEntity.h"

@protocol TreatMentRecordPresenterDelegate <NSObject>

-(void)onCompletion:(BOOL) success info:(NSString*) message;

@end

@interface TreatMentRecordPresenter : BasePresenter

@property(nonatomic,weak) id<TreatMentRecordPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray<FDAppointManagerEntity* > * dataSource;

- (void)getTreatMentRecord;

@end
