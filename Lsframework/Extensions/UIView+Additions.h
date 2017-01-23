//
//  UIView+Additions.h
//  ZDComponents
//
//  Created by zhuchao on 13-12-19.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

@end

typedef enum {
    UIViewBorderOptionTop = 0,
    UIViewBorderOptionRight,
    UIViewBorderOptionBottom,
    UIViewBorderOptionLeft,
    UIViewBorderOptionAll
}UIViewBorderOption;

@interface UIView (Border)

- (void) setBorder: (UIViewBorderOption)option  width:(CGFloat)width color: (UIColor *)color;
- (void) setDashBorder: (UIViewBorderOption)option  width:(CGFloat)width color: (UIColor *)color;
- (void) roundCornerWithDashBorder: (CGFloat)radius width: (CGFloat)widht color: (UIColor *)color;

@end


@interface UIView (FrameAdditions)
@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) double width;
@property (nonatomic) double height;
@property (nonatomic,getter = y,setter = setY:) double top;
@property (nonatomic,getter = x,setter = setX:) double left;
@property (nonatomic) double buttom;
@property (nonatomic) double right;
@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint origin;
@end


@interface UIView(ScreenShot)

+ (UIImage *)screenShot;

@end



@interface UIView (TKCategory)


// DRAW GRADIENT
+ (void) drawGradientInRect:(CGRect)rect withColors:(NSArray*)colors;
+ (void) drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colors;


// DRAW ROUNDED RECTANGLE
+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color;

// DRAW LINE
+ (void) drawLineInRect:(CGRect)rect red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors;
+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors width:(CGFloat)lineWidth cap:(CGLineCap)cap;

@end






