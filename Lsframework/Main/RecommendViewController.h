//
//  RecommendViewController.h
//  FamilyPlatForm
//
//  Created by Mac on 16/11/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@protocol RecommendViewDelegate <NSObject>
- (void)pushToVc:(BaseViewController *)vc ;

@end

@interface RecommendViewController : BaseViewController
@property (nonatomic, weak) id<RecommendViewDelegate> delegate;

@end
