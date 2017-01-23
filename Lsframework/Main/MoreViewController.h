//
//  MoreViewController.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/5.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@protocol MoreViewControllerDelegate <NSObject>

- (void)pushToVc:(BaseViewController *)vc;

@end

@interface MoreViewController : BaseViewController

@property(nonatomic,weak) id<MoreViewControllerDelegate> delegate;

/** id*/
@property(nonatomic,strong)NSNumber*CategoryID;
/** 标题*/
@property(nonatomic,strong)NSString *Moretitle;

@end
