//
//  SFPhoto.h
//
//
//  Created by laoshifu on 15/9/15.
//  Copyright (c) 2015年 laoshifu All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFPhoto : NSObject

@property (nonatomic, strong) NSURL *url; // 大图的URL
@property (nonatomic, strong) UIImageView *srcImageView; // 来源view
@property (nonatomic, strong, readonly) UIImage *placeholder;//占位图
@property (nonatomic, assign) BOOL isSelectImg;//是否被选中

//@property (nonatomic, strong, readonly) UIImage *capture;

@end