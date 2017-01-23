//
//  GBArchivesRecordViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "GBArchivesRecordPresenter.h"

#import "BabayArchList.h"

//typedef void(^Comple)(BOOL success);

typedef NS_ENUM(NSUInteger, GBArchivesRecordType) {
    GBArchivesRecordTypeFromRegister,
    GBArchivesRecordTypeFromCaseInfo,
};

@interface GBArchivesRecordViewController : BaseViewController

@property (nonatomic) GBArchivesRecordType type;
@property (nonatomic) Class poptoClass;

@property (nonatomic,strong) BabayArchList  *BabyList;


- (void)vc_GB_Save:(Complete)block;

//- (void)loadData:(BabayArchList *)child;



@end
