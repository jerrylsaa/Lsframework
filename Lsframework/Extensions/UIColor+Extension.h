//
//  UIColor+Extension.h
//  FansGroup
//
//  Created by admin on 15/10/29.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

#define GRAY_COLOR_33 [UIColor colorWithHexNumber:0x333333]
#define GRAY_COLOR_66 [UIColor colorWithHexNumber:0x666666]
#define GRAY_COLOR_99 [UIColor colorWithHexNumber:0x999999]
#define GRAY_COLOR_e9 [UIColor colorWithHexNumber:0xe9e9e9]

+(UIColor *)colorWithIntR:(int)red andG:(int)green andB:(int)blue withAlpha:(float)alpha;

//以,分割;
+(UIColor*)colorWithRGBAString:(NSString *)colorStr;

//相反的，以,分割;
+(UIColor*)OPP_colorWithRGBAString:(NSString *)colorStr;

+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;

+ (UIColor *)colorWithHexNumber:(NSUInteger)hexColor;

@end
