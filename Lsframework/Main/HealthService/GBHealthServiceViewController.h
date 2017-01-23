//
//  GBHealthServiceViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/7/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, GBHealthServiceType) {
    GBHealthServiceTypeFromNormal,
    GBHealthServiceTypeFromFood,
};
@interface GBHealthServiceViewController : BaseViewController

@property (nonatomic) GBHealthServiceType type;

@end
