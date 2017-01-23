//
//  PhoneNumberView.h
//  FamilyPlatForm
//
//  Created by MAC on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneNumberView : UIImageView<UITextFieldDelegate>

@property (nonatomic ,strong)UIImageView *icon;
@property (nonatomic ,strong)UITextField *texfield;
@property (nonatomic ,strong)UIButton *codeButton;
@property (nonatomic ,copy)NSString *placeholder;
@property (nonatomic ,assign)BOOL isCode;

@end
