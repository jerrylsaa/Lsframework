//
//  CONNERS_FMCSCell.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLLBEntity.h"

@interface CONNERS_FMCSCell : UITableViewCell
@property (nonatomic,strong) XLLBEntity *xllbEntity;
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,strong) NSString *bzScore;
@end
