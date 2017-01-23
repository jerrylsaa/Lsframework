//
//  ACPhoneConsultationPresenter.h
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "BabayArchList.h"

@protocol ACPhoneConsultationPresenterDelegate <NSObject>

@optional

- (void)onCompletation:(BOOL) success info:(NSString*) info;

- (void)uploadImageCompletation:(BOOL) success;

- (void)commitCompletation:(BOOL) success info:(NSString*) info;

@end

@interface ACPhoneConsultationPresenter : BasePresenter

@property(nonatomic,weak) id<ACPhoneConsultationPresenterDelegate> delegate;

@property(nonatomic,retain) NSMutableArray<BabayArchList* > * dataSource;
@property(nonatomic,copy) NSString* uploadPath;

/** 电话咨询信息*/
@property(nonatomic) NSUInteger userID;//登录人id
@property(nonatomic,copy) NSString* babyName;//孩子姓名
@property(nonatomic,copy) NSString* diseaseName;//所患疾病
@property(nonatomic,copy) NSString* descriptionDisease;//病情描述
@property(nonatomic,copy) NSString* descriptionDiseaseImage;//病情描述图片
@property(nonatomic) NSUInteger askDoctorID;//咨询的医生的Userid
@property(nonatomic,copy) NSString* feeNormal;//收费标准
@property(nonatomic,copy) NSString* feeUnit;//收费单位
@property(nonatomic) NSUInteger feeSequence;//收费次数
@property(nonatomic,copy) NSString* feeTime;//收费时长




/**
 *  获取所有绑定的儿童信息
 */
- (void)getBabyArchives;

/**
 *  上传图片
 *
 *  @param urls <#urls description#>
 */
- (void)uploadDescriptionDiseaseImage:(NSMutableArray*) urls;



- (void)commitPhoneConsultation;









@end
