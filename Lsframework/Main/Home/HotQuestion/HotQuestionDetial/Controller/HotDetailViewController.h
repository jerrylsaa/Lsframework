//
//  HotDetailViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "HEAParentQuestionEntity.h"

@interface HotDetailViewController : BaseViewController

@property (nonatomic, strong) HEAParentQuestionEntity *question;
@property(nonatomic,retain) NSNumber *IsFree;
@end
