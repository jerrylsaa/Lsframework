//
//  GrowthStatusViewController.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseArchivesViewController.h"
#import "ChildForm.h"
#import "GrowthStatusPresenter.h"

@interface GrowthStatusViewController : BaseArchivesViewController

@property(nonatomic,retain) ChildForm* childForm;


- (void)hiddenButton;

- (void)vc_5_save:(Complete)block;

- (void)loadData:(ChildForm *)child;


@end
