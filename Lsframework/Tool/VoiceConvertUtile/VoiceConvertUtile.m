//
//  VoiceConvertUtile.m
//  FamilyPlatForm
//
//  Created by lichen on 16/7/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "VoiceConvertUtile.h"

@implementation VoiceConvertUtile



+ (NSString*)GetPathByFileName:(NSString *) fileName ofType:(NSString *) type{
    
    NSString *directory = [NSString getVoicePath];
    
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:fileName]
                                stringByAppendingPathExtension:type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}


@end
