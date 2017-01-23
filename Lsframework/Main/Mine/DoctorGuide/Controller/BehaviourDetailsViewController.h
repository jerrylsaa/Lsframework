//
//  BehaviourDetailsViewController.h
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/5/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "BehaviourGuide.h"
@interface BehaviourDetailsViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *departmentsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *doctorLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *diseaseLabel;

@property(nonatomic, strong)BehaviourGuide *model;

@end
