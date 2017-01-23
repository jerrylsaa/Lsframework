//
//  SystemNotice.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemNotice : NSObject
/*
 {
 "RowID": 11,
 "uuid": 18,
 "DialogID": 1,
 "SendUserID": -1,
 "ReceiveUserID": 48,
 "Content": "您有一条新的咨询追问待回答，请查看哦!",
 "SendStatus": 0,
 "ReceiveStatus": 0,
 "CreateDate": "2016-12-12 16:54:30",
 "Time": "2016/12/12",
 "IsRead": false,
 "ModifyDate": null,
 "SendNickName": "系统消息",
 "SendUserImg": null,
 "ReceiveNickName": "美眉",
 "ReceiveUserImg": "/attach_upload/201612/01/201612011610263187.jpg",
 "Type": 9,
 "Params": "{\"uuid\":\"62\",\"TraceID\":\"62\",\"type\":\"1\",\"Expert_ID\":\"1\",\"ConsultationContent\":\"哈啦啦\",\"Image1\":\"\",\"Image2\":\"\",\"Image3\":\"\",\"CreateTime\":\"2016/12/12 16:54:30\",\"HearCount\":\"0\",\"ImageUrl\":\"http://121.42.15.43:9020/MobileHtml/images/zhaodongmei.jpg\",\"DoctorName\":\"赵冬梅\"}"
 }
 */
@property(nonatomic,strong)NSNumber *RowID;
@property(nonatomic,strong)NSNumber *uuid;
@property(nonatomic,strong)NSNumber *DialogID;
@property(nonatomic,strong)NSNumber *SendUserID;
@property(nonatomic,strong)NSNumber *ReceiveUserID;
@property(nonatomic,strong)NSString *Content;
@property(nonatomic,strong)NSNumber *SendStatus;
@property(nonatomic,strong)NSNumber *ReceiveStatus;
@property(nonatomic,strong)NSString *CreateDate;
@property(nonatomic,strong)NSString *Time;
@property(nonatomic,assign)BOOL IsRead;
@property(nonatomic,strong)NSString *ModifyDate;
@property(nonatomic,strong)NSString *SendNickName;
@property(nonatomic,strong)NSString *SendUserImg;
@property(nonatomic,strong)NSString *ReceiveNickName;
@property(nonatomic,strong)NSString *ReceiveUserImg;
@property(nonatomic,strong)NSString *Type;
@property(nonatomic,strong)NSString *Params;


@end
