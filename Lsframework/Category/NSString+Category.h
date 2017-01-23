//
//  NSString+Category.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

-(BOOL)isPhoneNumber;


/**
 *  验证手机号格式
 *
 *  @param phone 获取手机号码
 *
 *  @return 返回值为BOOL，验证通过返回YES，失败返回NO
 */
- (BOOL)checkPhone;

- (NSDictionary*)dictionary;

/**
 *  获取文件的上传路径
 *
 *  @return 上传路径
 */
- (NSMutableString*)getUploadPath;

/**
 *  去掉字符串中的空格
 *
 *  @return <#return value description#>
 */
- (NSString*)trimming;

/**
 *  判断字符串是不是纯数字
 */
- (BOOL)isPureNumber;

/**
 *  删除字符串中指定的字符
 *
 *  @param deleteStr <#deleteStr description#>
 *
 *  @return <#return value description#>
 */
- (NSString* )deleteCharacter:(NSString*) deleteStr;


/**
 *  校验浮点数
 *
 *  @return <#return value description#>
 */
- (BOOL)regexNumber;

/**
 *  保存文本到本地
 *
 *  @param text    <#text description#>
 *  @param keyPath key值
 */
- (void)saveText:(NSString*) keyPath;

+ (void)clearText:(NSString*) keyPath;

+ (NSString*)showContent:(NSString*) keyPath;



/**
 *  判断文件是否存在
 *
 *  @param filePath <#filePath description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)fileIsExist:(NSString*) filePath;

/**
 *  获取下载音频文件的位置
 *
 *  @param voiceURL <#voiceURL description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)getDownloadPath:(NSString*) voiceURL;

/**
 *  生成文件路径
 *
 *  @param fileName <#fileName description#>
 *  @param type     <#type description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)GetPathByFileName:(NSString *) fileName ofType:(NSString *) type;

/**
 *  获取文件名
 *
 *  @param downloadPath <#downloadPath description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)getFileName:(NSString*) downloadPath;

/**
 *  是否需要转码
 *
 *  @param downloadPath <#downloadPath description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isNotNeedConvertAmrToWav:(NSString*)downloadPath;


+ (NSURL*)getAudioURL:(NSString*) downloadPath;

/**
 *  url解码
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)URLDecodedString:(NSString *)str;

- (NSMutableArray *)getSingleUploadPath;

/**
 *  获取更新压缩包本地地址
 *
 *  @return <#return value description#>
 */
+ (NSString*)getPatchZipPath;

/**
 *  获取存放声音文件地址
 *
 *  @return <#return value description#>
 */
+ (NSString *)getVoicePath;
+ (void )createVoicePath;


/**
 删除文件

 @param filePath 文件路径

 @return <#return value description#>
 */
+ (BOOL)deleteFileWithPath:(NSString*) filePath;


@end
