//
//  UILabel+VerticalAlignment.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegexKitLite.h"
#import "TextSegment.h"

typedef enum UITextVerticalAlignment {
    UITextVerticalAlignmentTop,
    UITextVerticalAlignmentMiddle,
    UITextVerticalAlignmentBottom
} UITextVerticalAlignment;

@interface UILabel(VerticalAlignment)

// getter
-(UITextVerticalAlignment)textVerticalAlignment;

// setter
-(void)setTextVerticalAlignment:(UITextVerticalAlignment)textVerticalAlignment;



/**
 富文本转换

 @param text <#text description#>

 @return <#return value description#>
 */
+ (NSMutableAttributedString*)getAttributeTextWithString:(NSString*) text;


+(NSMutableAttributedString*)attriubteWithDestnationStr:(NSString*) destText sourceStr:(NSString*) srcText foregroundColor:(UIColor*) color;


@end
