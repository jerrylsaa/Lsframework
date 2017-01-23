//
//  FCDiseaseDescriberViewController.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "CaseInfo.h"

@interface FCDiseaseDescriberViewController : BaseViewController

@property(nonatomic,retain) CaseInfo* caseInfo;

@property(nonatomic) BOOL showCommitSucessInfo;


@end
