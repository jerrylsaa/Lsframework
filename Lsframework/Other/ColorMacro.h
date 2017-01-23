//
//  ColorMacro.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h


#define BlackColor RGB(0, 0, 0)
#define MainColor RGB(107, 211, 207)

#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define RGB(R, G, B) RGBA(R, G, B, 1.0)

#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define FileFontColor UIColorFromRGB(0x666666)

#endif /* ColorMacro_h */
