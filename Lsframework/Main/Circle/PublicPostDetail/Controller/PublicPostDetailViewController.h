//
//  PublicPostDetailViewController.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "CircleEntity.h"


@interface PublicPostDetailViewController : BaseViewController

@property(nullable,nonatomic,retain) CircleEntity* circleEntity;

@property (nullable,nonatomic,retain) NSNumber *UUID;

@property(nonatomic,assign)NSInteger usrId;


@property(nonatomic,copy)void (^PublicPostDetailViewControllerBlock)(BOOL isDelete);


@end
