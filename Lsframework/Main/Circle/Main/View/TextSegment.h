//
//  TextSegment.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextSegment : NSObject

@property(nullable,nonatomic,copy) NSString* text;

@property (nonatomic, assign) NSRange range;

@property (nonatomic, assign, getter=isSpecial) BOOL special;

@property (nonatomic, assign, getter=isEmotion) BOOL emotion;


@end
