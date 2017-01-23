//
//  BSAppointmentTableViewCell.h
//  doctors
//
//  Created by Shuai on 16/3/27.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AppointmentModel.h"
#import "FDAppointManagerEntity.h"



@interface BSAppointmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (nonatomic, strong) AppointmentModel *model;
@property(nonatomic,retain) FDAppointManagerEntity* model;


@end
