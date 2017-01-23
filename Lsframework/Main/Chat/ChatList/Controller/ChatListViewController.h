//
//  ChatListViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
//@interface ChatListViewController : UIViewController

@protocol ChatListViewControllerDelegate <NSObject>

-(void)pushToVc:(BaseViewController *)vc;

@end

@interface ChatListViewController : BaseViewController

@property(nonatomic,weak) id<ChatListViewControllerDelegate>delegate;

@end
