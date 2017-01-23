//
//  RankingViewController.h
//  FamilyPlatForm
//
//  Created by Mac on 16/11/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@protocol RankingViewDelegate <NSObject>

- (void)pushToVc:(BaseViewController *)vc;

@end

@interface RankingViewController : BaseViewController

@property (nonatomic, weak) id<RankingViewDelegate> delegate;


@end
