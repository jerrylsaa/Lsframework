//
//  JMDataModel.h
//  doctors
//
//  Created by 梁继明 on 16/4/3.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMDataModel : NSObject

@property (nonatomic,copy) NSString *dateStr;

//每个model的标记.
//yyyy-mm-dd;
@property (nonatomic,copy) NSString *dateStrWithFormate;

@property (nonatomic,assign) NSTimeInterval startTimeInterval;

@end
