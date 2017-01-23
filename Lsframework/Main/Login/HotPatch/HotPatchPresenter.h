//
//  HotPatchPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

typedef void(^LoadHandler)(BOOL success, NSString *path);

@interface HotPatchPresenter : BasePresenter

@property (nonatomic, copy) NSString *version;

- (void)loadLua:(LoadHandler)block;

@end
