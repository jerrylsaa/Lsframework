//
//  PatientCasePresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "PatientCaseEntity.h"

@protocol PatientCasePresenterDelegate <NSObject>

- (void)loadPatientCaseComplete:(BOOL) success message:(NSString* _Nullable) info;

@end


@interface PatientCasePresenter : BasePresenter

@property(nullable,nonatomic,retain) NSMutableArray<PatientCaseEntity* >* dataSource;
@property(nonatomic)BOOL noMoreData;
@property(nullable,nonatomic,weak) id<PatientCasePresenterDelegate> delegate;



/**
 加载病友案例
 */
- (void)loadPatientCase;

/**
 加载更多
 */
- (void)loadMorePatientCase;



@end
