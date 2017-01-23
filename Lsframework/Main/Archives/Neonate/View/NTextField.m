//
//  NTextField.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "NTextField.h"
#import "JMFoundation.h"

@implementation NTextField

- (CGRect)textRectForBounds:(CGRect)bounds{
    
    NSString* text = self.text;
    CGFloat width = [JMFoundation calLabelWidth:self.font andStr:text withHeight:self.height];
    
    CGRect textRect = [super textRectForBounds:bounds];
    CGFloat space = bounds.size.width/2.0-width/2.0;
    textRect.origin.x = space;
    
    return textRect;
}


@end
