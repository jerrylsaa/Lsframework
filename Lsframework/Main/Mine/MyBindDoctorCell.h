//
//  MyBindDoctorCell.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBindDoctorEntity.h"
@protocol MyBindDoctorCellDelegate <NSObject>
@optional

- (void)cancelBindAction:(MyBindDoctorEntity *)cellEntity;

@end
@interface MyBindDoctorCell : UITableViewCell
@property (nonatomic,retain) MyBindDoctorEntity *cellEntity;
@property(nonatomic,weak) id<MyBindDoctorCellDelegate> delegate;


@end
