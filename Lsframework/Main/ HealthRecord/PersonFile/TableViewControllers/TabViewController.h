//
//  TabViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "ChildForm.h"

@interface TabViewController : BaseViewController


- (void)reloadDataWith:(NSArray *)data child:(ChildForm *)child imageName:(NSString *)imageName;

@end
