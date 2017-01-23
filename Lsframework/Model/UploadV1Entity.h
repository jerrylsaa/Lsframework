//
//  UploadV1Entity.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadV1Entity : NSObject
@property(nonatomic,strong) NSNumber *Finish;
@property(nonatomic,strong) NSNumber *FileHashCode;
@property(nonatomic,strong) NSNumber *FileSize;
@property(nonatomic,strong) NSNumber *FileName;
@property(nonatomic,strong) NSString *ServiceFilePath;
@end
