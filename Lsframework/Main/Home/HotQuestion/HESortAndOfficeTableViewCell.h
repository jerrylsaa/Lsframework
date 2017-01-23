//
//  HESortAndOfficeTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertOfficeEntity.h"

@interface HESortAndOfficeTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *selectedImageView;
@property (nonatomic,retain) ExpertOfficeEntity *expertOffice;

@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,assign) BOOL isSelected;

@end
