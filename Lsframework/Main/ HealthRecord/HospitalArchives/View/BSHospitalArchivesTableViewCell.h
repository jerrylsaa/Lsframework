//
//  BSHospitalArchivesTableViewCell.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalFileList.h"

@interface BSHospitalArchivesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hospitalName;// 医院名字
@property (weak, nonatomic) IBOutlet UILabel *project;// 项目
@property (weak, nonatomic) IBOutlet UILabel *dateTime;// 日期

@property (nonatomic, strong) HospitalFileList *model;
@property (nonatomic, copy  ) NSString         *myType;

@end
