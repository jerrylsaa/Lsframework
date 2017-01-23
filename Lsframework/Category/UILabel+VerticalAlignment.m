//
//  UILabel+VerticalAlignment.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "UILabel+VerticalAlignment.h"
#import <objc/runtime.h>

@implementation UILabel(VerticalAlignment)

-(UITextVerticalAlignment)textVerticalAlignment
{
    NSNumber *alignment = objc_getAssociatedObject(self, "UITextVerticalAlignment");
    
    if (alignment)
    {
        return [alignment intValue];
    }
    
    NSNumber *newAlignment = [NSNumber numberWithInt:1];
    objc_setAssociatedObject(self, "UITextVerticalAlignment", newAlignment, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return UITextVerticalAlignmentMiddle;
}

-(void)setTextVerticalAlignment:(UITextVerticalAlignment)textVerticalAlignment
{
    NSNumber *newAlignment = [NSNumber numberWithInt:textVerticalAlignment];
    objc_setAssociatedObject(self, "UITextVerticalAlignment", newAlignment, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsDisplay];
}

-(CGRect)verticalAlignTextRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [self verticalAlignTextRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    switch ([self textVerticalAlignment])
    {
        case UITextVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
            
        case UITextVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
            
        case UITextVerticalAlignmentMiddle:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            break;
    }
    
    return textRect;
}

-(void)verticalAlignDrawTextInRect:(CGRect)rect
{
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [self verticalAlignDrawTextInRect:actualRect];
}

+(void)load
{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(textRectForBounds:limitedToNumberOfLines:)), class_getInstanceMethod(self, @selector(verticalAlignTextRectForBounds:limitedToNumberOfLines:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(drawTextInRect:)), class_getInstanceMethod(self, @selector(verticalAlignDrawTextInRect:)));
}



+ (NSMutableAttributedString*)getAttributeTextWithString:(NSString*) text {
    NSString *emotionPattern = @"\\[[a-zA-Z\\u4e00-\\u9fa5]+\\]";
    NSMutableArray *parts = [NSMutableArray array];
    
    [text enumerateStringsMatchedByRegex:emotionPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if((* capturedStrings).length == 0) return ;
        
        TextSegment* seg = [TextSegment new];
        seg.text = *capturedStrings;
        seg.range = *capturedRanges;
        seg.special = YES;
        
        seg.emotion = [seg.text hasPrefix:@"["] && [seg.text hasSuffix:@"]"];
        
        [parts addObject:seg];
        
    }];
    
    [text enumerateStringsSeparatedByRegex:emotionPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if((* capturedStrings).length == 0) return ;
        
        TextSegment* seg = [TextSegment new];
        seg.text = *capturedStrings;
        seg.range = *capturedRanges;
        seg.special = NO;
        
        [parts addObject:seg];
        
    }];
    
    [parts sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        TextSegment* seg1 = (TextSegment*) obj1;
        TextSegment* seg2 = (TextSegment*) obj2;
        
        // 系统默认按照升序排列。
        if (seg1.range.location < seg2.range.location) {
            return NSOrderedAscending;
        }
        
        return NSOrderedDescending;
        
        
    }];
    NSMutableAttributedString* attributedText = [NSMutableAttributedString new];
    
    NSString* emotionPath = [[NSBundle mainBundle] pathForResource:@"EmotionPlist" ofType:@"plist"];
    NSArray* emotionDataSource = [NSArray arrayWithContentsOfFile:emotionPath];
    
    
    for(NSInteger i = 0; i < parts.count; i++){
        
        TextSegment* seg = [parts objectAtIndex:i];
        if(seg.isEmotion){
            //是emotion
            
            NSTextAttachment* attach = [NSTextAttachment new];
            
            for(NSDictionary* emotionDic in emotionDataSource){
                if([[emotionDic valueForKey:@"tag"] isEqualToString:seg.text]){
                    attach.image = [UIImage imageNamed:[emotionDic valueForKey:@"png"]];
                    break ;
                }
            }
            
            attach.bounds = CGRectMake(0, -3, 20, 20);
            
            NSAttributedString* emotionStr = [NSAttributedString attributedStringWithAttachment:attach];
            
            [attributedText appendAttributedString:emotionStr];
        }else{
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:seg.text]];
        }
    }
    return attributedText;
}

+(NSMutableAttributedString *)attriubteWithDestnationStr:(NSString *)destText sourceStr:(NSString *)srcText foregroundColor:(UIColor *)color{
    
    NSMutableAttributedString* reply1AttributeStr = [[NSMutableAttributedString alloc] initWithString:destText];
    
    NSRange range = [destText rangeOfString:srcText];
    [reply1AttributeStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    return reply1AttributeStr;
}

@end
