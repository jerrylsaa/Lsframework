//
//  MyAnswerViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
@protocol MyAnswerDelegate <NSObject>

- (void)pushToVc:(BaseViewController *)vc;

@end

@interface MyAnswerViewController : BaseViewController

@property (nonatomic, weak) id<MyAnswerDelegate> delegate;

@property (nonatomic, copy) NSString *doctorID;


@end
