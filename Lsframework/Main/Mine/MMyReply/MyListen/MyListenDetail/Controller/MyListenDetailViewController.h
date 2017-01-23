//
//  MyListenDetailViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/6/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "MyListen.h"
@interface MyListenDetailViewController : BaseViewController

@property(nonatomic,strong)MyListen  *myListen;
@property (nonatomic, assign) NSInteger uuid;

@end
