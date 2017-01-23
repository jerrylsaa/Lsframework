//
//  CSystemNoticeViewController.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@protocol CSystemNoticeViewControllerDelegate <NSObject>

-(void)pushToVc:(BaseViewController *)vc;

@end

@interface CSystemNoticeViewController : BaseViewController

@property(nonatomic,weak)id <CSystemNoticeViewControllerDelegate>delegate;


@end
