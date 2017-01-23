//
//  CCommmentCell.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMyComment.h"

@interface CCommmentCell : UITableViewCell

@property(nonatomic,strong) CMyComment *comment;

@property(nonatomic,strong)UIImageView *redDotImg;


@end
