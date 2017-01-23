//
//  VaccineTableViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VaccineTableViewCell : UITableViewCell

@property(nullable,nonatomic,retain) NSDictionary* dic;

@property(nonatomic) BOOL showBottomView;
@property(nonatomic) BOOL hiddenMustBottomView;
@property(nonatomic) BOOL showMustTopView;



@end
