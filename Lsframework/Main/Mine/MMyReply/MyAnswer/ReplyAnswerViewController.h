//
//  ReplyAnswerViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/6/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "MyAnserEntity.h"
@interface ReplyAnswerViewController : BaseViewController


@property(nonatomic,strong) MyAnserEntity* MyAnswerEntity;
@property (nonatomic,strong) NSNumber *uuid;
@end
