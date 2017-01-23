//
//  MyReplyPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

typedef void(^isDoctor)(BOOL isDoctor, NSString *message);

@interface MyReplyPresenter : BasePresenter

- (void)getExperIDByUserID:(isDoctor) block;

@end
