//
//  GrowthStatusPresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

#import "ChildForm.h"

@protocol GrowthStatusPresenterDelegate <NSObject>

- (void)onCommitComplete:(BOOL) success info:(NSString*) info;

@end

typedef void(^Complete)(BOOL success ,NSString *message);

@interface GrowthStatusPresenter : BasePresenter

@property(nonatomic,weak) id<GrowthStatusPresenterDelegate> delegate;

@property(nonatomic,retain) NSMutableArray<NSString* > * dataSource;

@property(nonatomic,retain) NSArray<NSString* >* titleArray;

- (void)commitGrowthStatus:(ChildForm*) childForm;

- (void)commitGrowthStatus:(ChildForm*) childForm block:(Complete)block;


@end
