//
//  HEHospitalAndOfficeTableViewCell.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertHospitalEntity.h"
#import "ExpertOfficeEntity.h"
@interface HEHospitalAndOfficeTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *selectedImageView;
//@property (nonatomic,retain) ExpertHospitalEntity *expertHpt;
@property (nonatomic,retain) ExpertOfficeEntity *expertOffice;

@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,assign) BOOL isSelected;
@end
