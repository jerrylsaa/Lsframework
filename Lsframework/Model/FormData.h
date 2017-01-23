//
//  FormData.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormData : NSObject

@property (nonatomic, strong) NSData * data;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * filePath;
@property (nonatomic, strong) NSString * fileName;
@property (nonatomic, strong) NSString * mimeType;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) NSString *hashCode;
@property (nonatomic, strong) NSNumber *fileSize;
@property (nonatomic, strong) NSNumber *fileIndex;
@property (nonatomic, strong) NSNumber *startIndex;
@property (nonatomic, strong) NSNumber *endIndex;
@end
