//
//  AppointInfoPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol AppointInfoPresenterDelegate <NSObject>

- (void)onCompletion:(BOOL) success info:(NSString*) message;

@end


@interface AppointInfoPresenter : BasePresenter

@property(nonatomic,weak) id<AppointInfoPresenterDelegate> delegate;


- (void)commitCancelAppointInfo:(NSString*) info AppointID:(NSInteger) appointID;


@end
