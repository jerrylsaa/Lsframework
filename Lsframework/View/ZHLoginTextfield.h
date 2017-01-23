//
//  ZHLoginTextfield.h
//  FamilyPlatForm
//
//  Created by lichen on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

//登录输入框
#import <UIKit/UIKit.h>

@interface ZHLoginTextfield : UIImageView<UITextFieldDelegate>

@property(nonatomic,retain) UIImageView* iconImage;
@property(nonatomic,retain) UITextField* tf;
@property(nonatomic,retain) NSString *tfType;
@property(nonatomic,copy) NSString* iconName;//头像名字
@property(nonatomic,copy) NSString* placeholder;

-(void)setPlaceholderColor:(UIColor *)placeholdercolor;
@end
