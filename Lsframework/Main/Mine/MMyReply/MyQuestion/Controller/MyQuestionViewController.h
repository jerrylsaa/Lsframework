//
//  MyQuestionViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@protocol MyQuestionDelegate <NSObject>

- (void)pushToVc:(BaseViewController *)vc;

@end

@interface MyQuestionViewController : BaseViewController

@property (nonatomic, weak) id<MyQuestionDelegate> delegate;

- (void)shareAction;

@end
