//
//  HospitalFileList.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HospitalFileList : NSObject

// 检查档案
@property (nonatomic, copy  ) NSString       *projectName;// 项目
@property (nonatomic, copy  ) NSString       *pacsContent;
@property (nonatomic, copy  ) NSString       *userName;
@property (nonatomic, copy  ) NSString       *hospitalName;
@property (nonatomic, assign) NSInteger      ID;
@property (nonatomic, copy  ) NSString       *babyName;
@property (nonatomic, assign) NSTimeInterval inspectTime;

// 电子档案
@property (nonatomic, copy  ) NSString  *chiefComplaint;// 主诉
@property (nonatomic, copy  ) NSString  *emrContent;// 病历详情

@end
