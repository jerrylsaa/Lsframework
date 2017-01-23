//
//  NoticeViewController.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/5.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@protocol NoticeViewControllerDelegate <NSObject>

-(void)pushToVc:(BaseViewController *)vc;

@end

@interface NoticeViewController : BaseViewController

@property(nonatomic,weak)id <NoticeViewControllerDelegate>delegate;

@end
