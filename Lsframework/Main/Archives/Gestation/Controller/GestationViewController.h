//
//  GestationViewController.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseArchivesViewController.h"
#import "FPTextField.h"
#import "ChildForm.h"
#import "GestationPresenter.h"
@interface GestationViewController : BaseArchivesViewController

@property(nonatomic,retain) ChildForm* childForm;

- (void)hiddenButton;

- (void)vc_3_save:(Complete)block;

- (void)loadData:(ChildForm *)child;


@end
