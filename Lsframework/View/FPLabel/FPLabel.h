//
//  FPLabel.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface FPLabel : UILabel
@property (nonatomic,assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic,strong)IBInspectable UIColor* borderColor;
@property (nonatomic,assign)IBInspectable CGFloat borderWidth;
@end
