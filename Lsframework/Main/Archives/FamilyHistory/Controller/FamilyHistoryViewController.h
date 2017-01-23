//
//  FamilyHistoryViewController.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseArchivesViewController.h"
#import "ChildForm.h"
#import "FamilyHistoryPresenter.h"
@interface FamilyHistoryViewController : BaseArchivesViewController

@property(nonatomic,retain) ChildForm* childForm;



- (void)hiddenButton;

- (void)vc_4_save:(Complete)block;

- (void)loadData:(ChildForm *)child;

@end
