//
//  GBArchivesRecordPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "ChildForm.h"
#import "UIImage+Category.h"

typedef void(^Complete)(BOOL success ,NSString *message);

@protocol GBArchivesRecordPresenterDelegate <NSObject>

-(void)onCommitGBChildArchivesComplete:(BOOL) success info:(NSString*)info;


- (void)updateChildAvater:(BOOL) success info:(NSString*) info;

- (void)deleteOnCompletion:(BOOL) success info:(NSString*) info;

@end

@interface GBArchivesRecordPresenter : BasePresenter
@property (nonatomic, weak) id<GBArchivesRecordPresenterDelegate> delegate;
@property(nonatomic) NSUInteger childID;



/**
 *  提交新添加宝宝信息
 */
-(void)commitChildArchives:(ChildForm *)childForm;


-(void)commitChildArchives:(ChildForm *)childForm complete:(Complete)block;
/**
 *  把babyID绑定头像上传
 */

-(void)updateChildAvaterWithImage:(UIImage *)image andChildID:(NSNumber *)childID;

/**
 *  编辑更新宝宝信息
 */
- (void)updateChildArchives:(ChildForm*) childForm;


/**
 *  删除关联baby
 */
-(void)deleteConnectBabyWithBabyID:(NSNumber*)baby;


@end
