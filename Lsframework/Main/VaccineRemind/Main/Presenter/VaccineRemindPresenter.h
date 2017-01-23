//
//  VaccineRemindPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "VaccinePlaneEntity.h"


@protocol VaccineRemindPresenterDelegate <NSObject>
@optional
- (void)loadVaccinePlaneComplete:(BOOL) success info:(NSString* _Nonnull) message;

@end

@interface VaccineRemindPresenter : BasePresenter

@property(nullable,nonatomic,weak) id<VaccineRemindPresenterDelegate> delegate;
@property(nullable,nonatomic,retain) NSMutableArray<VaccinePlaneEntity*> * dataSource;


/**
    加载宝宝疫苗接种

 @param childBirth 宝宝生日
 */
- (void)loadVaccinePlaneByChildBirth:(NSString* _Nonnull) childBirth;



@end
