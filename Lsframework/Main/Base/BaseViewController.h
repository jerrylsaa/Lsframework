//
//  BaseViewController.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic) BOOL isHideTabbar;
@property (nonatomic ,assign) NSInteger index;
- (void)setupView;
/**
 *  设置返回按钮图标
 *
 *  @param image 传空将不显示
 */
-(void)initBackBarWithImage:(UIImage *)image;

/**
 *  设置返回按钮文字
 *
 *  @param leftTitle 传空不显示
 */
-(void)initLeftBarWithTitle:(NSString*)leftTitle;

/**
 *  返回按钮事件
 *
 *  @param sender
 */
-(void)backItemAction:(id)sender;

-(void)initRightBarWithTitle:(NSString *)leftTitle;

-(void)initRightBarWithImage:(UIImage *)rightImage;

-(void)initRightBarWithView:(UIView *)rightImage;

/**
 *  右侧按钮事件
 *
 *  @param sender 
 */
-(void)rightItemAction:(id)sender;

/**
 *  是否能滑动返回
 *
 *  @return 
 */
-(BOOL)isCanDragBack;

@end
