//
//  HeaderViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"


@interface HeaderViewController : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) CGFloat totalHeight;


- (void)getHeightForAllCell;
- (void)setupView;

@property (nonatomic, strong) NSNumber *isMainFree;

@property (nonatomic, strong) NSNumber *isMainUUID;
@property (nonatomic, strong) NSNumber *isMainExpertID;


@end
