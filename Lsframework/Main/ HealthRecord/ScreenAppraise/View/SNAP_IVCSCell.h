//
//  SNAP_IVCSCell.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLLBEntity.h"

@interface SNAP_IVCSCell : UITableViewCell
@property (nonatomic,strong) XLLBEntity *xllbEntity;
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,strong) NSString *bzScore;
@property (nonatomic,strong) NSString *pj;
@end
