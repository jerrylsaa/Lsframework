//
//  BSCheckProjectViewController.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^myBlock)(NSString *name, NSInteger num);

@interface BSCheckProjectViewController : BaseViewController

@property (nonatomic, copy) myBlock sendName;

@end
