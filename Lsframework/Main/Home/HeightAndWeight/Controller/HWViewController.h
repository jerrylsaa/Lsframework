//
//  HWViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,BodyType){
    BodyTypeHeight,
    BodyTypeWeight,
};

@interface HWViewController : BaseViewController

@property (nonatomic, assign) BodyType bodyType;

@end
