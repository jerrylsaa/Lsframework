//
//  UIColor+Extension.m
//  FansGroup
//
//  Created by admin on 15/10/29.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)



+(UIColor *)colorWithIntR:(int)red andG:(int)green andB:(int)blue withAlpha:(float)alpha{
    
    return [UIColor colorWithRed:red*1.0f/255.0f green:green*1.0f/255.0f blue:blue *1.0f/255.0f alpha:alpha];



}

//以,分割;
+(UIColor*)colorWithRGBAString:(NSString *)colorStr{
    
    NSArray *array = [colorStr componentsSeparatedByString:@","];
    
    if (array.count >3) {
        
        int red = [[array objectAtIndex:0] intValue];
        
        int green = [[array objectAtIndex:1] intValue];
        
        int blue = [[array objectAtIndex:2] intValue];
        
        int alpha = [[array objectAtIndex:3] intValue];
        
        return [self colorWithIntR:red andG:green andB:blue withAlpha:alpha];
    }
    
  
     return [self colorWithIntR:0 andG:0 andB:0 withAlpha:1.0f];


   

}


//相反的，以,分割;
+(UIColor*)OPP_colorWithRGBAString:(NSString *)colorStr{
    
    NSArray *array = [colorStr componentsSeparatedByString:@","];
    
    if (array.count >3) {
        
        
        int red = [[array objectAtIndex:0] intValue];
        
        int green = [[array objectAtIndex:1] intValue];
        
        int blue = [[array objectAtIndex:2] intValue];
        
      
        int alpha = 1;
        
        red = red > 125?0:255;
        green = green > 125?0:255;
        blue = blue > 125?0:255;
        
        
        return [self colorWithIntR:red andG:green andB:blue withAlpha:alpha];
    }
    
    
    return [self colorWithIntR:0 andG:0 andB:0 withAlpha:1.0f];
    
    
}

+ (UIColor *)hexStringToColor:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor blackColor];
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexNumber:(NSUInteger)hexColor {
    float r = ((hexColor>>16) & 0xFF) / 255.0f;
    float g = ((hexColor>>8) & 0xFF) / 255.0f;
    float b = (hexColor & 0xFF) / 255.0f;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}


@end
