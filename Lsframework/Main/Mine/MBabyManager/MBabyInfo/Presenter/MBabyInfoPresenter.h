//
//  MBabyInfoPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "BabayArchList.h"
#import "BabyInfoDetail.h"
#import "UIImage+Category.h"
#import "DefaultChildEntity.h"

@protocol MBabyInfoPresenterDelegate <NSObject>

- (void)onCompletion:(BOOL) success info:(NSString*) info;

- (void)deleteOnCompletion:(BOOL) success info:(NSString*) info;

- (void)updateChildAvater:(BOOL) success info:(NSString*) info;

@end

@interface MBabyInfoPresenter : BasePresenter

@property(nonatomic,weak) id<MBabyInfoPresenterDelegate> delegate;

@property(nonatomic,retain) BabyInfoDetail* babyInfo;

/**
 *  获取孩子详细信息
 */
- (void)getBabyInfo:(NSInteger) babyID;

/**
 *  删除关联baby
 */
- (void)deleteConnectBaby;


/**
 更新宝宝头像

 @param image <#image description#>
 */
- (void)updateChildAvaterWithImage:(UIImage*) image andChildID:(NSNumber*) childID;

@end
