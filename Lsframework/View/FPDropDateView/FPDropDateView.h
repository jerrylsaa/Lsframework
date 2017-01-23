//
//  FPDropDateView.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FPDropDateViewChanged)(NSString * dateStr, NSDate * date);

@interface FPDropDateView : UIView


- (void)showInController:(UIViewController*)vc parentView:(UIView*)parentView;

- (void)dismiss;

- (void)setDateChangedHandler:(FPDropDateViewChanged)block;

@end
