//
//  CircleEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "HEAParentQuestionEntity.h"
#import "NSDate+Category.h"

/*
 
 "RowID":1,
 "uuid":1,
 "UserID":8,
 "Expert_ID":1,
 "Title":null,
 "ConsultationContent":"十个多月的宝宝，一个多月以来一直大便绿色糊状颜色偏深，一天一两次或者两天一次。抗拒辅食。有食用益生菌，但还是没有见效。请问需要做什么处理吗？",
 "VoiceUrl":"/attach_upload//voice/201607/27/201607271837450373.amr",
 "HearCount":17,
 "ConsultationStatus":1,
 "ExpertPrice":100,
 "IsTop":0,
 "IsDelete":0,
 "CreateUser":"8",
 "CreateTime":"/Date(1469204648987)/",
 "ModificationUser":null,
 "ModificationDate":"/Date(1469644348413)/",
 "OrderID":"1.469248e+12",
 "Image1":null,
 "Image2":null,
 "Image3":null,
 "VoiceTime":null,
 "IsOpenImage":null,
 "NickName":"咯牙",
 "CHILD_IMG":"/attach_upload/201609/20/201609201046112026.png",
 "ConsultationType":1

 
 */

@interface CircleEntity : NSObject

@property(nonatomic) NSInteger rowID;
@property(nullable,nonatomic,retain) NSNumber* uuid;//
@property(nonatomic) NSInteger userID;
@property(nullable,nonatomic,retain) NSNumber* expertID;//
@property(nullable,nonatomic,copy) NSString* title;//图片墙，标题
@property(nullable,nonatomic,copy) NSString* consultationContent;
@property(nullable,nonatomic,copy) NSString* voiceUrl;
@property(nullable,nonatomic,retain) NSNumber* hearCount;
@property(nonatomic) NSInteger consultationStatus;
@property(nullable,nonatomic,retain) NSNumber* expertPrice;
@property(nonatomic) NSInteger isTop;
@property(nonatomic) NSInteger isDelete;
@property(nullable,nonatomic,copy) NSString* createUser;
//@property(nullable,nonatomic,copy) NSDate* createTime;
@property(nullable,nonatomic,copy) NSString* createTime;
@property(nullable,nonatomic,copy) NSString* modificationUser;
@property(nullable,nonatomic,copy) NSString* modificationDate;
@property(nullable,nonatomic,copy) NSString* orderID;
@property(nullable,nonatomic,copy) NSString* image1;
@property(nullable,nonatomic,copy) NSString* image2;
@property(nullable,nonatomic,copy) NSString* image3;
@property(nullable,nonatomic,copy) NSString* image4;
@property(nullable,nonatomic,copy) NSString* image5;
@property(nullable,nonatomic,copy) NSString* image6;
@property(nonatomic) NSInteger voiceTime;
@property(nullable,nonatomic,retain) NSNumber* isOpenImage;
@property(nullable,nonatomic,copy) NSString* nickName;
@property(nullable,nonatomic,copy) NSString* childImg;//
@property(nonatomic) NSInteger consultationType;//1语音，2.文字
@property(nullable,nonatomic,retain) NSNumber* isFree;//1限时免费
@property(nullable,nonatomic,retain) NSNumber* isListen;//1听过，0一元旁听
@property (nullable,nonatomic, strong) NSNumber *isPraise;
@property (nullable,nonatomic, strong) NSNumber *praiseCount;

//
@property(nullable,nonatomic,copy) NSString* doctorImageUrl;
@property(nullable,nonatomic,copy) NSString* doctorName;
@property(nullable,nonatomic,retain) NSNumber* commentCount;
@property(nullable,nonatomic,copy) NSString* WordContent;

+(HEAParentQuestionEntity* _Nonnull)convertCircleEntityToHEAParentQuestionEntity:(CircleEntity* _Nonnull) circleEntity;

@end
