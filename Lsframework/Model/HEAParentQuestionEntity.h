//
//  HEAParentQuestionEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HEAParentQuestionEntity : NSObject

/*
 
 "uuiD":4,
 "User_ID":105,
 "Expert_ID":1,
 "ConsultationContent":"小孩子怎么带最好呢？",
 "VoiceUrl":null,
 "HearCount":0,
 "ConsultationStatus":0,
 "ExpertPrice":100.12,
 "IsTop":0,
 "CreateUser":"105",
 "CreateTime":"/Date(1466627814630)/"
 
 
 
 
 {
 "IsFree": 0,
 "IsListen": 1,
 "uuiD": 87,
 "User_ID": 1,
 "Expert_ID": 1,
 "ConsultationContent": "测试两次，公开两张图片，中途取消再次提问",
 "VoiceUrl": "/attach_upload//voice/201608/26/201608261159224490.amr",
 "HearCount": 0,
 "ConsultationStatus": 1,
 "ExpertPrice": 10,
 "IsTop": 0,
 "CreateUser": "1",
 "CreateTime": "2016-08-26 11:54:36",
 "ImageUrl": "http://121.42.15.43:9020/MobileHtml/images/zhaodongmei.jpg",
 "VoiceTime": 4,
 "Image1": "/attach_upload/201608/26/201608261152119965.jpg",
 "Image2": "/attach_upload/201608/26/201608261152139282.jpg",
 "Image3": "",
 "IsOpenImage": true
 },

 
 */

@property(nonatomic,strong)NSString *RowID;

@property(nonatomic) NSInteger uuID;
@property(nonatomic,retain) NSNumber *Type;
@property(nonatomic) NSInteger userID;
@property(nonatomic,copy) NSString* consultationContent;
@property(nonatomic,copy) NSString* voiceUrl;
@property(nonatomic) NSInteger hearCount;
@property(nonatomic) NSInteger consultationStatus;
@property(nonatomic) CGFloat expertPrice;
@property(nonatomic) NSInteger isTop;
@property(nonatomic,copy) NSString* createUser;
@property(nonatomic,copy) NSString* createTime;
@property(nonatomic,assign) long VoiceTime;
/***/
@property(nonatomic,copy) NSString* userImageURL;
@property(nonatomic,retain) NSString* imageUrl;
@property(nonatomic) NSInteger praiseCount;
@property(nonatomic,copy) NSString* questionTime;//提问题时间
@property(nonatomic,retain) NSString* audioUrl;//音频url

@property(nonatomic) int isListen;//是否已经偷听过,0没有，1偷听了
@property(nonatomic) NSInteger expertID;//医生id
@property(nonatomic,copy) NSString *Image1;
@property(nonatomic,copy) NSString *Image2;
@property(nonatomic,copy) NSString *Image3;
@property(nonatomic,copy) NSString *Image4;
@property(nonatomic,copy) NSString *Image5;
@property(nonatomic,copy) NSString *Image6;
@property(nonatomic,retain) NSNumber *IsOpenImage;
@property(nonatomic,retain) NSNumber *IsFree;  //是否免费
@property(nonatomic,strong) NSNumber *isPraise;
@property(nonatomic,copy) NSString *nickName;
//@property(nonatomic) NSInteger RowID;


@property(nonatomic,retain) NSNumber* commentCount;
@property(nonatomic,copy) NSString *WordContent;





/**
 *  排序
 *
 *  @param array <#array description#>
 *
 *  @return 按听数量从大到小排序
 */
//+(NSArray<HEAParentQuestionEntity* > *)sortArray:(NSArray*) array;

@end
