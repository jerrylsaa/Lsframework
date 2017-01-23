//
//  NSString+Category.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "NSString+Category.h"


@implementation NSString (Category)

static NSString * key = @"zhonghong8268793";

-(BOOL)isPhoneNumber{
    NSString*pattern =@"^1+[3578]+\\d{9}";
    NSPredicate*pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)checkPhone
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,176.170
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[06])\\d{8}$";
   
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";

    
    
    
    
    
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
   
    
    
    //新增移动  183段手机号码
    /**
    * 中国移动：China Mobile
    * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
    */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";


    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";

    
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
  /*
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        if([regextestcm evaluateWithObject:self] == YES) {
            //            NSLog(@"China Mobile");
        } else if ([regextestcu evaluateWithObject:self] == YES) {
            //            NSLog(@"China Unicom");
        } else {
            //            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
   */
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }

}

-(NSDictionary *)dictionary{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        return nil;
    }
    return dic;
}


- (NSMutableString *)getUploadPath{
    NSArray* subStringArray= [self componentsSeparatedByString:@","];
    
    NSMutableString* resultString=[NSMutableString string];
    
    for(NSString* subStr in subStringArray){
        if(subStr.length!=0){
            NSArray* subsubStrArray=[subStr componentsSeparatedByString:@"|"];
            [resultString appendString:[subsubStrArray lastObject]];
            [resultString appendString:@"|"];
        }
    }
    
    [resultString deleteCharactersInRange:NSMakeRange(resultString.length-1, 1)];
    
    return resultString;
}

- (NSMutableArray *)getSingleUploadPath{
    NSArray* subStringArray= [self componentsSeparatedByString:@","];
    
    NSMutableArray * resultArr =[NSMutableArray array];
    for(NSString* subStr in subStringArray){
        if(subStr.length!=0){
            NSArray* subsubStrArray=[subStr componentsSeparatedByString:@"|"];
            NSMutableString* resultString=[NSMutableString string];

            [resultString appendString:[subsubStrArray lastObject]];
            [resultArr addObject:resultString];
        }
    }
    return resultArr;
}

-(NSString *)trimming{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 *  是否是纯数字
 *
 *  @return <#return value description#>
 */
-(BOOL)isPureNumber{
    
    NSString* result = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(result.length>0){
        return NO;
    }else{
        return YES;
    }
}

-(NSString *)deleteCharacter:(NSString *)deleteStr{

    NSRange range = [self rangeOfString:deleteStr];
    if(range.location != NSNotFound){
        NSMutableString* temp = [NSMutableString stringWithString:self];
        [temp deleteCharactersInRange:range];
        return temp ;
    }
    return self;
}

-(BOOL)regexNumber{
    NSString* regex = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$";
    
    NSPredicate* pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pre evaluateWithObject:self];
}

- (void)saveText:(NSString *)keyPath{
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:keyPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)clearText:(NSString *)keyPath{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)showContent:(NSString *)keyPath{
   NSString* result = [[NSUserDefaults standardUserDefaults] objectForKey:keyPath];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return result;
}

+(BOOL)fileIsExist:(NSString *)filePath{

    NSString* homePath = [self getVoicePath];
    
    NSString* path = [homePath stringByAppendingPathComponent:filePath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        return YES;
    }
    return NO;
}

+ (NSString*)getDownloadPath:(NSString*) voiceURL{
    NSArray* result = [voiceURL componentsSeparatedByString:@"/"];
    
    NSString* homePath = [self getVoicePath];
    
    NSString* targetPath = [homePath stringByAppendingPathComponent:[result lastObject]];

    
    return targetPath;
}

+ (NSString*)GetPathByFileName:(NSString *) fileName ofType:(NSString *) type{
    
    NSString *directory = [self getVoicePath];
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:fileName]
                                stringByAppendingPathExtension:type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}

+(NSString *)getFileName:(NSString *)downloadPath{
    NSArray* result = [downloadPath componentsSeparatedByString:@"."];
    return [result firstObject];
}

+(BOOL)isNotNeedConvertAmrToWav:(NSString *)downloadPath{
    NSArray* result = [downloadPath componentsSeparatedByString:@"."];
    //文件名不带后缀
    NSString* fileName = [result firstObject];

    NSString* fileNameSuffix = [NSString stringWithFormat:@"%@.wav",fileName];
    
    return [self fileIsExist:fileNameSuffix];
}


+(NSURL *)getAudioURL:(NSString *)downloadPath{
    NSArray* result = [downloadPath componentsSeparatedByString:@"."];
    //文件名不带后缀
    NSString* fileName = [result firstObject];
    
    NSString* fileNameSuffix = [NSString stringWithFormat:@"%@.wav",fileName];
    NSString* homePath = [NSString getVoicePath];
    
    NSString* path = [homePath stringByAppendingPathComponent:fileNameSuffix];
    
    return [NSURL fileURLWithPath:path];
}

+(NSString *)URLDecodedString:(NSString *)str{

    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;

}

+ (NSString*)getPatchZipPath{
    
    NSString* homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString* targetPath = [homePath stringByAppendingPathComponent:@"patch"];
    
    
    return targetPath;
}

+ (NSString *)getVoicePath{
    NSString* homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString* targetPath = [homePath stringByAppendingPathComponent:@"voice"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return targetPath;
}

+ (void )createVoicePath{
    NSString* homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString* targetPath = [homePath stringByAppendingPathComponent:@"voice"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
//        [[NSFileManager defaultManager] removeItemAtPath:targetPath error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

+(BOOL)deleteFileWithPath:(NSString *)filePath{
    NSError* error;
    BOOL isDeleteSuceess = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    return isDeleteSuceess;
}

@end
