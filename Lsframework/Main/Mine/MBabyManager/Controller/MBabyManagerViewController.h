//
//  MBabyManagerViewController.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "BabayArchList.h"

@interface MBabyManagerViewController : BaseViewController

@property(nonatomic,copy) NSString* currentBabyName;

@property(nonatomic,copy) NSString* currentUserName;

@property(nonatomic,retain) NSArray* dataSource;

@end
