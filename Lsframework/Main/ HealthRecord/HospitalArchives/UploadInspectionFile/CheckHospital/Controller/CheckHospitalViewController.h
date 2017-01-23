//
//  CheckHospitalViewController.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^myBlock)(NSString *name, NSInteger num);

@interface CheckHospitalViewController : BaseViewController

@property (nonatomic, copy) myBlock sendName;

@end
