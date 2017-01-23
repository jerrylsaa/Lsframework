//
//  FPTextField.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface FPTextField : UITextField

@property (nonatomic, assign) IBInspectable BOOL donotChangeBg;
@property (nonatomic, assign) IBInspectable CGFloat leftPadding;
@property (nonatomic, assign) IBInspectable CGFloat rightPadding;
@property (nonatomic, copy) IBInspectable NSString * title;
@property (nonatomic, copy) IBInspectable NSString * unit;
@property (nonatomic, copy) IBInspectable UIImage * leftIcon;
@property (nonatomic, copy) IBInspectable UIImage * rightIcon;
@property (nonatomic, copy) IBInspectable UIImage * normalBackground;
@property (nonatomic, copy) IBInspectable UIImage * onFocusBackground;

@property(nonatomic,assign) BOOL isTextfieldEnbled;
@property(nonatomic,retain) NSArray* pickerSource;




/** */
@property(nonatomic) BOOL stopAnimation;
@property(nonatomic) BOOL textCenter;


@end
