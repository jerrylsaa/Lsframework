//
//  AwaitAnswerViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/6/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "MyAnserEntity.h"


@interface AwaitAnswerViewController : BaseViewController{

//    UIImageView* icon;
//    UILabel* myName;
//    UILabel* watingLable;
//    UILabel* questionLabel;
//    UILabel* timeLabel;
//    UILabel* listenLable;

}

@property(nonatomic,strong) MyAnserEntity* MyAnswerEntity;
@property(nonatomic,assign) NSInteger uuid;
@property(nonatomic,assign)NSInteger WaitAnswer;


@end
