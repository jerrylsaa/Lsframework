//
//  ArchivesMainPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

typedef void(^CompleteHander)(BOOL success);

@interface ArchivesMainPresenter : BasePresenter

- (void)loadMenuData:(CompleteHander)block;

@end
