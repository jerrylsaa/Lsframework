//
//  UploadInspectionFilePresenter.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol upCheckFileDelegate <NSObject>

- (void)sendMessage:(NSString *)message;

@end

@interface UploadInspectionFilePresenter : BasePresenter

@property (nonatomic, weak) id<upCheckFileDelegate>delegate;

- (void)requestWithHospitalID:(NSInteger)hospitalID withTimeStr:(NSString *)time withProjectID:(NSInteger)projectID withOther:(NSString *)other withPhotoArary:(NSArray *)photoArray;

- (void)requestWithHospitalID:(NSInteger)hospitalID withTimeStr:(NSString *)time withComplained:(NSString *)ComplainedStr withOther:(NSString *)other withPhotoArary:(NSArray *)photoArray;

@end
