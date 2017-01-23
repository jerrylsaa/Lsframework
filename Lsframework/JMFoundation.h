//
//  JMFoundation.h
//  FansGroup0307
//
//  Created by 梁继明 on 16/3/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProvinceEntity.h"
#import "CityEntity.h"

@interface JMFoundation : NSObject

+ (NSString *)getLocalTime;

/**
 *  计算字符串高度
 *
 */
+(CGFloat)calLabelHeight:(UIFont *)fontSize andStr:(NSString *)str withWidth:(CGFloat)width;

/**
 *  计算字符串宽度
 *
 *  @param fontSize <#fontSize description#>
 *  @param str      <#str description#>
 *  @param height   <#height description#>
 *
 *  @return <#return value description#>
 */
+ (CGFloat)calLabelWidth:(UIFont*) fontSize andStr:(NSString*)str withHeight:(CGFloat)height;

/**
 *  根据时间戳，返回格式
 *
 */

+(NSString *)getTime:(NSTimeInterval) time WithFormat:(NSString *)formate;

/**
 *  解析时间戳，返回xx分，xx月日格式。
 *
 */
+(NSString *)transForTimeToString:(NSTimeInterval )time;

/**
 *  查询文件是否存在
 *
 */

+(BOOL) isFileExits:(NSString *)url;

+(NSURL *)getFilrWithUrl:(NSString *)str;

+(NSString*)getVersion;

+(NSString *) transKBToString:(NSInteger )size;

+(NSString *) sha1:(NSString *)input;

+ (NSString*)encryptForFamilyPaltForm:(NSString*)string;

/**
 *  保存省份到数据库
 *
 *  @param array <#array description#>
 */
+ (void)saveProvinceToDatabase:(NSArray*) array;

+ (CGFloat )calLabelHeght:(UILabel *)label;

+ (CGFloat )calLabelWidth:(UILabel *)label;

+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 *  <#Description#>
 *
 *  根据url获取图片的尺寸
 *
 *  @return 
 */

+(CGSize)GetImageSizeWithURL:(id)imageURL;

@end
