//
//  NeonatePresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ChildForm.h"

@protocol NeonatePresenterDelegate <NSObject>

- (void)onCommitComplete:(BOOL) success info:(NSString*) info;

@end

typedef void(^Complete)(BOOL success ,NSString *message);

@interface NeonatePresenter : BasePresenter

@property(nonatomic,weak) id<NeonatePresenterDelegate> delegate;


- (void)commitNeonate:(ChildForm*) childForm;

- (void)commitNeonate:(ChildForm*) childForm block:(Complete)block;



@end
