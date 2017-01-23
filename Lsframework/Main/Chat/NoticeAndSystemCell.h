//
//  NoticeAndSystemCell.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemNotice.h"
@interface NoticeAndSystemCell : UITableViewCell

@property(nonatomic,strong)SystemNotice *systemModel;

@property(nonatomic,strong)UIImageView *redDotImg;

@end
