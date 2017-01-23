//
//  UIImage+Category.h
//  PublicHealth
//
//  Created by Tom on 16/3/25.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
+ (UIImage*)imageWithColor:(UIColor*)color;
-(NSString *)saveToLocal;
/**
 *  图片压缩
 *
 *  @param source_image UIImage
 *  @param maxSize      压缩到多少KB
 *
 *  @return 
 */
- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize;

/**
 *  获取头像在本地的路径
 *
 *  @return <#return value description#>
 */
+ (NSString*)getHeaderURLInLocal;


@end
