//
//  ACMainTableViewCell.h
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorList.h"

@interface ACMainTableViewCell : UITableViewCell

@property (nonatomic ,strong)DoctorList *doctor;

@property (nonatomic ,strong)UIImageView *headImageView;

@end
