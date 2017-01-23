//
//  UploadPath.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadPath : NSObject

@property(nonatomic,retain) NSMutableArray* urls;//图片urls

@property(nonatomic,retain) NSURL* sickDescribeURL;//病情描述语音url

@property(nonatomic,retain) NSURL* medicalURL;//药物使用语音url


@end
