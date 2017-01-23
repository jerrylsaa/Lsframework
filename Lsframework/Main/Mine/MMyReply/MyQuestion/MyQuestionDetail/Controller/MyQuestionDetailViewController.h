//
//  MyQuestionDetailViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "MyReply.h"

@interface MyQuestionDetailViewController : BaseViewController

@property (nonatomic, strong) MyReply *myReply;
@property (nonatomic, assign) NSInteger uuid;

@end
