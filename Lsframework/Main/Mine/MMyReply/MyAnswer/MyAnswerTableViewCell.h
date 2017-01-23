//
//  MyAnswerTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAnserEntity.h"
@interface MyAnswerTableViewCell : UITableViewCell{
    UIView* _containerView;
    
//    UIImageView* _icon;
//    UILabel* _myName;
//    UILabel* _watingLable;
//    UILabel* _questionLabel;
//    UILabel* _timeLabel;
//    UILabel* _listenLable;
}

@property(nonatomic,retain) MyAnserEntity* myAnswer;
@property(nonatomic,copy)UIImageView  *icon;
@property(nonatomic,copy)UILabel  *myName;
@property(nonatomic,copy)UILabel  *watingLable;
@property(nonatomic,copy)UILabel  *questionLabel;
@property(nonatomic,copy)UILabel  *timeLabel;
@property(nonatomic,copy)UILabel  *listenLable;

@end
