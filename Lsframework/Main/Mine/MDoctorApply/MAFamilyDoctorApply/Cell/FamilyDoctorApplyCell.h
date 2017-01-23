//
//  FamilyDoctorApplyCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineApplyFamilyDoctorEntity.h"

@protocol MApplySuccessCellDelegate <NSObject>

- (void)commitPay;

@end

@interface FamilyDoctorApplyCell : UITableViewCell

@property(nonatomic,retain)MineApplyFamilyDoctorEntity * doctor;

@property(nonatomic,weak) id<MApplySuccessCellDelegate> delegate;

@end
