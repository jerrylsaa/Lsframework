//
//  VoiceConvertUtile.h
//  FamilyPlatForm
//
//  Created by lichen on 16/7/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceConvertUtile : NSObject

/**
 *  获取需要转码音频的文件路径
 *
 *  @param fileName <#fileName description#>
 *  @param type     <#type description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)GetPathByFileName:(NSString *) fileName ofType:(NSString *) type;


@end
