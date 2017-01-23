//
//  ContinuinglyPicturesPresenter.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol uploadImagesDelegate <NSObject>

- (void)sendMessage:(NSString *)message;

@end

@interface ContinuinglyPicturesPresenter : BasePresenter

@property (nonatomic, weak) id<uploadImagesDelegate>delegate;

- (void)requestWithImages:(NSArray *)photoArray withID:(NSInteger)ID;

@end
