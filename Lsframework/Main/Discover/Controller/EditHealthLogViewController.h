//
//  EditHealthLogViewController.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

@interface EditHealthLogViewController : BaseViewController
@property (nonatomic,assign) float dlID;
@property (nonatomic,assign) NSInteger DayNum;
@property (nonatomic,retain) NSString *LogContent;
@property (nonatomic,assign) NSInteger CreateTime;
@end
