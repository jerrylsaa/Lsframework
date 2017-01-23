//
//  HWPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol HWPresenterDelegate <NSObject>

- (void)load:(BOOL)success message:(NSString *)message tips:(NSString *)tips isHeight:(BOOL)isHeight;

@end


@interface HWPresenter : BasePresenter

@property (nonatomic, weak) id<HWPresenterDelegate> delegate;

- (void)getAdviseByBody:(NSString *)birthday height:(NSString *)height weight:(NSString *)weight sex:(NSString *)sex;;


@end
