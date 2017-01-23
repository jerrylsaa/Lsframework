//
//  UIImageView+Category.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Category)
-(void)setImageWithUrl:(NSString*)urlStr placeholderImage:(UIImage*)defaultImage;
-(void)setImageWithLocalImageName:(NSString *)name;
@end
