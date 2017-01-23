//
//  JMFoundation.m
//  FansGroup0307
//
//  Created by 梁继明 on 16/3/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "JMFoundation.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "MD5Hash.h"
#import "AESCrypt.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSString+Base64.h"
#import "NSData+Encrypt.h"


@implementation JMFoundation


+ (NSString *)getLocalTime{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long dTime = [[NSNumber numberWithDouble:time]longValue];
    return [[NSString alloc] initWithString:[NSString stringWithFormat:@"%ld",dTime]];
    
}

+(NSString *)getTime:(NSTimeInterval) time WithFormat:(NSString *)formate{
    
    NSDate* now = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [formatter setDateFormat:formate];
    
    NSString  *newdate=[formatter stringFromDate:now];
    
    return newdate;
    
    
}
+ (NSString *) sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


//时间差转天数

+(NSString *)transForTimeToString:(NSTimeInterval )time {
    
    NSTimeInterval now =  [[NSDate date] timeIntervalSince1970];
    
    double whole = now - time;
    
    
    double min = whole / 60;
    
    if (min < 60) {
        return [NSString stringWithFormat:@"%.f 分钟前",min];
    }
    
    double hour = min / 60;
    
    if (hour < 24) {
        return [NSString stringWithFormat:@"%.f 小时前",hour];
    }
    
    double day = hour / 24;
    
    if (day > 30) {
      
        return [self getTime:time WithFormat:@"yyyy-MM-dd"];
    }
    
    return [NSString stringWithFormat:@"%.f 天前",day];
    
    
    
}



+(CGFloat)calLabelHeight:(UIFont *)fontSize andStr:(NSString *)str withWidth:(CGFloat)width{
    
    
    NSDictionary *attribute = @{NSFontAttributeName: fontSize};
    
    CGSize retSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize.height;
    
    
    
}

+(CGFloat)calLabelWidth:(UIFont *)fontSize andStr:(NSString *)str withHeight:(CGFloat)height{
    NSDictionary *attribute = @{NSFontAttributeName: fontSize};
    
    CGSize retSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize.width;
}


+(BOOL) isFileExits:(NSString *)url{
    
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    NSURL *fileUrl = [NSURL URLWithString:url];
    NSString *fileName = [[fileUrl pathComponents] lastObject];
    
    documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:documentsDirectoryURL.path]) {
        // date = [fileManager attributesOfItemAtPath:documentsDirectoryURL.path error:nil][NSFileModificationDate];
        
        return YES;
    }
    
    
    return NO;
    
    
}

+(NSString*)getVersion{
    
    NSString * versionStr =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return versionStr;
    
}


+(NSURL *)getFilrWithUrl:(NSString *)str{
    
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    NSURL *fileUrl = [NSURL URLWithString:str];
    NSString *fileName = [[fileUrl pathComponents] lastObject];
    
    documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:documentsDirectoryURL.path]) {
        // date = [fileManager attributesOfItemAtPath:documentsDirectoryURL.path error:nil][NSFileModificationDate];
        
        return documentsDirectoryURL;
    }
    
    return nil;
    
}

+(NSString *) transKBToString:(NSInteger )size{

    NSString *str ;
    
    if (size > 1000) {
        
        str = [NSString stringWithFormat:@"%.2f MB",size *0.001f];
    
    }else{
        str = [NSString stringWithFormat:@"%ld KB",size ];
        
    }
    
    return str;


}

+(NSString *)encryptForFamilyPaltForm:(NSString *)string{
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    data = [data AES256ParmEncryptWithKey:kLoginKey];
    NSLog(@"AES加密前：%@", string);
    NSString* encrypt = [NSString base64StringFromData:data length:data.length];
    NSLog(@"AES加密后：%@", encrypt);
    encrypt = [MD5Hash get32MD5Hash:encrypt];
    NSLog(@"MD5加密后：%@", encrypt);
    return encrypt;
}

+ (void)saveProvinceToDatabase:(NSArray *)array{
//    [ProvinceEntity MR_importFromArray:array inContext:[NSManagedObjectContext MR_defaultContext]];
//    
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
//        if(contextDidSave){
//        
//        }else{
//        
//        }
//    }];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        [ProvinceEntity MR_importFromArray:array inContext:localContext];
    }];
    
}

+ (CGFloat )calLabelHeght:(UILabel *)label{
    return [self calLabelHeight:label.font andStr:label.text withWidth:label.width];
}

+ (CGFloat )calLabelWidth:(UILabel *)label{
    return [self calLabelWidth:label.font andStr:label.text withHeight:label.height];
    
}
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = size.width;
    
    CGFloat targetHeight = size.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        
        CGFloat widthFactor = targetWidth / width;
        
        CGFloat heightFactor = targetHeight / height;
        
        
        if(widthFactor > heightFactor){
            
            scaleFactor = widthFactor;
            
            
        }
        
        else{
            
            
            scaleFactor = heightFactor;
            
        }
        
        scaledWidth = width * scaleFactor;
        
        scaledHeight = height * scaleFactor;
        
        
        if(widthFactor > heightFactor){
            
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            
        }
        
    }
    
    
    UIGraphicsBeginImageContext(size);
    
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    
    thumbnailRect.size.width = scaledWidth;
    
    thumbnailRect.size.height = scaledHeight;
    
    
    [sourceImage drawInRect:thumbnailRect];
    
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
        
    }
    
    
    UIGraphicsEndImageContext();
    
    return newImage;

}

#pragma  mark--- 获取图片的大小
+(CGSize)GetImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }

    
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];
  
 return CGSizeMake(image.size.width, image.size.height);
    
   
}

@end
