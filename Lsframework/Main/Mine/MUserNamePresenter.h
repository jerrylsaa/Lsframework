//
//  MUserNamePresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
@protocol MUserNamePresenterDelegate <NSObject>

@optional
- (void)onCompletion:(BOOL) success info:(NSString*) info;

@end

@interface MUserNamePresenter : BasePresenter


@property(nonatomic,weak) id<MUserNamePresenterDelegate> delegate;



//设置默认昵称
- (void)SetNickName:(NSString*)nickName;
@end
