//
//  CaseInfoPresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "CaseInfo.h"
#import "ChildEntity.h"

typedef NS_ENUM(NSUInteger, CaseInfoType) {
    CaseInfoTypeFree,
    CaseInfoTypeAccuration,
    CaseInfoTypeQuick,
    CaseInfoTypeVIP,
    CaseInfoTypeNormal
};

@protocol CaseInfoDelegate <NSObject>

- (void)onUploadCompletion:(BOOL) success info:(NSString*) info;

- (void)commitCaseInfoSuccess:(BOOL ) success info:(NSString *) info;

- (void)onnGetChildInfosComplete;

@end

@interface CaseInfoPresenter : BasePresenter

@property (nonatomic) CaseInfoType caseInfoType;

@property (nonatomic ,weak)id<CaseInfoDelegate> delegate;

@property (nonatomic ,strong)NSArray *imageArray;

@property (nonatomic ,strong)NSArray<ChildEntity*> *childInfos;

@property (nonatomic ,strong)ChildEntity* currentSelectedChildInfo;//当前选中的宝宝

@property (nonatomic ,copy)NSString *imagePath;

@property (nonatomic ,strong)CaseInfo *caseInfo;

@property (nonatomic, strong) NSString * orderNum;

@property (nonatomic, copy) NSString * resultId;


@property(nonatomic) BOOL hasChoseDisease;

- (void)commitCaseInfo:(CaseInfo *) caseInfo;

- (void)getChildInfo;

- (void)commitConsultaion;

@end
