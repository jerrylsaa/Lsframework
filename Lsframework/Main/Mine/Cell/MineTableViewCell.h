//
//  MineTableViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell


@property(nullable,nonatomic,retain) NSDictionary* dic;

@property(nullable,nonatomic,retain) NSArray* sectionDataSource;

@property(nonatomic) NSInteger row;

@end
