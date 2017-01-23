//
//  CooperationHospitalListViewCell.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalList.h"

@interface CooperationHospitalListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hospitalName;// 医院名称
@property (nonatomic, assign) NSInteger keyID;

@property (nonatomic, strong) HospitalList *model;

@end
