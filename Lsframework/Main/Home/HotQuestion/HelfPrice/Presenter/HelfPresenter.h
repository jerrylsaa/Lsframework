//
//  HelfPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

typedef void(^UploadComplete)(BOOL success, NSArray *UrlArray);

@interface HelfPresenter : BasePresenter

- (void)uploadPhoto:(NSMutableArray *)photoArray complete:(UploadComplete)block;

@end
