//
//  FPDropView.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

//返回YES自动隐藏
typedef BOOL(^FPDropViewSelectedHandler)(NSUInteger selection);

@interface FPDropView : UIView
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic, strong) NSArray<NSString*> * titles;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic, strong) UIFont * font;
@property (nonatomic, assign) BOOL isFamily;

- (void)showInController:(UIViewController*)vc parentView:(UIView*)parentView;

- (void)dismiss;

- (void)setSelectedHandler:(FPDropViewSelectedHandler)block;

@end
