//
//  NeonateViewController.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseArchivesViewController.h"
#import "ChildForm.h"
#import "NeonatePresenter.h"

@interface NeonateViewController : BaseArchivesViewController

@property(nonatomic,retain) ChildForm* childForm;


- (void)hiddenButton;

- (void)vc_2_save:(Complete)block;


- (void)loadData:(ChildForm *)child;


@end
