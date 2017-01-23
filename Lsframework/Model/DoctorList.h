//
//  DoctorList.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorList : NSObject

@property(nonatomic,assign) NSInteger rowID;
@property(nonatomic,copy) NSString* UserName;//医生姓名
@property(nonatomic,copy) NSString* ProfessionalName;//职称
@property(nonatomic,copy) NSString* UserSex;
@property(nonatomic,copy) NSString* DepartName;//科室
@property(nonatomic,assign) NSInteger UserBrithday;//出生日期
@property(nonatomic,copy) NSString* Field;//领域
@property(nonatomic,assign) NSInteger PatientNum;//患者数量
@property(nonatomic,assign)NSInteger FollowUp;//随访人数
@property(nonatomic,assign)NSInteger StarNum;//星级
@property(nonatomic) NSInteger SignNum;//签约患者
@property(nonatomic,copy)NSString *UserImg;//医生头像
@property(nonatomic,copy) NSString* DoctorTitle;//职称2

@property(nonatomic,strong)NSNumber *DoctorID;//医生ID
@property(nonatomic,strong)NSNumber *PraiseNum;//好评
@property(nonatomic,copy)NSString *HName;//执业地点

@property(nonatomic,assign) CGFloat TextPrice;//在线沟通价格
@property(nonatomic,copy) NSString* TextTime;//在线沟通时常
@property(nonatomic,copy)NSString* TextUnit;//在线沟通单位
@property(nonatomic,assign) NSInteger TextState;//在线沟通状态，0关闭，1在线
@property(nonatomic,assign) CGFloat AudioPrice;//音频咨询价格
@property(nonatomic,copy) NSString* AudioTime;//音频咨询时常
@property(nonatomic,copy)NSString* AudioUnit;//音频咨询单位
@property(nonatomic,assign) NSInteger AudioState;//音频咨询状态，0关闭，1在线
@property(nonatomic,assign) CGFloat VideoPrice;//视频咨询价格
@property(nonatomic,copy) NSString* VideoTime;//视频咨询时常
@property(nonatomic,copy)NSString* VideoUnit;//视频咨询单位
@property(nonatomic,assign) NSInteger VideoState;//视频咨询状态，0关闭，1在线

@property(nonatomic,copy) NSString* LX;//百度地图坐标x
@property(nonatomic,copy) NSString* LY;//百度地图坐标y


/***/
@property(nonatomic,copy)NSString* serviceOutdate;//服务到期
@property(nonatomic) BOOL applySuccess;//申请成功
@property(nonatomic,retain) NSNumber* OnLineState;
@property(nonatomic,retain) NSNumber* num;//签约患者
@property(nonatomic,retain) NSNumber* ConsultNum;//咨询患者
//@property(nonatomic,retain) NSString* DoctorTitle;


@end
