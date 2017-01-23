//
//  ArchivesRecordPresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ChildForm.h"

typedef void(^Complete)(BOOL success ,NSString *message);

@protocol ArchivesRecordPresenterDelegate <NSObject>

-(void)onCommitChildArchivesComplete:(BOOL) success info:(NSString*)info;

@end

@interface ArchivesRecordPresenter : BasePresenter

@property (nonatomic, weak) id<ArchivesRecordPresenterDelegate> delegate;

@property(nonatomic) NSUInteger childID;

-(void)commitChildArchives:(ChildForm *)childForm;
-(void)commitChildArchives:(ChildForm *)childForm complete:(Complete)block;

- (void)updateChildArchives:(ChildForm*) childForm;

@end
