//
//  ArchivesRecordViewController.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "ArchivesRecordPresenter.h"

//typedef void(^Complete)(BOOL success);

typedef NS_ENUM(NSUInteger, ArchivesRecordType) {
    ArchivesRecordTypeFromRegister,
    ArchivesRecordTypeFromCaseInfo,
};

@interface ArchivesRecordViewController : BaseViewController

@property (nonatomic) ArchivesRecordType type;

@property (nonatomic ,assign) BOOL btnHidden;

@property (nonatomic) Class poptoClass;

//编辑档案
- (void)hiddenButton;

- (void)vc_1_Save:(Complete)block;

- (void)loadData:(ChildForm *)child;


@end
