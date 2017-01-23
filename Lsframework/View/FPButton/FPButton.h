//
//  FPButton.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface FPButton : UIButton
@property (nonatomic,assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic,strong)IBInspectable UIColor* backgroundColor;
@property (nonatomic,strong)IBInspectable UIColor* backgroundLightColor;
@property (nonatomic,strong)IBInspectable UIColor* borderColor;
@property (nonatomic,assign)IBInspectable CGFloat borderWidth;
@end
