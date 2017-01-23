//
//  UIControl+Touch.h
//  FamilyPlatForm
//
//  Created by tom on 16/5/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval .5  //默认时间间隔
@interface UIControl (Touch)
/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

