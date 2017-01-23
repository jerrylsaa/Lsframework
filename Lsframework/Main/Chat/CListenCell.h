//
//  CListenCell.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CConsultationBeListen.h"

@interface CListenCell : UITableViewCell

@property(nonatomic,strong)UIImageView *redDotImg;

@property(nonatomic,strong) CConsultationBeListen *listen;

@end
