//
//  UIImageView+Category.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "UIImageView+Category.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Category)

-(void)setImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage *)defaultImage{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:defaultImage];
}

-(void)setImageWithLocalImageName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString* imagePath = [path stringByAppendingFormat:@"/%@", name];
    self.image = [UIImage imageWithContentsOfFile:imagePath];
}

@end
