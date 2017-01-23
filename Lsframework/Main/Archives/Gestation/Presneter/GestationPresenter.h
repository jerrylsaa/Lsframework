//
//  GestationPresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ChildForm.h"
@protocol GestationPresenterDelegate <NSObject>

- (void)onCommitComplete:(BOOL) success info:(NSString*) info;

@end

typedef void(^Complete)(BOOL success ,NSString *message);

@interface GestationPresenter : BasePresenter

@property(nonatomic,weak) id<GestationPresenterDelegate> delegate;

-(void)commitGestation:(ChildForm *)childForm;

- (void)commitGestation:(ChildForm*) childForm block:(Complete)block;

@end
