//
//  OnlineApplyCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineApplyFamilyDoctorEntity.h"

@protocol MAOnlineDelegate <NSObject>

- (void)commitPay;

@end



@interface OnlineApplyCell : UITableViewCell

@property(nonatomic,retain)MineApplyFamilyDoctorEntity * doctor;

@property(nonatomic,weak) id<MAOnlineDelegate> delegate;



@end
