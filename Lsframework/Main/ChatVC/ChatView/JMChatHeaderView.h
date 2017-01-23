//
//  JMChatHeaderView.h
//  doctors
//
//  Created by 梁继明 on 16/4/4.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterButton.h"

@interface JMChatHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@property (weak, nonatomic) IBOutlet CenterButton *patientFileBtn;

@property (weak, nonatomic) IBOutlet CenterButton *patientPhoneBtn;

@property (weak, nonatomic) IBOutlet CenterButton *patientBookBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@end
