//
//  DiseaseDescribeViewController.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "CaseInfo.h"

@interface DiseaseDescribeViewController : BaseViewController

@property(nonatomic,retain) CaseInfo* caseInfo;

@property(nonatomic) BOOL showCommitSucessInfo;


@end
