//
//  DDSTCSViewController.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "DDSTEntity.h"

@interface DDSTCSViewController : BaseViewController
@property(nonatomic,retain) NSArray<DDSTEntity *> * ddstDataSource;
@end
