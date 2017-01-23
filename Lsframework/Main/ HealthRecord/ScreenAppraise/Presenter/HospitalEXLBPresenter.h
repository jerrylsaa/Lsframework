//
//  HospitalEXLBPresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "EXLBEntity.h"
@protocol HospitalEXLBPresenterDelegate <NSObject>

@optional
- (void)onCompletion:(BOOL)success info:(NSString *)messsage;

@end
@interface HospitalEXLBPresenter : BasePresenter
@property(nonatomic,weak) id<HospitalEXLBPresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<EXLBEntity *> * exlbDataSource;

- (void)getEXLBData;




@end
