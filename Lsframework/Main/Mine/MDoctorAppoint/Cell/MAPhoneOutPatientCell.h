//
//  MAPhoneOutPatientCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

//
/**
 *  电话，普通门诊，特需门诊cell
 *
 *  @param nonatomic <#nonatomic description#>
 *  @param retain    <#retain description#>
 *
 *  @return <#return value description#>
 */

#import <UIKit/UIKit.h>

#import "AppointDoctor.h"

@interface MAPhoneOutPatientCell : UITableViewCell

@property(nonatomic,retain) AppointDoctor* doctor;

@end
